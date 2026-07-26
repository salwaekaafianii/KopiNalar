import { Router } from "express";
import { getCart, syncCart, clearCart } from "../controllers/cartController";
import { verifyToken } from "../middleware/auth";

const router = Router();

// Semua route cart butuh token
router.get("/", verifyToken, getCart);
router.put("/sync", verifyToken, syncCart);
router.delete("/", verifyToken, clearCart);

export default router;

