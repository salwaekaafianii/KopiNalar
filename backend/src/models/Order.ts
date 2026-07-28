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

const orderEntrySchema = new mongoose.Schema(
  {
    items: [orderItemSchema],
    totalPayment: { type: Number, required: true },
    shippingCost: { type: Number, default: 10000 },
    paymentMethod: { type: String, required: true },

    // URL gambar bukti pembayaran
    paymentProof: {
      type: String,
      default: "",
    },

    // Status verifikasi pembayaran oleh admin
    paymentStatus: {
      type: String,
      enum: [
        "unpaid",
        "waiting_verification",
        "verified",
        "rejected",
      ],
      default: "unpaid",
    },

    // Status proses pesanan
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
    createdAt: { type: Date, default: Date.now },
  },
  { _id: true }
);

const orderSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    items: [orderEntrySchema],
  },
  { collection: "orders", timestamps: true }
);

export default mongoose.model("Order", orderSchema);

