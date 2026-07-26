import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/alamat_controller.dart';

class AlamatView extends GetView<AlamatController> {
  const AlamatView({super.key});

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
          'Alamat Saya',
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
      body: Obx(() {
        if (controller.alamatList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_rounded,
                  size: 80,
                  color: Colors.white.withOpacity(0.1),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada alamat',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tambahkan alamat pengiriman kamu',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white24,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          itemCount: controller.alamatList.length,
          itemBuilder: (context, index) {
            final alamat = controller.alamatList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFFFB74D),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFFB74D,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                alamat['label'],
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFFB74D),
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () => controller.deleteAlamat(index),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alamat['alamat'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${alamat['kecamatan']}, ${alamat['kota']}',
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
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAlamatDialog(),
        backgroundColor: const Color(0xFFFFB74D),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Tambah Alamat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  void _showAddAlamatDialog() {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Tambah Alamat Baru',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              _formLabel('Nama Alamat'),
              const SizedBox(height: 6),
              _formTextField(
                controller.formNameController,
                'Contoh: Rumah, Kantor',
              ),

              const SizedBox(height: 14),

              _formLabel('Alamat Lengkap'),
              const SizedBox(height: 6),
              TextField(
                controller: controller.formAddressController,
                maxLines: 3,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nama jalan, nomor rumah, RT/RW...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white30,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.03),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFFB74D),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: Obx(() => OutlinedButton(
                  onPressed: controller.isDetectingLocation.value ? null : () => controller.detectLocation(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.03),
                    side: BorderSide(color: Colors.white.withOpacity(0.08)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: controller.isDetectingLocation.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFFB74D),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.my_location_rounded,
                              size: 18,
                              color: Color(0xFFFFB74D),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Deteksi Lokasi GPS',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFB74D),
                              ),
                            ),
                          ],
                        ),
                )),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: GetBuilder<AlamatController>(
                      builder: (c) => _coordBox(
                        'LAT',
                        c.formLatController.text.isEmpty
                            ? '-'
                            : c.formLatController.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GetBuilder<AlamatController>(
                      builder: (c) => _coordBox(
                        'LNG',
                        c.formLngController.text.isEmpty
                            ? '-'
                            : c.formLngController.text,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => controller.addAlamat(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB74D),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Simpan Alamat',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    );
  }

  Widget _formTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white30),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFB74D), width: 1.5),
        ),
      ),
    );
  }

  Widget _coordBox(String label, String value) {
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
}
