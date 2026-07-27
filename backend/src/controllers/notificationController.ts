import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import Notification from "../models/Notification";

// ============================================================
// GET /notifications — Ambil semua notifikasi milik user
// ============================================================
export const getNotifications = async (req: AuthRequest, res: Response) => {
  try {
    const notifications = await Notification.find({ userId: req.user?.id })
      .sort({ createdAt: -1 })
      .lean();

    res.json({
      success: true,
      data: notifications,
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

    const notification = new Notification({
      userId: req.user?.id,
      title,
      message,
      type: type || "info",
      metadata: metadata || {},
    });

    await notification.save();

    res.status(201).json({
      success: true,
      data: notification,
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
      { _id: req.params.id, userId: req.user?.id },
      { isRead: true },
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
      data: notification,
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
    await Notification.updateMany(
      { userId: req.user?.id, isRead: false },
      { isRead: true }
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
    const notification = await Notification.findOneAndDelete({
      _id: req.params.id,
      userId: req.user?.id,
    });

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

