import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_controller.dart';

class OrderDetailView extends GetView<AdminController> {
  final Map<String, dynamic> orderData;

  const OrderDetailView({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final items = orderData['items'] as List<dynamic>? ?? [];
    final customer = orderData['customer'] as Map<String, dynamic>? ?? {};
    final address = orderData['address'] as Map<String, dynamic>? ?? {};
    final paymentProof = orderData['paymentProof']?.toString() ?? '';
    final status = orderData['status']?.toString() ?? 'pending';
    final orderId = orderData['_id']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Detail Pesanan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Info
            _buildSectionCard(
              title: 'Data Pelanggan',
              icon: Icons.person_outline_rounded,
              children: [
                _buildInfoRow('Nama', customer['name']?.toString() ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow('No. HP', customer['phone']?.toString() ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow('Email', orderData['userEmail']?.toString() ?? '-'),
              ],
            ),
            const SizedBox(height: 16),

            // Address
            _buildSectionCard(
              title: 'Alamat Pengiriman',
              icon: Icons.location_on_outlined,
              children: [
                _buildInfoRow('Label', address['label']?.toString() ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow('Alamat', address['alamat']?.toString() ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow('Kecamatan', address['kecamatan']?.toString() ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow('Kota', address['kota']?.toString() ?? '-'),
              ],
            ),
            const SizedBox(height: 16),

            // Payment Info
            _buildSectionCard(
              title: 'Informasi Pembayaran',
              icon: Icons.payment_rounded,
              children: [
                _buildInfoRow(
                  'Metode',
                  orderData['paymentMethod']?.toString() ?? '-',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Status',
                  _getPaymentStatusText(status),
                  valueColor: _getPaymentStatusColor(status),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Total',
                  controller.formatRupiah(
                    (orderData['totalPayment'] ?? 0).toDouble(),
                  ),
                  valueColor: const Color(0xFFFFB74D),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Ongkir',
                  controller.formatRupiah(
                    (orderData['shippingCost'] ?? 0).toDouble(),
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Tanggal',
                  _formatDate(orderData['createdAt']?.toString() ?? ''),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Payment Proof
            if (paymentProof.isNotEmpty) ...[
              _buildSectionCard(
                title: 'Bukti Pembayaran',
                icon: Icons.image_rounded,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => _showFullImage(paymentProof),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          paymentProof,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 220,
                            color: Colors.white.withOpacity(0.05),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image_not_supported_rounded,
                                      color: Colors.white24, size: 40),
                                  SizedBox(height: 8),
                                  Text('Gagal memuat gambar'),
                                ],
                              ),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 220,
                              color: Colors.white.withOpacity(0.03),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white24),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tap untuk lihat fullscreen',
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  if (status == 'pending') ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.verifyPayment(
                                orderId,
                                'reject',
                                rejectReason: 'Bukti tidak valid',
                              );
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.redAccent.withOpacity(0.3)),
                              ),
                              child: Center(
                                child: Text(
                                  'Tolak',
                                  style: GoogleFonts.poppins(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.verifyPayment(orderId, 'accept');
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.greenAccent.withOpacity(0.3)),
                              ),
                              child: Center(
                                child: Text(
                                  'Terima',
                                  style: GoogleFonts.poppins(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Order Items
            _buildSectionCard(
              title: 'Item Pesanan',
              icon: Icons.shopping_bag_rounded,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['image']?.toString() ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 50,
                            height: 50,
                            color: Colors.white.withOpacity(0.05),
                            child: const Icon(Icons.image_rounded,
                                color: Colors.white24, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name']?.toString() ?? '',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['variant']?.toString() ?? '',
                              style: GoogleFonts.poppins(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'x${item['quantity'] ?? 1}',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFFFB74D),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        controller.formatRupiah(
                          ((item['price'] ?? 0) * (item['quantity'] ?? 1))
                              .toDouble(),
                        ),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFFFFB74D)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Colors.white.withOpacity(0.08)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Verifikasi';
      case 'paid':
        return 'Terverifikasi';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orangeAccent;
      case 'paid':
        return Colors.greenAccent;
      case 'processing':
        return Colors.purpleAccent;
      case 'shipped':
        return Colors.cyanAccent;
      case 'delivered':
        return Colors.greenAccent;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }

  void _showFullImage(String imageUrl) {
    Get.dialog(
      Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.95),
                child: Center(
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white24,
                        size: 60,
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator(
                            color: Colors.white24);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 48,
            right: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final formatter = DateFormat('dd MMM yyyy HH:mm', 'id_ID');
      return formatter.format(date);
    } catch (e) {
      return dateStr;
    }
  }
}

