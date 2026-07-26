import { Router } from "express";
import { verifyToken } from "../middleware/auth";
import { createOrder, getOrders, getOrderById } from "../controllers/orderController";

const router = Router();

// Semua route membutuhkan autentikasi (token)
router.use(verifyToken);

router.post("/", createOrder);
router.get("/", getOrders);
router.get("/:id", getOrderById);

export default router;

