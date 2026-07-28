import { Router, Request, Response, NextFunction } from "express";
import { verifyToken } from "../middleware/auth";
import { upload, uploadPaymentProof, handleMulterError } from "../controllers/uploadController";

const router = Router();

// Hanya user yang login bisa upload
// Gunakan callback manual agar error multer bisa ditangkap dengan baik
router.post("/", verifyToken, (req: Request, res: Response, next: NextFunction) => {
  upload.single("file")(req, res, (err) => {
    if (err) {
      return handleMulterError(err, req, res, next);
    }
    next();
  });
}, uploadPaymentProof);

export default router;

