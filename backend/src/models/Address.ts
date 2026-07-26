import mongoose from "mongoose";

const addressSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    label: { type: String, required: true },
    alamat: { type: String, required: true },
    kecamatan: { type: String, default: "" },
    kota: { type: String, default: "" },
    lat: { type: String, default: "" },
    lng: { type: String, default: "" },
  },
  { collection: "address", timestamps: true }
);

export default mongoose.model("Address", addressSchema);
