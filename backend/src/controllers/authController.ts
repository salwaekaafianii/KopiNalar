import { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User from "../models/User";
import { AuthRequest } from "../middleware/auth";

// ============================================================
// HELPER: Generate JWT Token
// ============================================================
const generateToken = (user: { id: string; name: string; email: string }) => {
  return jwt.sign(
    { id: user.id, name: user.name, email: user.email },
    process.env.JWT_SECRET as string,
    { expiresIn: "7d" }
  );
};

// ============================================================
// REGISTER
// ============================================================
export const register = async (req: Request, res: Response) => {
  try {
    const { name, email, password } = req.body;

    // Validasi: semua field wajib
    if (!name || !email || !password) {
      return res.status(400).json({ message: "Semua field harus diisi" });
    }

    // Validasi: email sudah terdaftar?
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "Email sudah terdaftar" });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Simpan user baru
    const user = new User({
      name,
      email,
      password: hashedPassword,
    });

    await user.save();

    // Generate token
    const token = generateToken({
      id: user._id.toString(),
      name: user.name,
      email: user.email,
    });

    res.status(201).json({
      message: "Akun berhasil didaftarkan",
      token,
      user: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    console.error("Register error:", error);
    res.status(500).json({ message: "Gagal mendaftarkan akun" });
  }
};

// ============================================================
// GET PROFILE
// ============================================================
export const getProfile = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: "Akses ditolak" });
    }

    const user = await User.findById(userId).select("-password");
    if (!user) {
      return res.status(404).json({ message: "User tidak ditemukan" });
    }

    res.status(200).json({
      user: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    console.error("Get profile error:", error);
    res.status(500).json({ message: "Gagal mengambil data profil" });
  }
};

// ============================================================
// UPDATE PROFILE
// ============================================================
export const updateProfile = async (req: AuthRequest, res: Response) => {
  try {
    const { name, email, password } = req.body;
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ message: "Akses ditolak" });
    }

    // Validasi: minimal satu field diisi
    if (!name && !email && !password) {
      return res.status(400).json({ message: "Nama, email, atau kata sandi harus diisi" });
    }

    // Jika email diubah, cek duplikasi
    if (email) {
      const existingUser = await User.findOne({ email, _id: { $ne: userId } });
      if (existingUser) {
        return res.status(400).json({ message: "Email sudah digunakan user lain" });
      }
    }

    // Siapkan data update
    const updateData: Record<string, string> = {};
    if (name) updateData.name = name;
    if (email) updateData.email = email;
    if (password) {
      const salt = await bcrypt.genSalt(10);
      updateData.password = await bcrypt.hash(password, salt);
    }

    const updatedUser = await User.findByIdAndUpdate(userId, updateData, {
      new: true,
    });

    if (!updatedUser) {
      return res.status(404).json({ message: "User tidak ditemukan" });
    }

    // Generate token baru dengan data terbaru
    const newToken = generateToken({
      id: updatedUser._id.toString(),
      name: updatedUser.name,
      email: updatedUser.email,
    });

    res.status(200).json({
      message: "Profil berhasil diperbarui",
      token: newToken,
      user: { id: updatedUser._id, name: updatedUser.name, email: updatedUser.email },
    });
  } catch (error) {
    console.error("Update profile error:", error);
    res.status(500).json({ message: "Gagal memperbarui profil" });
  }
};

// ============================================================
// LOGIN
// ============================================================
export const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    // Validasi: semua field wajib
    if (!email || !password) {
      return res.status(400).json({ message: "Email dan kata sandi harus diisi" });
    }

    // Cari user berdasarkan email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "Email belum terdaftar" });
    }

    // Cek password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Kata sandi salah" });
    }

    // Generate token
    const token = generateToken({
      id: user._id.toString(),
      name: user.name,
      email: user.email,
    });

    res.status(200).json({
      message: "Berhasil masuk",
      token,
      user: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ message: "Gagal masuk" });
  }
};
