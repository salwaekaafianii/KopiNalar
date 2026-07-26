import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
  name: String,
  category: String,
  price: Number,
  rating: Number,
  description: String,
  image: String,
});

export default mongoose.model("Product", productSchema);