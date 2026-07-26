import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kopi_bnsp/app/data/services/api_service.dart';

class RiwayatController extends GetxController {
  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final data = await _apiService.getOrders();
      orders.assignAll(
        data.map((item) => item as Map<String, dynamic>).toList(),
      );
    } catch (e) {
      // Jika gagal, biarkan list kosong
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';

    try {
      final date = DateTime.parse(dateStr).toLocal();

      return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String getInvoiceNumber(Map<String, dynamic> order) {
    // Format: #KPN + 6 digit akhir ObjectId
    final id = order['_id']?.toString() ?? '';
    final idSuffix = id.length >= 6
        ? id.substring(id.length - 6).toUpperCase()
        : id;
    return '#KPN-$idSuffix';
  }

  String getStatusLabel(String? status) {
    // COD & transfer/bukti pembayaran langsung dianggap "Selesai"
    return 'Selesai';
  }

  String getFormatRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';
    final numValue = num.tryParse(amount.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(numValue);
  }
}
