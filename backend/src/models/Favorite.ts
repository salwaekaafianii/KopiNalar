import mongoose from "mongoose";

const favoriteItemSchema = new mongoose.Schema(
  {
    productId: { type: String, default: "" },
    name: { type: String, required: true },
    category: { type: String, default: "" },
    price: { type: String, default: "" },
    rating: { type: String, default: "" },
    description: { type: String, default: "" },
    image: { type: String, default: "" },
  },
  { _id: false }
);

const favoriteSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },
    userName: {
      type: String,
      default: "",
    },
    items: [favoriteItemSchema],
  },
  { collection: "favorites", timestamps: true }
);

export default mongoose.model("Favorite", favoriteSchema);

