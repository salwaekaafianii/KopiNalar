import { Response } from "express";
import Cart from "../models/Cart";
import { AuthRequest } from "../middleware/auth";

// ============================================================
// GET CART — Ambil keranjang user yang login
// ============================================================
export const getCart = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: "Akses ditolak" });
    }

    let cart = await Cart.findOne({ userId });

    if (!cart) {
      // Buat cart kosong jika belum ada
      cart = new Cart({ userId, items: [] });
      await cart.save();
    }

    res.status(200).json({ cart });
  } catch (error) {
    console.error("Get cart error:", error);
    res.status(500).json({ message: "Gagal mengambil keranjang" });
  }
};

// ============================================================
// SYNC CART — Sinkronkan seluruh keranjang dari frontend
// ============================================================
export const syncCart = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: "Akses ditolak" });
    }

    const { items } = req.body;

    if (!Array.isArray(items)) {
      return res.status(400).json({ message: "Format items tidak valid" });
    }

    // Validasi setiap item
    const validItems = items.map((item: any) => ({
      productId: item.productId?.toString() || item.id?.toString() || "",
      name: item.name || "",
      price: item.price || 0,
      imageUrl: item.imageUrl || item.image || "",
      quantity: Math.max(1, item.quantity || 1),
      isSelected: item.isSelected !== undefined ? item.isSelected : true,
    }));

    // Cari cart user, update atau buat baru
    const cart = await Cart.findOneAndUpdate(
      { userId },
      { items: validItems },
      { new: true, upsert: true }
    );

    res.status(200).json({
      message: "Keranjang berhasil disinkronkan",
      cart,
    });
  } catch (error) {
    console.error("Sync cart error:", error);
    res.status(500).json({ message: "Gagal menyinkronkan keranjang" });
  }
};

// ============================================================
// CLEAR CART — Hapus semua item di keranjang
// ============================================================
export const clearCart = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: "Akses ditolak" });
    }

    await Cart.findOneAndUpdate(
      { userId },
      { items: [] },
      { new: true, upsert: true }
    );

    res.status(200).json({ message: "Keranjang berhasil dikosongkan" });
  } catch (error) {
    console.error("Clear cart error:", error);
    res.status(500).json({ message: "Gagal mengosongkan keranjang" });
  }
};

