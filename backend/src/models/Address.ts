import mongoose from "mongoose";

const addressItemSchema = new mongoose.Schema(
  {
    label: { type: String, required: true },
    alamat: { type: String, required: true },
    kecamatan: { type: String, default: "" },
    kota: { type: String, default: "" },
    lat: { type: String, default: "" },
    lng: { type: String, default: "" },
  },
  { _id: false }
);

const addressSchema = new mongoose.Schema(
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
    items: [addressItemSchema],
  },
  { collection: "address", timestamps: true }
);

export default mongoose.model("Address", addressSchema);

