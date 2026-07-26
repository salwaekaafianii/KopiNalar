import Product from "../models/Product";
import { Request, Response } from "express";

export const getProducts = async (req: Request, res: Response) => {
  const products = await Product.find();

  console.log(products);

  res.json(products);
};