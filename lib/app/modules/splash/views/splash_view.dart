import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/button_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              _buildModernPage(
                size: size,
                imageBg:
                    'https://images.unsplash.com/photo-1447933601403-0c6688de566e?q=80&w=1000&auto=format&fit=crop',
                brand: 'KOPI NALAR',
                title: 'Kualitas Artisan',
                description:
                    'Menghadirkan citarasa kopi terbaik langsung dari roastery kami ke genggaman Anda.',
              ),
              _buildModernPage(
                size: size,
                imageBg:
                    'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=1000&auto=format&fit=crop',
                brand: 'KOPI NALAR',
                title: 'Racikan Sempurna',
                description:
                    'Setiap tetes adalah dedikasi. Kami memadukan presisi teknik dengan rasa yang mendalam.',
              ),
              _buildModernFinalPage(
                size: size,
                imageBg:
                    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=1000&auto=format&fit=crop',
                brand: 'Kopi Nalar',
                description: 'Nikmati Kopi Terbaik dari Biji Pilihan',
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Obx(() {
                  if (controller.currentPage.value != 2) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                _buildDot(0),
                                _buildDot(1),
                                _buildDot(2),
                              ],
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: kSmallButton(),
                              onPressed: () => controller.nextPage(),
                    child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Lanjut',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPage({
    required Size size,
    required String imageBg,
    required String brand,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imageBg), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.92),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    brand,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.085,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFinalPage({
    required Size size,
    required String imageBg,
    required String brand,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imageBg), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.coffee_rounded,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  brand,
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: kPrimaryButton(),
                    onPressed: () => Get.offAllNamed('/login'),
                    child: Text(
                      'Masuk ke Akun',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.toNamed('/main'),
                  child: Text(
                    'Lanjut sebagai Tamu',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = controller.currentPage.value == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white30,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
