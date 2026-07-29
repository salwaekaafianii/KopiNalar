import Product from "../models/Product";
import { Request, Response } from "express";
import { AuthRequest } from "../middleware/auth";

// ============================================================
// GET /products — Ambil semua produk
// ============================================================
export const getProducts = async (req: Request, res: Response) => {
  try {
    const products = await Product.find().sort({ createdAt: -1 });
    res.json(products);
  } catch (error) {
    console.error("Get products error:", error);
    res.status(500).json({ success: false, message: "Gagal mengambil produk" });
  }
};

// ============================================================
// POST /products — Tambah produk baru (admin only via route)
// ============================================================
export const createProduct = async (req: AuthRequest, res: Response) => {
  try {
    const { name, category, price, rating, description, image } = req.body;

    if (!name || !category || !price || !description) {
      return res.status(400).json({
        success: false,
        message: "Nama, kategori, harga, dan deskripsi wajib diisi",
      });
    }

    const product = await Product.create({
      name,
      category,
      price: Number(price),
      rating: rating ? Number(rating) : 0,
      description,
      image: image || "",
    });

    res.status(201).json({ success: true, data: product });
  } catch (error) {
    console.error("Create product error:", error);
    res.status(500).json({ success: false, message: "Gagal menambah produk" });
  }
};

// ============================================================
// PUT /products/:id — Update produk
// ============================================================
export const updateProduct = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { name, category, price, rating, description, image } = req.body;

    const updateData: Record<string, any> = {};
    if (name !== undefined) updateData.name = name;
    if (category !== undefined) updateData.category = category;
    if (price !== undefined) updateData.price = Number(price);
    if (rating !== undefined) updateData.rating = Number(rating);
    if (description !== undefined) updateData.description = description;
    if (image !== undefined) updateData.image = image;

    const product = await Product.findByIdAndUpdate(id, updateData, {
      new: true,
    });

    if (!product) {
      return res.status(404).json({ success: false, message: "Produk tidak ditemukan" });
    }

    res.json({ success: true, data: product });
  } catch (error) {
    console.error("Update product error:", error);
    res.status(500).json({ success: false, message: "Gagal memperbarui produk" });
  }
};

// ============================================================
// DELETE /products/:id — Hapus produk
// ============================================================
export const deleteProduct = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;

    const product = await Product.findByIdAndDelete(id);

    if (!product) {
      return res.status(404).json({ success: false, message: "Produk tidak ditemukan" });
    }

    res.json({ success: true, message: "Produk berhasil dihapus" });
  } catch (error) {
    console.error("Delete product error:", error);
    res.status(500).json({ success: false, message: "Gagal menghapus produk" });
  }
};
