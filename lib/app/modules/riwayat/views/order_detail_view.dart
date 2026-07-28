import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderDetailView extends GetView {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final order = args;

    final items = order['items'] as List<dynamic>? ?? [];
    final customer = order['customer'] as Map<String, dynamic>? ?? {};
    final address = order['address'] as Map<String, dynamic>? ?? {};

    String getInvoiceNumber(Map<String, dynamic> order) {
      final id = order['_id']?.toString() ?? '';
      final idSuffix = id.length >= 6
          ? id.substring(id.length - 6).toUpperCase()
          : id;
      return '#KPN-$idSuffix';
    }

    String formatDate(String? dateStr) {
      if (dateStr == null || dateStr.trim().isEmpty) return '-';

      try {
        final cleanDate = dateStr.trim();
        debugPrint('>>> ORDER DETAIL - Nilai createdAt mentah: "$cleanDate"');

        DateTime? parsedDate;

        // Coba parse sebagai ISO 8601 string
        try {
          parsedDate = DateTime.parse(cleanDate);
        } catch (_) {
          debugPrint(
            '>>> ORDER DETAIL - DateTime.parse gagal untuk: "$cleanDate"',
          );
        }

        // Jika gagal, coba parse sebagai Unix timestamp (milliseconds/detik)
        if (parsedDate == null) {
          final number = num.tryParse(cleanDate);
          if (number != null) {
            if (number > 1000000000000) {
              parsedDate = DateTime.fromMillisecondsSinceEpoch(
                number.toInt(),
                isUtc: true,
              );
            } else {
              parsedDate = DateTime.fromMillisecondsSinceEpoch(
                number.toInt() * 1000,
                isUtc: true,
              );
            }
            debugPrint(
              '>>> ORDER DETAIL - Parsing sebagai Unix timestamp berhasil: $parsedDate',
            );
          } else {
            debugPrint('>>> ORDER DETAIL - BUKAN ANGKA: "$cleanDate"');
          }
        }

        // Jika masih gagal, coba bersihkan string
        if (parsedDate == null) {
          String cleaned = cleanDate.replaceAll(RegExp(r'[Zz]$'), '');
          cleaned = cleaned.replaceAll(' ', 'T');
          try {
            parsedDate = DateTime.parse(cleaned);
            debugPrint(
              '>>> ORDER DETAIL - Parsing setelah cleaning berhasil: $parsedDate',
            );
          } catch (_) {
            debugPrint(
              '>>> ORDER DETAIL - Parsing setelah cleaning GAGAL untuk: "$cleaned"',
            );
          }
        }

        if (parsedDate == null) {
          debugPrint('>>> ORDER DETAIL - GAGAL TOTAL: "$cleanDate"');
          return 'Tanggal tidak valid';
        }

        // Ubah ke zona waktu WIB (UTC+7) secara eksplisit
        final wibDate = parsedDate.add(Duration(hours: 7));

        return '${DateFormat('dd MMM yyyy, HH:mm', 'en_US').format(wibDate)} WIB';
      } catch (e) {
        debugPrint('>>> ORDER DETAIL - EXCEPTION: $e');
        return 'Tanggal tidak valid';
      }
    }

    String formatRupiah(dynamic amount) {
      if (amount == null) return 'Rp 0';
      final numValue = num.tryParse(amount.toString()) ?? 0;
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(numValue);
    }

    String statusLabel(String? status) {
      return 'Selesai';
    }

    Color statusColor(String? status) {
      return Colors.green;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
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
          children: [
            // ---------- STATUS CARD ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor(order['status']?.toString()).withOpacity(0.2),
                    statusColor(order['status']?.toString()).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: statusColor(
                    order['status']?.toString(),
                  ).withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: statusColor(
                        order['status']?.toString(),
                      ).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      order['status'] == 'delivered'
                          ? Icons.check_circle_rounded
                          : order['status'] == 'shipped'
                          ? Icons.local_shipping_rounded
                          : order['status'] == 'paid'
                          ? Icons.payment_rounded
                          : order['status'] == 'pending'
                          ? Icons.hourglass_empty_rounded
                          : order['status'] == 'cancelled'
                          ? Icons.cancel_rounded
                          : Icons.receipt_long_rounded,
                      color: statusColor(order['status']?.toString()),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    statusLabel(order['status']?.toString()),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor(order['status']?.toString()),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(order['createdAt']?.toString()),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- INVOICE ID ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'No. Pesanan',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    getInvoiceNumber(order),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- INFORMASI PENERIMA ----------
            _sectionTitle('Informasi Penerima'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                children: [
                  _infoRow(
                    Icons.person_outline_rounded,
                    'Nama',
                    customer['name']?.toString() ?? '-',
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  _infoRow(
                    Icons.phone_outlined,
                    'No. HP',
                    customer['phone']?.toString() ?? '-',
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  _infoRow(
                    Icons.location_on_outlined,
                    'Alamat',
                    '${address['alamat'] ?? '-'}${address['kecamatan']?.toString().isNotEmpty == true ? ', ${address['kecamatan']}' : ''}${address['kota']?.toString().isNotEmpty == true ? ', ${address['kota']}' : ''}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- PRODUK DIPESAN ----------
            _sectionTitle('Produk Dipesan'),
            const SizedBox(height: 8),
            ...items.asMap().entries.map((entry) {
              final i = entry.value as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: i['image']?.toString().isNotEmpty == true
                          ? Image.network(
                              i['image'],
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholderImage(),
                            )
                          : _placeholderImage(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i['name']?.toString() ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          if (i['variant']?.toString().isNotEmpty == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                i['variant']
                                        ?.toString()
                                        .replaceAll(', ', ', ')
                                        .trim() ??
                                    '',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${i['quantity'] ?? 1}x',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white54,
                                ),
                              ),
                              Text(
                                formatRupiah(i['price']),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFFB74D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // ---------- RINCIAN PEMBAYARAN ----------
            _sectionTitle('Rincian Pembayaran'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                children: [
                  _infoRowSimple(
                    'Metode Pembayaran',
                    order['paymentMethod']?.toString() ?? '-',
                  ),
                  // ----- BUKTI PEMBAYARAN -----
                  if (_shouldShowPaymentProof(order)) ...[
                    const Divider(color: Colors.white10, height: 16),
                    _buildPaymentProofRow(context, order),
                  ],
                  const Divider(color: Colors.white10, height: 16),
                  _infoRowSimple(
                    'Subtotal',
                    formatRupiah(
                      (num.tryParse(order['totalPayment']?.toString() ?? '0') ??
                              0) -
                          (num.tryParse(
                                order['shippingCost']?.toString() ?? '0',
                              ) ??
                              0),
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  _infoRowSimple(
                    'Ongkos Kirim',
                    formatRupiah(order['shippingCost']),
                  ),
                  const Divider(color: Colors.white10, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatRupiah(order['totalPayment']),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFB74D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFFFFB74D)),
        const SizedBox(width: 10),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _infoRowSimple(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.coffee_outlined, color: Colors.white24, size: 28),
    );
  }

  // =========================================================
  // BUKTI PEMBAYARAN
  // =========================================================

  /// Apakah perlu menampilkan bukti pembayaran?
  bool _shouldShowPaymentProof(Map<String, dynamic> order) {
    final paymentMethod = order['paymentMethod']?.toString() ?? '';
    final paymentProof = order['paymentProof']?.toString() ?? '';
    // COD tidak ada bukti pembayaran
    if (paymentMethod == 'COD (Bayar di Tempat)') return false;
    // Hanya tampilkan jika ada URL bukti pembayaran
    return paymentProof.isNotEmpty;
  }

  /// Baris bukti pembayaran dengan thumbnail
  /// Tampilan bukti pembayaran
  /// Gambar ditaruh di bawah dan bisa langsung ditekan
  Widget _buildPaymentProofRow(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    final paymentProof = order['paymentProof']?.toString() ?? '';

    if (paymentProof.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul bukti pembayaran
        Row(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFFFFB74D),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Bukti Pembayaran',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Gambar bukti pembayaran
        GestureDetector(
          onTap: () {
            _showPaymentProofDialog(context, paymentProof);
          },
          child: Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFB74D).withOpacity(0.35),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.network(
                paymentProof,
                width: double.infinity,
                height: 220,
                fit: BoxFit.contain,

                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFB74D),
                      strokeWidth: 2,
                    ),
                  );
                },

                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white38,
                        size: 42,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Gambar gagal dimuat',
                        style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Keterangan kecil, bukan tombol
        Center(
          child: Text(
            'Ketuk gambar untuk memperbesar',
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.white30),
          ),
        ),
      ],
    );
  }

  /// Dialog fullscreen untuk melihat bukti pembayaran
  void _showPaymentProofDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Gambar fullscreen
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFFB74D),
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white38,
                            size: 64,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat gambar',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Tombol close
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
