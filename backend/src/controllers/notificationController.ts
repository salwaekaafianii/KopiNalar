import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Notification from "../models/Notification";

// ============================================================
// GET /notifications — Ambil semua notifikasi milik user
// ============================================================
export const getNotifications = async (req: AuthRequest, res: Response) => {
  try {
    let notification = await Notification.findOne({ userId: req.user?.id });

    if (!notification) {
      // Buat dokumen kosong jika belum ada
      notification = new Notification({ userId: req.user?.id, userName: req.user?.name || "", items: [] });
      await notification.save();
    }

    // Balik urutan (terbaru di atas)
    const sortedItems = notification.items.slice().reverse();

    res.json({
      success: true,
      data: sortedItems,
    });
  } catch (error) {
    console.error("Get notifications error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal mengambil notifikasi",
    });
  }
};

// ============================================================
// POST /notifications — Buat notifikasi baru (internal/admin)
// ============================================================
export const createNotification = async (req: AuthRequest, res: Response) => {
  try {
    const { title, message, type, metadata } = req.body;

    if (!title || !message) {
      return res.status(400).json({
        success: false,
        message: "Title dan message wajib diisi",
      });
    }

    // Cari atau buat dokumen notification untuk user ini
    let notification = await Notification.findOne({ userId: req.user?.id });
    if (!notification) {
      notification = new Notification({ userId: req.user?.id, userName: req.user?.name || "", items: [] });
    }

    // Tambah item baru
    notification.items.push({
      title,
      message,
      type: type || "info",
      isRead: false,
      metadata: metadata || {},
      createdAt: new Date(),
    });

    await notification.save();

    // Ambil item yang baru ditambahkan (last item)
    const newItem = notification.items[notification.items.length - 1];

    res.status(201).json({
      success: true,
      data: newItem,
    });
  } catch (error) {
    console.error("Create notification error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal membuat notifikasi",
    });
  }
};

// ============================================================
// PUT /notifications/:id/read — Tandai notifikasi sebagai sudah dibaca
// ============================================================
export const markAsRead = async (req: AuthRequest, res: Response) => {
  try {
    const notification = await Notification.findOneAndUpdate(
      { "items._id": req.params.id, userId: req.user?.id },
      { $set: { "items.$.isRead": true } },
      { new: true }
    );

    if (!notification) {
      return res.status(404).json({
        success: false,
        message: "Notifikasi tidak ditemukan",
      });
    }

    const { id } = req.params;

    const updatedItem = notification.items.find(
      (item: any) => item._id.toString() === id
    );

    res.json({
      success: true,
      data: updatedItem,
    });
  } catch (error) {
    console.error("Mark as read error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal menandai notifikasi",
    });
  }
};

// ============================================================
// PUT /notifications/read-all — Tandai semua notifikasi sebagai sudah dibaca
// ============================================================
export const markAllAsRead = async (req: AuthRequest, res: Response) => {
  try {
    await Notification.updateOne(
      { userId: req.user?.id },
      { $set: { "items.$[].isRead": true } }
    );

    res.json({
      success: true,
      message: "Semua notifikasi telah ditandai sudah dibaca",
    });
  } catch (error) {
    console.error("Mark all as read error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal menandai semua notifikasi",
    });
  }
};

// ============================================================
// DELETE /notifications/:id — Hapus satu notifikasi
// ============================================================
export const deleteNotification = async (req: AuthRequest, res: Response) => {
  try {
    const notification = await Notification.findOneAndUpdate(
      { userId: req.user?.id },
      { $pull: { items: { _id: req.params.id } } },
      { new: true }
    );

    if (!notification) {
      return res.status(404).json({
        success: false,
        message: "Notifikasi tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Notifikasi berhasil dihapus",
    });
  } catch (error) {
    console.error("Delete notification error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal menghapus notifikasi",
    });
  }
};

