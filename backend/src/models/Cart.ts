import mongoose from "mongoose";

const cartItemSchema = new mongoose.Schema(
  {
    productId: { type: String, required: true },
    name: { type: String, required: true },
    price: { type: Number, required: true },
    imageUrl: { type: String, default: "" },
    quantity: { type: Number, required: true, min: 1 },
    isSelected: { type: Boolean, default: true },
  },
  { _id: false }
);

const cartSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },
    items: [cartItemSchema],
  },
  { collection: "carts", timestamps: true }
);

export default mongoose.model("Cart", cartSchema);

