import { Router } from "express";
import { verifyToken } from "../middleware/auth";
import { getFavorites, addFavorite, removeFavorite } from "../controllers/favoriteController";

const router = Router();

// Semua route membutuhkan autentikasi (token)
router.use(verifyToken);

router.get("/", getFavorites);
router.post("/", addFavorite);
router.delete("/:name", removeFavorite);

export default router;

