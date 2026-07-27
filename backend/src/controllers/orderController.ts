import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Order from "../models/Order";

// ============================================================
// POST /orders — Buat pesanan baru
// ============================================================
export const createOrder = async (req: AuthRequest, res: Response) => {
  try {
    const {
      items,
      totalPayment,
      shippingCost,
      paymentMethod,
      customer,
      address,
    } = req.body;

    if (!items || items.length === 0) {
      return res.status(400).json({ success: false, message: "Pesanan tidak boleh kosong" });
    }

    if (!customer?.name || !customer?.phone) {
      return res.status(400).json({ success: false, message: "Nama dan nomor HP wajib diisi" });
    }

    if (!address?.alamat) {
      return res.status(400).json({ success: false, message: "Alamat pengiriman wajib diisi" });
    }

    // Cari atau buat dokumen order untuk user ini
    let order = await Order.findOne({ userId: req.user?.id });
    if (!order) {
      order = new Order({ userId: req.user?.id, items: [] });
    }

    // Tambah order baru ke dalam array items
    order.items.push({
      items,
      totalPayment,
      shippingCost: shippingCost || 10000,
      paymentMethod,
      status: req.body.status || "pending",
      customer: {
        name: customer.name,
        phone: customer.phone,
      },
      address: {
        label: address.label || "",
        alamat: address.alamat,
        kecamatan: address.kecamatan || "",
        kota: address.kota || "",
        lat: address.lat || "",
        lng: address.lng || "",
      },
      createdAt: new Date(),
    });

    await order.save();

    // Ambil item yang baru ditambahkan (last item)
    const newOrder = order.items[order.items.length - 1];

    res.status(201).json({ success: true, data: newOrder });
  } catch (error) {
    console.error("Create order error:", error);
    res.status(500).json({ success: false, message: "Gagal membuat pesanan" });
  }
};

// ============================================================
// GET /orders — Ambil semua pesanan milik user
// ============================================================
export const getOrders = async (req: AuthRequest, res: Response) => {
  try {
    const order = await Order.findOne({ userId: req.user?.id });

    if (!order) {
      return res.json({ success: true, data: [] });
    }

    // Balik urutan (terbaru di atas)
    const sortedItems = order.items.slice().reverse();

    res.json({ success: true, data: sortedItems });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal mengambil pesanan" });
  }
};

// ============================================================
// GET /orders/:id — Ambil detail pesanan berdasarkan _id sub-document
// ============================================================
export const getOrderById = async (req: AuthRequest, res: Response) => {
  try {
    const order = await Order.findOne(
      { userId: req.user?.id },
      { items: { $elemMatch: { _id: req.params.id } } }
    );

    if (!order || !order.items || order.items.length === 0) {
      return res.status(404).json({ success: false, message: "Pesanan tidak ditemukan" });
    }

    res.json({ success: true, data: order.items[0] });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal mengambil detail pesanan" });
  }
};

