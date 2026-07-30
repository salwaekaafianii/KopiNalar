import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_controller.dart';
import 'order_detail_view.dart';

class OrdersView extends GetView<AdminController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              'Kelola Pesanan',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.08), height: 1),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Obx(() => _buildFilterChips()),

          // Order list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadOrders(),
              color: const Color(0xFFFFB74D),
              backgroundColor: const Color(0xFF1A1A1A),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  );
                }

                if (controller.filteredOrders.isEmpty) {
                  return ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(60),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(Icons.inbox_rounded,
                                size: 60, color: Colors.white.withOpacity(0.1)),
                            const SizedBox(height: 16),
                            Text(
                              'Tidak ada pesanan',
                              style: GoogleFonts.poppins(
                                color: Colors.white38,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (ctx, index) {
                    final order = controller.filteredOrders[index];
                    return _buildOrderCard(ctx, order);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'label': 'Semua', 'value': ''},
      {'label': 'Menunggu', 'value': 'pending'},
      {'label': 'Lunas', 'value': 'paid'},
      {'label': 'Diproses', 'value': 'processing'},
      {'label': 'Dikirim', 'value': 'shipped'},
      {'label': 'Selesai', 'value': 'delivered'},
      {'label': 'Dibatalkan', 'value': 'cancelled'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final value = f['value'] as String;
            final label = f['label'] as String;
            final isSelected = controller.selectedStatusFilter.value == value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => controller.setStatusFilter(value),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFB74D).withOpacity(0.15)
                        : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFFB74D).withOpacity(0.5)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFFFFB74D)
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final orderId = order['_id']?.toString() ?? '';
    final items = order['items'] as List<dynamic>? ?? [];
    final itemNames = items.map((e) => e['name'] ?? '').join(', ');
    final status = order['status']?.toString() ?? 'pending';
    final paymentProof = order['paymentProof']?.toString() ?? '';
    final total = (order['totalPayment'] ?? 0).toDouble();
    final createdAt = order['createdAt']?.toString() ?? '';
    final userName = order['userName']?.toString() ?? 'Tanpa Nama';
    final paymentMethod = order['paymentMethod']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showOrderDetail(context, order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      userName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 6),

              // Payment method
              Text(
                paymentMethod,
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),

              // Items
              Text(
                itemNames.isNotEmpty ? itemNames : 'Tidak ada item',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Total & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.formatRupiah(total),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFFFB74D),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatDate(createdAt),
                    style: GoogleFonts.poppins(
                      color: Colors.white30,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              // Action buttons
              if (status == 'pending' || status == 'paid' ||
                  status == 'processing' || status == 'shipped') ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 12),
                _buildActionButtonsRow(context, orderId, status, paymentProof),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.orangeAccent;
        label = 'Menunggu';
        break;
      case 'paid':
        color = Colors.blueAccent;
        label = 'Lunas';
        break;
      case 'processing':
        color = Colors.purpleAccent;
        label = 'Diproses';
        break;
      case 'shipped':
        color = Colors.cyanAccent;
        label = 'Dikirim';
        break;
      case 'delivered':
        color = Colors.greenAccent;
        label = 'Selesai';
        break;
      case 'cancelled':
        color = Colors.redAccent;
        label = 'Dibatalkan';
        break;
      default:
        color = Colors.grey;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtonsRow(BuildContext context, String orderId, String currentStatus, String paymentProof) {
    // Kiri: tombol cancel/batal
    // Kanan: tombol lanjutan (Konfirmasi Bayar, Proses, Kirim, Selesai)

    // Tentukan status yang akan muncul
    final nextStatuses = <String>[];
    bool showVerifBayar = false;

    if (currentStatus == 'pending' && paymentProof.isNotEmpty) {
      showVerifBayar = true;
    } else if (currentStatus == 'pending' && paymentProof.isEmpty) {
      nextStatuses.addAll(['paid', 'cancelled']);
    } else if (currentStatus == 'paid') {
      nextStatuses.addAll(['processing', 'cancelled']);
    } else if (currentStatus == 'processing') {
      nextStatuses.addAll(['shipped', 'cancelled']);
    } else if (currentStatus == 'shipped') {
      nextStatuses.add('delivered');
    }

    // Pisahkan cancel dari status forward (progress)
    final cancelStatuses = nextStatuses.where((s) => s == 'cancelled').toList();
    final forwardStatuses = nextStatuses.where((s) => s != 'cancelled').toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: cancel buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (showVerifBayar)
              _buildActionChip(
                label: 'Verif Bayar',
                color: Colors.greenAccent,
                onTap: () => _showPaymentVerification(context, orderId, paymentProof),
              ),
            ...cancelStatuses.map((status) {
              return _buildActionChip(
                label: 'Batalkan',
                color: Colors.redAccent,
                onTap: () => controller.updateOrderStatus(orderId, status),
              );
            }),
          ],
        ),

        // Right side: forward/progress buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: forwardStatuses.map((status) {
            String label;
            Color color;
            switch (status) {
              case 'paid':
                label = 'Konfirmasi Bayar';
                color = Colors.blueAccent;
                break;
              case 'processing':
                label = 'Proses';
                color = Colors.purpleAccent;
                break;
              case 'shipped':
                label = 'Kirim';
                color = Colors.cyanAccent;
                break;
              case 'delivered':
                label = 'Selesai';
                color = Colors.greenAccent;
                break;
              default:
                label = status;
                color = Colors.grey;
            }
            return _buildActionChip(
              label: label,
              color: color,
              onTap: () => controller.updateOrderStatus(orderId, status),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionChip({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showOrderDetail(BuildContext context, Map<String, dynamic> order) {
    Get.to(() => OrderDetailView(orderData: order));
  }

  void _showPaymentVerification(BuildContext context, String orderId, String paymentProofUrl) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Verifikasi Pembayaran',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Payment proof image
              Center(
                child: GestureDetector(
                  onTap: () => _showFullImage(context, paymentProofUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _cacheBust(paymentProofUrl),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.white.withOpacity(0.05),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_rounded,
                              color: Colors.white24, size: 40),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
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
              const SizedBox(height: 20),

              // Tombol Tolak & Terima sejajar
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.verifyPayment(orderId, 'reject', rejectReason: 'Bukti tidak jelas');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            'Tolak',
                            style: GoogleFonts.poppins(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                        Get.back();
                        controller.verifyPayment(orderId, 'accept');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            'Terima',
                            style: GoogleFonts.poppins(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Get.back();
                  _showRejectReasonDialog(context, orderId);
                },
                child: Center(
                  child: Text(
                    'Tolak dengan alasan...',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
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
                      _cacheBust(imageUrl),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white24,
                        size: 60,
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator(color: Colors.white24);
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
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectReasonDialog(BuildContext context, String orderId) {
    final reasonController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Alasan Penolakan',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Berikan alasan mengapa pembayaran ditolak',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Contoh: Bukti pembayaran kurang jelas',
                hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 12),
                filled: true,
                fillColor: Colors.white.withOpacity(0.03),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFFFB74D)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.verifyPayment(
                orderId,
                'reject',
                rejectReason: reasonController.text.isNotEmpty
                    ? reasonController.text
                    : 'Bukti pembayaran tidak valid',
              );
            },
            child: Text(
              'Tolak',
              style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      // Konversi UTC ke WIB (+7 jam)
      final wibDate = date.add(const Duration(hours: 7));
      final formatter = DateFormat('dd/MM HH:mm', 'id_ID');
      return '${formatter.format(wibDate)} WIB';
    } catch (e) {
      return dateStr;
    }
  }

  /// Helper untuk cache-busting: tambah query param timestamp
  String _cacheBust(String url) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    if (url.contains('?')) {
      return '$url&t=$ts';
    }
    return '$url?t=$ts';
  }
}

