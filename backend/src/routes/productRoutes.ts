import express from "express";
import { getProducts, createProduct, updateProduct, deleteProduct } from "../controllers/productController";
import { verifyToken, verifyAdmin } from "../middleware/auth";

const router = express.Router();

// Public: ambil semua produk
router.get("/", getProducts);

// Admin: CRUD produk
router.post("/", verifyToken, verifyAdmin, createProduct);
router.put("/:id", verifyToken, verifyAdmin, updateProduct);
router.delete("/:id", verifyToken, verifyAdmin, deleteProduct);

export default router;
