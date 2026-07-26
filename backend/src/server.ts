import express from "express";
import cors from "cors";
import dotenv from "dotenv";

import { connectDB } from "./config/db";
import productRoutes from "./routes/productRoutes";
import authRoutes from "./routes/authRoutes";
import cartRoutes from "./routes/cartRoutes";
import addressRoutes from "./routes/addressRoutes";
import favoriteRoutes from "./routes/favoriteRoutes";
import orderRoutes from "./routes/orderRoutes";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

connectDB();

app.use("/products", productRoutes);
app.use("/auth", authRoutes);
app.use("/cart", cartRoutes);
app.use("/address", addressRoutes);
app.use("/favorites", favoriteRoutes);
app.use("/orders", orderRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
