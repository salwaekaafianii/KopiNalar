import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/button_styles.dart';
import '../../alamat/controllers/alamat_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Pemesanan',
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
            Text(
              'Lengkapi detail pengiriman Anda untuk\nmenikmati racikan kopi terbaik kami.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: 'Data Diri',
              icon: Icons.person_outline_rounded,
              children: [
                _buildTextFieldLabel('Nama Lengkap'),
                const SizedBox(height: 6),
                _buildCustomTextField(
                  controller: controller.nameController,
                  hintText: 'Contoh: Budi Santoso',
                ),
                const SizedBox(height: 16),
                _buildTextFieldLabel('Nomor HP'),
                const SizedBox(height: 6),
                _buildCustomTextField(
                  controller: controller.phoneController,
                  hintText: '0812xxxxxxx',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Alamat Pengiriman',
              icon: Icons.location_on_outlined,
              children: [
                Builder(
                  builder: (context) {
                    final alamatController = Get.find<AlamatController>();

                    return Obx(() {
                      final isGpsSelected =
                          controller.selectedAddressType.value == 'gps';

                      final isSavedSelected =
                          controller.selectedAddressType.value == 'saved';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // =====================================================
                          // JIKA BELUM MEMILIH ALAMAT
                          // =====================================================
                          if (!isGpsSelected && !isSavedSelected) ...[
                            // Tombol GPS
                            Obx(() {
                              final isLoading =
                                  controller.isDetectingLocation.value;

                              return GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () async {
                                        await controller.detectLocation();
                                      },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isLoading
                                        ? const Color(
                                            0xFFFFB74D,
                                          ).withOpacity(0.12)
                                        : const Color(
                                            0xFFFFB74D,
                                          ).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFFFB74D,
                                      ).withOpacity(0.35),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFFFB74D,
                                          ).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: isLoading
                                              ? const SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 1.5,
                                                        color: Color(
                                                          0xFFFFB74D,
                                                        ),
                                                      ),
                                                )
                                              : const Icon(
                                                  Icons.my_location_rounded,
                                                  color: Color(0xFFFFB74D),
                                                  size: 22,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isLoading
                                                  ? 'Mendeteksi Lokasi...'
                                                  : 'Gunakan Lokasi Saya',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),

                                            const SizedBox(height: 3),

                                            Text(
                                              isLoading
                                                  ? 'Sedang mengambil lokasi Anda, harap tunggu...'
                                                  : 'Deteksi alamat pengiriman secara otomatis menggunakan GPS',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: Colors.white54,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      if (isLoading)
                                        Text(
                                          'Mohon tunggu',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: const Color(0xFFFFB74D),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 16),

                            // ATAU
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'ATAU',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white38,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // TOMBOL / DAFTAR ALAMAT TERSIMPAN
                            if (alamatController.alamatList.isEmpty)
                              Center(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.location_off_outlined,
                                      color: Colors.white30,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Belum ada alamat tersimpan',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        Get.toNamed('/alamat');
                                      },
                                      icon: const Icon(
                                        Icons.add_location_alt_outlined,
                                        size: 18,
                                        color: Color(0xFFFFB74D),
                                      ),
                                      label: Text(
                                        'Tambah Alamat',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFFFB74D),
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size(
                                          double.infinity,
                                          42,
                                        ),
                                        side: BorderSide(
                                          color: Colors.white.withOpacity(0.08),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (controller.isShowingSavedAddresses.value)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pilih Alamat Tersimpan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...alamatController.alamatList.map((alamat) {
                                    final alamatId = alamat['_id']?.toString() ?? '';
                                    final isSelected = controller.selectedAddressType.value == 'saved' &&
                                        controller.selectedSavedAddress.value?['_id']?.toString() == alamatId;

                                    return GestureDetector(
                                      onTap: () => controller.selectSavedAddress(alamat as Map<String, dynamic>),
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFFFFB74D).withOpacity(0.08)
                                              : Colors.white.withOpacity(0.03),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFFFFB74D).withOpacity(0.5)
                                                : Colors.white.withOpacity(0.08),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? Icons.radio_button_checked_rounded
                                                  : Icons.radio_button_unchecked_rounded,
                                              color: isSelected
                                                  ? const Color(0xFFFFB74D)
                                                  : Colors.white38,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    alamat['label'] ?? '',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    alamat['alamat'] ?? '',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: Colors.white70,
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${alamat['kecamatan'] ?? ''}, ${alamat['kota'] ?? ''}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color: Colors.white54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 6),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      controller.isShowingSavedAddresses.value = false;
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 17,
                                      color: Colors.white54,
                                    ),
                                    label: Text(
                                      'Kembali',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 42),
                                      side: BorderSide(color: Colors.white.withOpacity(0.08)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    controller.isShowingSavedAddresses.value = true;
                                  },
                                  icon: const Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: Color(0xFFFFB74D),
                                  ),
                                  label: Text(
                                    'Pilih Alamat Tersimpan',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFFFB74D),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 42),
                                    side: BorderSide(color: Colors.white.withOpacity(0.08)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                          ]
                          // =====================================================
                          // JIKA MENGGUNAKAN GPS
                          // =====================================================
                          else if (isGpsSelected) ...[
                            Text(
                              'Lokasi GPS Dipilih',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFFB74D,
                                ).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFB74D,
                                  ).withOpacity(0.35),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.my_location_rounded,
                                        color: Color(0xFFFFB74D),
                                        size: 22,
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          controller.gpsAddress.value,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    '${controller.gpsKecamatan.value}, '
                                    '${controller.gpsKota.value}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white54,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    'Koordinat: ${controller.latitude.value}, '
                                    '${controller.longitude.value}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // BATAL / GANTI ALAMAT
                            OutlinedButton.icon(
                              onPressed: () {
                                controller.clearSelectedAddress();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 17,
                                color: Colors.white54,
                              ),
                              label: Text(
                                'Gunakan Alamat Lain',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 42),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ]
                          // =====================================================
                          // JIKA ALAMAT TERSIMPAN DIPILIH
                          // =====================================================
                          else if (isSavedSelected) ...[
                            Text(
                              'Alamat Pengiriman',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFB74D,
                                  ).withOpacity(0.35),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Color(0xFFFFB74D),
                                    size: 22,
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                                  .getSelectedAddress()['label'] ??
                                              '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          controller.addressController.text,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white70,
                                            height: 1.4,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          '${controller.gpsKecamatan.value}, '
                                          '${controller.gpsKota.value}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            OutlinedButton.icon(
                              onPressed: () {
                                controller.clearSelectedAddress();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 17,
                                color: Colors.white54,
                              ),
                              label: Text(
                                'Gunakan Alamat Lain',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 42),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Ringkasan Pesanan',
              icon: Icons.receipt_long_outlined,
              children: [
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.orderItems.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 24,
                      color: Colors.white.withOpacity(0.08),
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.orderItems[index];

                      return _buildOrderItem(
                        image: item['image'].toString(),
                        name: item['name'].toString(),
                        variant: item['variant'].toString(),
                        price: item['priceStr'].toString(),
                        quantity: item['quantity'] as int,
                      );
                    },
                  ),
                ),
                Divider(height: 24, color: Colors.white.withOpacity(0.08)),
                _buildPriceRow(
                  'Subtotal',
                  controller.formatRupiah(controller.subtotal),
                ),
                const SizedBox(height: 8),
                _buildPriceRow(
                  'Biaya Pengiriman',
                  controller.formatRupiah(controller.shippingCost),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    thickness: 1,
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
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
                      controller.formatRupiah(controller.totalPayment),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFB74D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: kSecondaryButton(),
                    onPressed: () => controller.makeOrder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Buat Pesanan',
                          style: kButtonText(color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Dengan mengeklik tombol di atas, Anda menyetujui Syarat\n& Ketentuan Kopi Nalar.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
        mainAxisSize: MainAxisSize.min,
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

  Widget _buildTextFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white30),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
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
          borderSide: const BorderSide(color: Color(0xFFFFB74D), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCoordinateBox({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white54,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required String image,
    required String name,
    required String variant,
    required String price,
    required int quantity,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                variant,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54),
              ),
              const SizedBox(height: 4),
              Text(
                'Jumlah : x$quantity',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFFFFB74D),
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
        ),
        Text(
          price,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
