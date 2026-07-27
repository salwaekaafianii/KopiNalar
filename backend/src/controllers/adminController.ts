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

    await Notification.create({
      userId: (order as any).userId,
      title,
      message,
      type: "order",
      metadata: {
        orderId: req.params.id,
        status,
      },
    });

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

