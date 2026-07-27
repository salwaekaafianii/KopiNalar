import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Address from "../models/Address";

// ============================================================
// GET /address — Ambil semua alamat milik user
// ============================================================
export const getAddresses = async (req: AuthRequest, res: Response) => {
  try {
    let address = await Address.findOne({ userId: req.user?.id });

    if (!address) {
      // Buat dokumen kosong jika belum ada
      address = new Address({ userId: req.user?.id, items: [] });
      await address.save();
    }

    res.json({ success: true, data: address.items });
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

    // Cari atau buat dokumen address untuk user ini
    let address = await Address.findOne({ userId: req.user?.id });
    if (!address) {
      address = new Address({ userId: req.user?.id, items: [] });
    }

    // Tambah item baru
    address.items.push({
      label,
      alamat,
      kecamatan: kecamatan || "",
      kota: kota || "",
      lat: lat || "",
      lng: lng || "",
    });

    await address.save();

    res.status(201).json({ success: true, data: address.items });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menambah alamat" });
  }
};

// ============================================================
// DELETE /address/:label — Hapus alamat berdasarkan label
// ============================================================
export const deleteAddress = async (req: AuthRequest, res: Response) => {
  try {
    const { label } = req.params;
    const decodedLabel = decodeURIComponent(label as string);

    const result = await Address.updateOne(
      { userId: req.user?.id },
      { $pull: { items: { label: decodedLabel } } }
    );

    if (result.modifiedCount === 0) {
      return res.status(404).json({ success: false, message: "Alamat tidak ditemukan" });
    }

    // Ambil data terbaru
    const updated = await Address.findOne({ userId: req.user?.id });

    res.json({ success: true, message: "Alamat berhasil dihapus", data: updated?.items ?? [] });
  } catch (error) {
    res.status(500).json({ success: false, message: "Gagal menghapus alamat" });
  }
};

