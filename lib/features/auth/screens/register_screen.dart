import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swaplio_frontend/features/auth/screens/home_screen.dart';
import 'package:swaplio_frontend/features/auth/services/auth_service.dart';
import 'package:swaplio_frontend/features/auth/services/storage_service.dart';

// Re-uses shared helpers defined in login_screen.dart
// (_Orb, _FieldLabel, _GlassField, _GradientButton)
// Make sure those classes are in a shared file or copy them below.

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool _obscurePassword = true;

  final authService = AuthService();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final institutionController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    institutionController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      final response = await authService.register(
        fullNameController.text,
        emailController.text,
        passwordController.text,
        phoneNumberController.text,
        institutionController.text,
      );
      final token = response["token"];
      if (token != null) {
        await StorageService.saveToken(token);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: const Color(0xFFFF4D6D),
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background ───────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF0A0A0F),
                  Color(0xFF0D1117),
                  Color(0xFF0A0E1A),
                ],
              ),
            ),
          ),

          // ── Orbs (mirrored layout from login) ───────────────
          Positioned(
            top: -80,
            left: -60,
            child: _Orb(
                size: 300,
                color: const Color(0xFF00D9F5).withOpacity(0.14)),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _Orb(
                size: 280,
                color: const Color(0xFF6C63FF).withOpacity(0.16)),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            right: MediaQuery.of(context).size.width * 0.7,
            child: _Orb(
                size: 120,
                color: const Color(0xFFFF6584).withOpacity(0.09)),
          ),

          // ── Content ──────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: 24),

                          // ── Back button + Logo row ─────────────
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white.withOpacity(0.07),
                                    border: Border.all(
                                        color:
                                        Colors.white.withOpacity(0.10)),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFF00D9F5)
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C63FF)
                                          .withOpacity(0.35),
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.swap_horiz_rounded,
                                    color: Colors.white, size: 22),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // ── Headline ───────────────────────────
                          const Text(
                            'Create your\naccount.',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 40,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join Swaplio and start swapping today',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.45),
                            ),
                          ),
                          const SizedBox(height: 36),

                          // ── Step badge ─────────────────────────
                          _StepBadge(label: 'Personal Info'),
                          const SizedBox(height: 16),

                          // ── Glass card ─────────────────────────
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter:
                              ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.055),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.10),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel('FULL NAME'),
                                    const SizedBox(height: 8),
                                    _GlassField(
                                      controller: fullNameController,
                                      hint: 'Jane Doe',
                                      prefixIcon:
                                      Icons.person_outline_rounded,
                                      keyboardType: TextInputType.name,
                                    ),
                                    const SizedBox(height: 20),
                                    const _FieldLabel('EMAIL ADDRESS'),
                                    const SizedBox(height: 8),
                                    _GlassField(
                                      controller: emailController,
                                      hint: 'you@example.com',
                                      prefixIcon:
                                      Icons.mail_outline_rounded,
                                      keyboardType:
                                      TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 20),
                                    const _FieldLabel('PHONE NUMBER'),
                                    const SizedBox(height: 8),
                                    _GlassField(
                                      controller: phoneNumberController,
                                      hint: '+91 98765 43210',
                                      prefixIcon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          _StepBadge(label: 'Account Setup'),
                          const SizedBox(height: 16),

                          // ── Second glass card ──────────────────
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter:
                              ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.055),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.10),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel('INSTITUTION'),
                                    const SizedBox(height: 8),
                                    _GlassField(
                                      controller: institutionController,
                                      hint: 'Your university or company',
                                      prefixIcon:
                                      Icons.school_outlined,
                                    ),
                                    const SizedBox(height: 20),
                                    const _FieldLabel('PASSWORD'),
                                    const SizedBox(height: 8),
                                    _GlassField(
                                      controller: passwordController,
                                      hint: 'Min. 8 characters',
                                      obscureText: _obscurePassword,
                                      prefixIcon:
                                      Icons.lock_outline_rounded,
                                      suffixIcon: _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      onSuffixTap: () => setState(() =>
                                      _obscurePassword =
                                      !_obscurePassword),
                                    ),
                                    const SizedBox(height: 20),

                                    // Password strength hint
                                    _PasswordHint(),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Terms text ─────────────────────────
                          Center(
                            child: Text(
                              'By registering you agree to our Terms of Service\nand Privacy Policy.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.3),
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Register button ────────────────────
                          _GradientButton(
                            label: 'Create Account',
                            isLoading: isLoading,
                            onPressed: _handleRegister,
                          ),

                          const SizedBox(height: 28),

                          // ── Back to login ──────────────────────
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6C63FF),
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFF6C63FF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 36),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Register-specific helpers ────────────────────────────────────────────────

class _StepBadge extends StatelessWidget {
  final String label;
  const _StepBadge({required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6C63FF).withOpacity(0.25),
              const Color(0xFF00D9F5).withOpacity(0.15),
            ],
          ),
          border: Border.all(
              color: const Color(0xFF6C63FF).withOpacity(0.35)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9B97FF),
            letterSpacing: 0.6,
          ),
        ),
      ),
    ],
  );
}

class _PasswordHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(Icons.info_outline_rounded,
          size: 13, color: Colors.white.withOpacity(0.3)),
      const SizedBox(width: 6),
      Text(
        'Use 8+ characters with letters and numbers',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    ],
  );
}

// ── Shared helpers (copy from login_screen.dart or move to shared file) ──────

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.white.withOpacity(0.5),
      letterSpacing: 0.8,
    ),
  );
}

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const _GlassField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    style: const TextStyle(
        color: Colors.white, fontSize: 15, letterSpacing: 0.2),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle:
      TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 15),
      filled: true,
      fillColor: Colors.white.withOpacity(0.07),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: Icon(prefixIcon,
          size: 20, color: Colors.white.withOpacity(0.35)),
      suffixIcon: suffixIcon != null
          ? GestureDetector(
        onTap: onSuffixTap,
        child: Icon(suffixIcon,
            size: 20, color: Colors.white.withOpacity(0.35)),
      )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
        const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
    ),
  );
}

class _GradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.38),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              strokeWidth: 2.5, color: Colors.white),
        )
            : Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    ),
  );
}