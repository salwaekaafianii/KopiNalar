import mongoose from "mongoose";

const orderItemSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    price: { type: Number, required: true },
    quantity: { type: Number, required: true, min: 1 },
    variant: { type: String, default: "" },
    image: { type: String, default: "" },
  },
  { _id: false }
);

const orderSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    items: [orderItemSchema],
    totalPayment: { type: Number, required: true },
    shippingCost: { type: Number, default: 10000 },
    paymentMethod: { type: String, required: true },
    status: {
      type: String,
      enum: ["pending", "paid", "processing", "shipped", "delivered", "cancelled"],
      default: "pending",
    },
    customer: {
      name: { type: String, required: true },
      phone: { type: String, required: true },
    },
    address: {
      label: { type: String, default: "" },
      alamat: { type: String, required: true },
      kecamatan: { type: String, default: "" },
      kota: { type: String, default: "" },
      lat: { type: String, default: "" },
      lng: { type: String, default: "" },
    },
  },
  { collection: "orders", timestamps: true }
);

export default mongoose.model("Order", orderSchema);

