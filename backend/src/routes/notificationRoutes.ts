import { Router } from "express";
import { verifyToken } from "../middleware/auth";
import {
  getNotifications,
  createNotification,
  markAsRead,
  markAllAsRead,
  deleteNotification,
} from "../controllers/notificationController";

const router = Router();

// Semua route membutuhkan autentikasi (token)
router.use(verifyToken);

router.get("/", getNotifications);
router.post("/", createNotification);
router.put("/read-all", markAllAsRead);
router.put("/:id/read", markAsRead);
router.delete("/:id", deleteNotification);

export default router;

