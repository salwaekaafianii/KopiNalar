import { Request, Response, NextFunction } from "express";
import { AuthRequest } from "../middleware/auth";
import multer from "multer";
import path from "path";
import fs from "fs";

// Pastikan folder uploads ada
const uploadDir = path.join(__dirname, "../../uploads");
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// Konfigurasi multer: simpan ke folder uploads/
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, uploadDir);
  },
  filename: (_req, file, cb) => {
    // Generate unique filename: timestamp-random.ext
    const ext = path.extname(file.originalname) || ".jpg";
    const uniqueName = `payment_${Date.now()}_${Math.round(
      Math.random() * 1e9
  )}${ext}`;
    cb(null, uniqueName);
  },
});

// Filter hanya file gambar — juga terima application/octet-stream
// (yang dikirim oleh Flutter saat upload bytes tanpa contentType eksplisit)
const fileFilter = (
  _req: any,
  file: Express.Multer.File,
  cb: multer.FileFilterCallback
) => {
  const allowedMimes = [
    "image/jpeg",
    "image/jpg",
    "image/png",
    "image/gif",
    "image/webp",
    "application/octet-stream", // Flutter MultipartFile.fromBytes
  ];

  // Juga izinkan jika ekstensi file adalah gambar
  const allowedExts = [".jpg", ".jpeg", ".png", ".gif", ".webp"];
  const ext = path.extname(file.originalname).toLowerCase();

  if (allowedMimes.includes(file.mimetype) || allowedExts.includes(ext)) {
    cb(null, true);
  } else {
    cb(new Error("Hanya file gambar yang diizinkan (JPG, PNG, GIF, WebP)"));
  }
};

export const upload = multer({
  storage,
  fileFilter,
  limits: { fileSize: 5 * 1024 * 1024 }, // Max 5MB
});

// ============================================================
// Middleware untuk handle error multer (misal file terlalu besar)
// ============================================================
export const handleMulterError = (
  err: any,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  if (err instanceof multer.MulterError) {
    // Error dari multer (misal file too large)
    if (err.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        success: false,
        message: "Ukuran file terlalu besar. Maksimal 5MB",
      });
    }
    return res.status(400).json({
      success: false,
      message: err.message,
    });
  }

  if (err) {
    // Error lain (misal dari fileFilter)
    return res.status(400).json({
      success: false,
      message: err.message || "Gagal mengupload file",
    });
  }

  _next();
};

// ============================================================
// POST /upload — Upload bukti pembayaran
// ============================================================
export const uploadPaymentProof = async (
  req: AuthRequest,
  res: Response
) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "Tidak ada file yang diupload",
      });
    }

    // Buat URL path yang bisa diakses dari luar
    const fileUrl = `/uploads/${req.file.filename}`;

    console.log(`[UPLOAD] File saved: ${req.file.filename} (${req.file.size} bytes)`);

    res.status(201).json({
      success: true,
      data: {
        url: fileUrl,
        filename: req.file.filename,
        size: req.file.size,
        mimetype: req.file.mimetype,
      },
    });
  } catch (error) {
    console.error("Upload error:", error);
    res.status(500).json({
      success: false,
      message: "Gagal mengupload file",
    });
  }
};

