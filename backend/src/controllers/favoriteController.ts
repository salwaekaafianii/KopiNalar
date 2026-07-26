import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Favorite from "../models/Favorite";

// ============================================================
// GET /favorites — Ambil semua favorit milik user
// ============================================================
export const getFavorites = async (req: AuthRequest, res: Response) => {
  try {
    const favorites = await Favorite.find({ userId: req.user?.id }).sort({ createdAt: -1 });
    res.json({ success: true, data: favorites });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal mengambil favorit" });
  }
};

// ============================================================
// POST /favorites — Tambah favorit baru
// ============================================================
export const addFavorite = async (req: AuthRequest, res: Response) => {
  try {
    const { name, category, price, rating, description, image, productId } = req.body;

    if (!name) {
      return res.status(400).json({ success: false, message: "Nama produk wajib diisi" });
    }

    // Cek apakah sudah pernah di-favorite
    const existing = await Favorite.findOne({ userId: req.user?.id, name });
    if (existing) {
      return res.status(400).json({ success: false, message: "Produk sudah di favorit" });
    }

    const newFavorite = await Favorite.create({
      userId: req.user?.id,
      name,
      category: category || "",
      price: price || "",
      rating: rating || "",
      description: description || "",
      image: image || "",
      productId: productId || "",
    });

    res.status(201).json({ success: true, data: newFavorite });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menambah favorit" });
  }
};

// ============================================================
// DELETE /favorites/:id — Hapus favorit berdasarkan product name
// ============================================================
export const removeFavorite = async (req: AuthRequest, res: Response) => {
  try {
    const { name } = req.params;
    const decodedName = decodeURIComponent(name as string);

    const favorite = await Favorite.findOneAndDelete({
      userId: req.user?.id,
      name: decodedName,
    });

    if (!favorite) {
      return res.status(404).json({ success: false, message: "Favorit tidak ditemukan" });
    }

    res.json({ success: true, message: "Favorit berhasil dihapus" });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menghapus favorit" });
  }
};

