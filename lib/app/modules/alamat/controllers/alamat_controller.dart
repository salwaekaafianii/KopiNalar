import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../data/services/api_service.dart';
import '../../../theme/snackbar_helper.dart';

class AlamatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  String kecamatan = "";
  String kota = "";

  final alamatList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isDetectingLocation = false.obs;

  final formNameController = TextEditingController();
  final formAddressController = TextEditingController();
  final formLatController = TextEditingController();
  final formLngController = TextEditingController();

  // ============================================================
  // LOAD ALAMAT DARI BACKEND
  // ============================================================
  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      final data = await _apiService.getAddresses();
      alamatList.assignAll(
        data.map((item) => item as Map<String, dynamic>).toList(),
      );
    } catch (e) {
      // Jika gagal, biarkan list kosong
      alamatList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // DETEKSI LOKASI GPS
  // ============================================================
  Future<void> detectLocation() async {
    if (isDetectingLocation.value) return;

    bool serviceEnabled;
    LocationPermission permission;

    isDetectingLocation.value = true;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      isDetectingLocation.value = false;
      showCustomSnackbar('GPS', 'Silakan aktifkan GPS terlebih dahulu');
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      isDetectingLocation.value = false;
      showCustomSnackbar('Izin Ditolak', 'Aplikasi memerlukan izin lokasi');
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      isDetectingLocation.value = false;
      showCustomSnackbar('Izin Ditolak', 'Silakan aktifkan izin lokasi melalui pengaturan');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      formLatController.text = position.latitude.toString();
      formLngController.text = position.longitude.toString();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      formAddressController.text =
    "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.subAdministrativeArea ?? ''}";
      kota = place.subAdministrativeArea ?? "";
      kecamatan = place.subLocality ?? place.locality ?? "";
      update();

      showCustomSnackbar('Berhasil', 'Lokasi berhasil dideteksi');
    } catch (e) {
      showCustomSnackbar('Error', e.toString());
    } finally {
      isDetectingLocation.value = false;
    }
  }

  // ============================================================
  // TAMBAH ALAMAT KE BACKEND
  // ============================================================
  Future<void> addAlamat() async {
    final name = formNameController.text.trim();
    final address = formAddressController.text.trim();
    if (name.isEmpty || address.isEmpty) {
      showCustomSnackbar('Gagal', 'Lengkapi semua data alamat');
      return;
    }

    if (formLatController.text.isEmpty || formLngController.text.isEmpty) {
      showCustomSnackbar('GPS', 'Silakan deteksi lokasi terlebih dahulu');
      return;
    }

    try {
      final newAddress = await _apiService.addAddress(
        label: name,
        alamat: address,
        kecamatan: kecamatan,
        kota: kota,
        lat: formLatController.text,
        lng: formLngController.text,
      );

      // Tambahkan ke list lokal
      alamatList.insert(0, newAddress);

      // Reset form
      formNameController.clear();
      formAddressController.clear();
      formLatController.clear();
      formLngController.clear();
      kecamatan = "";
      kota = "";

      FocusManager.instance.primaryFocus?.unfocus();
      Get.back();
      showCustomSnackbar('Berhasil', 'Alamat berhasil ditambahkan');
    } catch (e) {
      showCustomSnackbar('Gagal', e.toString());
    }
  }

  // ============================================================
  // HAPUS ALAMAT DARI BACKEND
  // ============================================================
  Future<void> deleteAlamat(int index) async {
    final alamat = alamatList[index];
    final String id = alamat['_id']?.toString() ?? '';

    if (id.isEmpty) {
      alamatList.removeAt(index);
      return;
    }

    try {
      await _apiService.deleteAddress(id);
      alamatList.removeAt(index);
      showCustomSnackbar('Berhasil', 'Alamat berhasil dihapus');
    } catch (e) {
      showCustomSnackbar('Gagal', e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  @override
  void onClose() {
    formNameController.dispose();
    formAddressController.dispose();
    formLatController.dispose();
    formLngController.dispose();
    super.onClose();
  }
}
