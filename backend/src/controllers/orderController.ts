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

    const newOrder = await Order.create({
      userId: req.user?.id,
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
    });

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
    const orders = await Order.find({ userId: req.user?.id }).sort({ createdAt: -1 });
    res.json({ success: true, data: orders });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal mengambil pesanan" });
  }
};

// ============================================================
// GET /orders/:id — Ambil detail pesanan
// ============================================================
export const getOrderById = async (req: AuthRequest, res: Response) => {
  try {
    const order = await Order.findOne({
      _id: req.params.id,
      userId: req.user?.id,
    });

    if (!order) {
      return res.status(404).json({ success: false, message: "Pesanan tidak ditemukan" });
    }

    res.json({ success: true, data: order });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal mengambil detail pesanan" });
  }
};

