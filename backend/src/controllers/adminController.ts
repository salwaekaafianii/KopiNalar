import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Order from "../models/Order";
import Notification from "../models/Notification";

// ============================================================
// GET /admin/orders — Ambil semua pesanan (admin only)
// ============================================================
export const getAllOrders = async (req: AuthRequest, res: Response) => {
  try {
    const orders = await Order.find({}).populate("userId", "name email").lean();

    // Format data agar mudah dibaca
    const allOrders: any[] = [];
    for (const order of orders) {
      for (const item of order.items) {
        allOrders.push({
          _id: item._id,
          userId: (order.userId as any)?._id,
          userName: (order.userId as any)?.name,
          userEmail: (order.userId as any)?.email,
          items: item.items,
          totalPayment: item.totalPayment,
          shippingCost: item.shippingCost,
          paymentMethod: item.paymentMethod,
          paymentProof: item.paymentProof || "",
          paymentStatus: item.paymentStatus || "unpaid",
          status: item.status,
          customer: item.customer,
          address: item.address,
          createdAt: item.createdAt,
        });
      }
    }

    // Urutkan dari terbaru
    allOrders.sort(
      (a, b) =>
        new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    );

    res.json({ success: true, data: allOrders });
  } catch (error) {
    console.error("Get all orders error:", error);
    res.status(500).json({ success: false, message: "Gagal mengambil semua pesanan" });
  }
};

// ============================================================
// GET /admin/orders/:id — Ambil detail pesanan berdasarkan sub-doc _id
// ============================================================
export const getOrderDetail = async (req: AuthRequest, res: Response) => {
  try {
    const order = await Order.findOne(
      { "items._id": req.params.id },
      { "items.$": 1, userId: 1 }
    ).populate("userId", "name email");

    if (!order) {
      return res.status(404).json({
        success: false,
        message: "Pesanan tidak ditemukan",
      });
    }

    const item = (order as any).items[0];
    const user = (order as any).userId;

    res.json({
      success: true,
      data: {
        _id: item._id,
        userId: user?._id,
        userName: user?.name,
        userEmail: user?.email,
        items: item.items,
        totalPayment: item.totalPayment,
        shippingCost: item.shippingCost,
        paymentMethod: item.paymentMethod,
        paymentProof: item.paymentProof || "",
        paymentStatus: item.paymentStatus || "unpaid",
        status: item.status,
        customer: item.customer,
        address: item.address,
        createdAt: item.createdAt,
      },
    });
  } catch (error) {
    console.error("Get order detail error:", error);
    res.status(500).json({ success: false, message: "Gagal mengambil detail pesanan" });
  }
};

// ============================================================
// PUT /admin/orders/:id/status — Update status pesanan
// ============================================================
export const updateOrderStatus = async (req: AuthRequest, res: Response) => {
  try {
    const { status } = req.body;
    const validStatuses = [
      "pending",
      "paid",
      "processing",
      "shipped",
      "delivered",
      "cancelled",
    ];

    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: `Status tidak valid. Pilihan: ${validStatuses.join(", ")}`,
      });
    }

    // Cari order yang memiliki sub-document dengan _id = req.params.id
    const order = await Order.findOne(
      { "items._id": req.params.id },
      { "items.$": 1, userId: 1 }
    );

    if (!order) {
      return res.status(404).json({
        success: false,
        message: "Pesanan tidak ditemukan",
      });
    }

    // Update status
    await Order.findOneAndUpdate(
      { "items._id": req.params.id },
      { $set: { "items.$.status": status } },
      { new: true }
    );

    // Kirim notifikasi ke user
    const statusMessages: Record<string, string> = {
      paid: "Pembayaran Anda telah dikonfirmasi. Pesanan sedang diproses.",
      processing: "Pesanan Anda sedang diproses.",
      shipped: "Pesanan Anda sedang dalam perjalanan!",
      delivered: "Pesanan Anda telah sampai. Selamat menikmati!",
      cancelled: "Maaf, pesanan Anda dibatalkan.",
    };

    const statusTitles: Record<string, string> = {
      paid: "Pembayaran Dikonfirmasi",
      processing: "Pesanan Diproses",
      shipped: "Pesanan Dikirim",
      delivered: "Pesanan Selesai",
      cancelled: "Pesanan Dibatalkan",
    };

    const title = statusTitles[status] || "Status Pesanan Diperbarui";
    const message =
      statusMessages[status] || `Status pesanan Anda telah diperbarui menjadi ${status}.`;

    // Push notification ke array items
    const userId = (order as any).userId;
    await Notification.findOneAndUpdate(
      { userId },
      {
        $push: {
          items: {
            title,
            message,
            type: "order",
            isRead: false,
            metadata: { orderId: req.params.id, status },
            createdAt: new Date(),
          },
        },
        $setOnInsert: { userId, userName: req.user?.name || "Admin" },
      },
      { upsert: true }
    );

    res.json({
      success: true,
      message: `Status pesanan berhasil diperbarui menjadi ${status}`,
    });
  } catch (error) {
    console.error("Update order status error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal memperbarui status pesanan",
    });
  }
};

// ============================================================
// PUT /admin/orders/:id/payment — Verifikasi / Tolak pembayaran
// ============================================================
export const verifyPayment = async (req: AuthRequest, res: Response) => {
  try {
    const { action, rejectReason } = req.body; // action: "accept" | "reject"

    if (!["accept", "reject"].includes(action)) {
      return res.status(400).json({
        success: false,
        message: "Aksi harus 'accept' atau 'reject'",
      });
    }

    const order = await Order.findOne(
      { "items._id": req.params.id },
      { "items.$": 1, userId: 1 }
    );

    if (!order) {
      return res.status(404).json({
        success: false,
        message: "Pesanan tidak ditemukan",
      });
    }

    const item = (order as any).items[0];

    // Validasi: hanya bisa verifikasi jika status = pending
    if (item.status !== "pending") {
      return res.status(400).json({
        success: false,
        message: "Pembayaran sudah pernah diverifikasi sebelumnya",
      });
    }

    // Validasi: harus ada bukti pembayaran
    if (!item.paymentProof) {
      return res.status(400).json({
        success: false,
        message: "Belum ada bukti pembayaran yang diupload",
      });
    }

    if (action === "accept") {
      // Terima pembayaran → set status ke "paid", paymentStatus ke "verified"
      await Order.findOneAndUpdate(
        { "items._id": req.params.id },
        {
          $set: {
            "items.$.status": "paid",
            "items.$.paymentStatus": "verified",
          },
        },
        { new: true }
      );

      const acceptUserId = (order as any).userId;
      await Notification.findOneAndUpdate(
        { userId: acceptUserId },
        {
          $push: {
            items: {
              title: "Pembayaran Diterima",
              message: "Pembayaran Anda telah dikonfirmasi. Pesanan sedang diproses.",
              type: "order",
              isRead: false,
              metadata: { orderId: req.params.id, status: "paid" },
              createdAt: new Date(),
            },
          },
          $setOnInsert: { userId: acceptUserId, userName: req.user?.name || "Admin" },
        },
        { upsert: true }
      );

      res.json({
        success: true,
        message: "Pembayaran berhasil diterima",
      });
    } else {
      // Tolak pembayaran → set paymentStatus ke "rejected", status tetap pending
      const reason = rejectReason || "Bukti pembayaran tidak valid";

      await Order.findOneAndUpdate(
        { "items._id": req.params.id },
        {
          $set: {
            "items.$.paymentStatus": "rejected",
          },
        },
        { new: true }
      );

      const rejectUserId = (order as any).userId;
      await Notification.findOneAndUpdate(
        { userId: rejectUserId },
        {
          $push: {
            items: {
              title: "Pembayaran Ditolak",
              message: `Pembayaran Anda ditolak. Alasan: ${reason}. Silakan upload ulang bukti pembayaran.`,
              type: "order",
              isRead: false,
              metadata: { orderId: req.params.id, status: "pending", rejectReason: reason },
              createdAt: new Date(),
            },
          },
          $setOnInsert: { userId: rejectUserId, userName: req.user?.name || "Admin" },
        },
        { upsert: true }
      );

      res.json({
        success: true,
        message: `Pembayaran ditolak. Alasan: ${reason}`,
      });
    }
  } catch (error) {
    console.error("Verify payment error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal memverifikasi pembayaran",
    });
  }
};

// ============================================================
// GET /admin/orders/stats — Statistik pesanan
// ============================================================
export const getOrderStats = async (req: AuthRequest, res: Response) => {
  try {
    const orders = await Order.find({}).lean();

    let totalOrders = 0;
    let totalRevenue = 0;
    const statusCount: Record<string, number> = {};

    for (const order of orders) {
      for (const item of order.items) {
        totalOrders++;
        totalRevenue += item.totalPayment || 0;
        statusCount[item.status] = (statusCount[item.status] || 0) + 1;
      }
    }

    res.json({
      success: true,
      data: {
        totalOrders,
        totalRevenue,
        statusCount,
      },
    });
  } catch (error) {
    console.error("Get order stats error:", error);
    res.status(500).json({ success: false, message: "Gagal mengambil statistik" });
  }
};

