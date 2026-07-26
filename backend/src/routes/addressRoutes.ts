import { Router } from "express";
import { verifyToken } from "../middleware/auth";
import { getAddresses, addAddress, deleteAddress } from "../controllers/addressController";

const router = Router();

// Semua route membutuhkan autentikasi (token)
router.use(verifyToken);

router.get("/", getAddresses);
router.post("/", addAddress);
router.delete("/:id", deleteAddress);

export default router;
