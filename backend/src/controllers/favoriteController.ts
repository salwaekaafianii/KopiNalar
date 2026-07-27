import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Favorite from "../models/Favorite";

// ============================================================
// GET /favorites — Ambil semua favorit milik user
// ============================================================
export const getFavorites = async (req: AuthRequest, res: Response) => {
  try {
    let favorite = await Favorite.findOne({ userId: req.user?.id });

    if (!favorite) {
      // Buat dokumen kosong jika belum ada
      favorite = new Favorite({ userId: req.user?.id, items: [] });
      await favorite.save();
    }

    res.json({ success: true, data: favorite.items });
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

    // Cari atau buat dokumen favorite untuk user ini
    let favorite = await Favorite.findOne({ userId: req.user?.id });
    if (!favorite) {
      favorite = new Favorite({ userId: req.user?.id, items: [] });
    }

    // Cek apakah produk sudah ada di items
    const exists = favorite.items.some((item: any) => item.name === name);
    if (exists) {
      return res.status(400).json({ success: false, message: "Produk sudah di favorit" });
    }

    // Tambah item baru
    favorite.items.push({
      name,
      category: category || "",
      price: price || "",
      rating: rating || "",
      description: description || "",
      image: image || "",
      productId: productId || "",
    });

    await favorite.save();

    res.status(201).json({ success: true, data: favorite.items });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menambah favorit" });
  }
};

// ============================================================
// DELETE /favorites/:name — Hapus favorit berdasarkan product name
// ============================================================
export const removeFavorite = async (req: AuthRequest, res: Response) => {
  try {
    const { name } = req.params;
    const decodedName = decodeURIComponent(name as string);

    const result = await Favorite.updateOne(
      { userId: req.user?.id },
      { $pull: { items: { name: decodedName } } }
    );

    if (result.modifiedCount === 0) {
      return res.status(404).json({ success: false, message: "Favorit tidak ditemukan" });
    }

    // Ambil data terbaru
    const updated = await Favorite.findOne({ userId: req.user?.id });

    res.json({ success: true, message: "Favorit berhasil dihapus", data: updated?.items ?? [] });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menghapus favorit" });
  }
};

