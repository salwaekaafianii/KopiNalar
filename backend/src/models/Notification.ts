import mongoose from "mongoose";

const notificationItemSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      enum: ["order", "promo", "system", "info"],
      default: "info",
    },
    isRead: {
      type: Boolean,
      default: false,
    },
    metadata: {
      type: mongoose.Schema.Types.Mixed,
      default: {},
    },
    createdAt: { type: Date, default: Date.now },
  },
  { _id: true }
);

const notificationSchema = new mongoose.Schema(
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
    items: [notificationItemSchema],
  },
  {
    collection: "notifications",
    timestamps: true,
  }
);

export default mongoose.model("Notification", notificationSchema);

