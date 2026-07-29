import { Router } from "express";
import { verifyToken, verifyAdmin } from "../middleware/auth";
import {
  getAllOrders,
  getOrderDetail,
  updateOrderStatus,
  verifyPayment,
  getOrderStats,
} from "../controllers/adminController";

const router = Router();

// Semua route admin butuh token + role admin
router.use(verifyToken);
router.use(verifyAdmin);

router.get("/orders", getAllOrders);
router.get("/orders/stats", getOrderStats);
router.get("/orders/:id", getOrderDetail);
router.put("/orders/:id/status", updateOrderStatus);
router.put("/orders/:id/payment", verifyPayment);

export default router;

