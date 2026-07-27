import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

export interface AuthRequest extends Request {
  user?: { id: string; name: string; email: string; role: string };
}

export const verifyToken = (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Akses ditolak. Token tidak ditemukan" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as {
      id: string;
      name: string;
      email: string;
      role: string;
    };
    req.user = { id: decoded.id, name: decoded.name, email: decoded.email, role: decoded.role };
    next();
  } catch (error) {
    return res.status(401).json({ message: "Token tidak valid atau sudah kadaluarsa" });
  }
};

// Middleware khusus admin
export const verifyAdmin = (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  if (req.user?.role !== "admin") {
    return res.status(403).json({ message: "Akses ditolak. Hanya untuk admin" });
  }
  next();
};

