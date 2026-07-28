import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import path from "path";

import { connectDB } from "./config/db";
import productRoutes from "./routes/productRoutes";
import authRoutes from "./routes/authRoutes";
import cartRoutes from "./routes/cartRoutes";
import addressRoutes from "./routes/addressRoutes";
import favoriteRoutes from "./routes/favoriteRoutes";
import orderRoutes from "./routes/orderRoutes";
import notificationRoutes from "./routes/notificationRoutes";
import uploadRoutes from "./routes/uploadRoutes";
// import adminRoutes from "./routes/adminRoutes";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ limit: "50mb", extended: true }));

connectDB();

// Serve file statis dari folder uploads
app.use("/uploads", express.static(path.join(__dirname, "../uploads")));

app.use("/products", productRoutes);
app.use("/auth", authRoutes);
app.use("/cart", cartRoutes);
app.use("/address", addressRoutes);
app.use("/favorites", favoriteRoutes);
app.use("/orders", orderRoutes);
app.use("/notifications", notificationRoutes);
app.use("/upload", uploadRoutes);
// app.use("/admin", adminRoutes);

const PORT = process.env.PORT || 5000;

// ============================================================
// Global error handler — pastikan SEMUA error balikin JSON
// ============================================================
app.use((err: any, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error("Unhandled error:", err);
  res.status(500).json({
    success: false,
    message: err?.message || "Terjadi kesalahan pada server",
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
