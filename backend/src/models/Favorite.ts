import mongoose from "mongoose";

const favoriteSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    productId: { type: String, default: "" },
    name: { type: String, required: true },
    category: { type: String, default: "" },
    price: { type: String, default: "" },
    rating: { type: String, default: "" },
    description: { type: String, default: "" },
    image: { type: String, default: "" },
  },
  { collection: "favorites", timestamps: true }
);

// Supaya user tidak bisa nambah product yang sama dua kali
favoriteSchema.index({ userId: 1, name: 1 }, { unique: true });

export default mongoose.model("Favorite", favoriteSchema);

