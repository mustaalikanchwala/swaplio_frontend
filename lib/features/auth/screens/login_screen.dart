import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swaplio_frontend/features/auth/screens/home_screen.dart';
import 'package:swaplio_frontend/features/auth/screens/register_screen.dart';
import 'package:swaplio_frontend/features/auth/services/auth_service.dart';
import 'package:swaplio_frontend/features/auth/services/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool _obscurePassword = true;
  final authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      final response = await authService.login(
        emailController.text,
        passwordController.text,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _goToRegister(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A0F),
                  Color(0xFF0D1117),
                  Color(0xFF0A0E1A),
                ],
              ),
            ),
          ),

          // ── Decorative orbs ─────────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: _Orb(
              size: 280,
              color: const Color(0xFF6C63FF).withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _Orb(
              size: 260,
              color: const Color(0xFF00D9F5).withOpacity(0.12),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: MediaQuery.of(context).size.width * 0.6,
            child: _Orb(
              size: 140,
              color: const Color(0xFFFF6584).withOpacity(0.10),
            ),
          ),

          // ── Main content ────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo / brand mark
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6C63FF),
                                  Color(0xFF00D9F5),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  const Color(0xFF6C63FF).withOpacity(0.4),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.swap_horiz_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Headline
                        const Text(
                          'Welcome\nback.',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 42,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue to Swaplio',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.45),
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 44),

                        // Glass card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter:
                            ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              padding: const EdgeInsets.all(28),
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
                                  _FieldLabel('Email'),
                                  const SizedBox(height: 8),
                                  _GlassField(
                                    controller: emailController,
                                    hint: 'you@example.com',
                                    keyboardType:
                                    TextInputType.emailAddress,
                                    prefixIcon: Icons.mail_outline_rounded,
                                  ),
                                  const SizedBox(height: 22),
                                  _FieldLabel('Password'),
                                  const SizedBox(height: 8),
                                  _GlassField(
                                    controller: passwordController,
                                    hint: '••••••••',
                                    obscureText: _obscurePassword,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    suffixIcon: _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    onSuffixTap: () => setState(() =>
                                    _obscurePassword =
                                    !_obscurePassword),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                      ),
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color(0xFF6C63FF)
                                              .withOpacity(0.85),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Login button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(16),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF6C63FF),
                                            Color(0xFF48C6EF),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF6C63FF)
                                                .withOpacity(0.38),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed:
                                        isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                            : const Text(
                                          'Sign in',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Sign-up prompt
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              children: [
                                const TextSpan(
                                    text: "Don't have an account? "),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: _goToRegister,
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6C63FF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ───────────────────────────────────────────────────────────

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.5),
        letterSpacing: 0.8,
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        letterSpacing: 0.2,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.25),
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: Colors.white.withOpacity(0.35),
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixTap,
          child: Icon(
            suffixIcon,
            size: 20,
            color: Colors.white.withOpacity(0.35),
          ),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF6C63FF),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}