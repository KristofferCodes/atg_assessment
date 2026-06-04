import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../presentation/controllers/auth_providers.dart';
class HomePlaceholderScreen extends ConsumerStatefulWidget {
  const HomePlaceholderScreen({super.key});

  @override
  ConsumerState<HomePlaceholderScreen> createState() =>
      _HomePlaceholderScreenState();
}

class _HomePlaceholderScreenState
    extends ConsumerState<HomePlaceholderScreen>
    with TickerProviderStateMixin {
  // Entry animations
  late AnimationController _entryController;
  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardOpacity;

  // Continuous pulse on the check circle
  late AnimationController _pulseController;
  late Animation<double> _pulse;

  // Floating particles
  late AnimationController _particleController;

  // Confetti-like dots
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _buildParticles();

    // Entry sequence 
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    _checkScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );

    _ringScale = Tween<double>(begin: 0.6, end: 1.6).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 0.65, curve: Curves.easeOut),
      ),
    );

    _ringOpacity = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 0.65, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 0.65, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
    ));

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.55, 0.78, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.55, 0.8, curve: Curves.easeOutCubic),
    ));

    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
    ));

    // ── Continuous pulse 
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ── Floating particles 
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _entryController.forward();
  }

  void _buildParticles() {
    final rng = math.Random(42);
    for (int i = 0; i < 18; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: 4 + rng.nextDouble() * 6,
        speed: 0.15 + rng.nextDouble() * 0.25,
        phase: rng.nextDouble(),
        opacity: 0.12 + rng.nextDouble() * 0.18,
      ));
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subtextColor =
        isDark ? AppColors.darkSubtext : AppColors.lightSubtext;
    final size = MediaQuery.of(context).size;

    // Get user name from login state if available
    final loginState = ref.watch(loginControllerProvider);
    final displayName = loginState.user?.displayName ?? 'Chief';
    final fullName = loginState.user?.fullName ?? '';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'ATG IVF',
          style: AppTextStyles.headlineMedium.copyWith(color: textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: textColor,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          IconButton(
            icon: Icon(Icons.logout_outlined, color: textColor),
            onPressed: () async {
              await ref.read(authRepositoryProvider).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Floating background particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                  color: AppColors.primary,
                ),
              );
            },
          ),

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Animated check with ripple ring
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ripple ring
                        AnimatedBuilder(
                          animation: _entryController,
                          builder: (context, _) {
                            return Transform.scale(
                              scale: _ringScale.value,
                              child: Opacity(
                                opacity: _ringOpacity.value,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Check circle with pulse
                        AnimatedBuilder(
                          animation: Listenable.merge(
                              [_entryController, _pulseController]),
                          builder: (context, _) {
                            return Opacity(
                              opacity: _checkOpacity.value,
                              child: Transform.scale(
                                scale: _checkScale.value * _pulse.value,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        AppColors.primary.withOpacity(0.08),
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.primary,
                                    size: 52,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Login successful ─────────────────────────────────────
                  AnimatedBuilder(
                    animation: _entryController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'Login Successful!',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        fullName.isEmpty || fullName == "" ? 
                        Text(
                          'Welcome back, $displayName 👑',
                          style: AppTextStyles.displayMedium.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ) :
                        Text(
                        'Welcome back, $fullName 👑',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Subtitle ─────────────────────────────────────────────
                  AnimatedBuilder(
                    animation: _entryController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _subtitleOpacity,
                        child: SlideTransition(
                          position: _subtitleSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      'Your fertility care dashboard is being prepared.\nWe\'re glad you\'re here.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: subtextColor,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Info cards
                  AnimatedBuilder(
                    animation: _entryController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _cardOpacity,
                        child: SlideTransition(
                          position: _cardSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.calendar_month_outlined,
                            label: 'Appointments',
                            sublabel: 'Coming soon',
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.science_outlined,
                            label: 'Lab Results',
                            sublabel: 'Coming soon',
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Messages',
                            sublabel: 'Coming soon',
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Info card widget

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool isDark;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isDark ? AppColors.darkSurface : const Color(0xFFF8F8F8);
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subtextColor =
        isDark ? AppColors.darkSubtext : AppColors.lightSubtext;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : const Color(0xFFEEEEEE),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            sublabel,
            style: AppTextStyles.caption.copyWith(
              color: subtextColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Particle painterZZ\

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      // Float upward and reset
      final dy = p.y - t * 0.6;
      final normalizedY = dy < 0 ? dy + 1.0 : dy;

      // Gentle horizontal sway
      final dx = p.x +
          math.sin((progress * p.speed * 2 * math.pi) + p.phase * 6.28) *
              0.03;

      final paint = Paint()
        ..color = color.withOpacity(p.opacity * (1.0 - (t * 0.5)))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(dx * size.width, normalizedY * size.height),
        p.size / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}