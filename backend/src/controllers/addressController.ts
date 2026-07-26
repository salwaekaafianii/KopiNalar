import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Address from "../models/Address";

// ============================================================
// GET /address — Ambil semua alamat milik user
// ============================================================
export const getAddresses = async (req: AuthRequest, res: Response) => {
  try {
    const addresses = await Address.find({ userId: req.user?.id }).sort({ createdAt: -1 });
    res.json({ success: true, data: addresses });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal mengambil alamat" });
  }
};

// ============================================================
// POST /address — Tambah alamat baru
// ============================================================
export const addAddress = async (req: AuthRequest, res: Response) => {
  try {
    const { label, alamat, kecamatan, kota, lat, lng } = req.body;

    if (!label || !alamat) {
      return res.status(400).json({ success: false, message: "Label dan alamat wajib diisi" });
    }

    const newAddress = await Address.create({
      userId: req.user?.id,
      label,
      alamat,
      kecamatan: kecamatan || "",
      kota: kota || "",
      lat: lat || "",
      lng: lng || "",
    });

    res.status(201).json({ success: true, data: newAddress });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menambah alamat" });
  }
};

// ============================================================
// DELETE /address/:id — Hapus alamat
// ============================================================
export const deleteAddress = async (req: AuthRequest, res: Response) => {
  try {
    const address = await Address.findOneAndDelete({
      _id: req.params.id,
      userId: req.user?.id,
    });

    if (!address) {
      return res.status(404).json({ success: false, message: "Alamat tidak ditemukan" });
    }

    res.json({ success: true, message: "Alamat berhasil dihapus" });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menghapus alamat" });
  }
};
