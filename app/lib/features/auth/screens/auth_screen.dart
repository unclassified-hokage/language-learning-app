import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/theme/app_colors.dart';

enum _AuthMode { signIn, signUp, emailSent }

class AuthScreen extends StatefulWidget {
  final bool startInSignIn;
  const AuthScreen({super.key, this.startInSignIn = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late _AuthMode _mode;
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;
  bool _obscurePassword = true;
  String? _error;
  String _sentEmail = '';

  @override
  void initState() {
    super.initState();
    _mode = widget.startInSignIn ? _AuthMode.signIn : _AuthMode.signUp;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    String? error;
    if (_mode == _AuthMode.signUp) {
      error = await _authService.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        displayName: _nameCtrl.text.trim().isNotEmpty
            ? _nameCtrl.text.trim()
            : null,
      );
      if (error == null && mounted) {
        // Check if Supabase gave us a session (email confirm disabled)
        // or just created the user (email confirm enabled)
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          // Confirmed immediately → go through onboarding
          context.go('/language-select');
        } else {
          // Email confirmation required → show "check inbox" screen
          setState(() {
            _sentEmail = _emailCtrl.text.trim();
            _mode = _AuthMode.emailSent;
            _loading = false;
          });
          return;
        }
      }
    } else {
      error = await _authService.signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (error == null && mounted) {
        // Returning user → straight to home
        context.go('/home');
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
        _error = error;
      });
    }
  }

  void _toggleMode() {
    setState(() {
      _error = null;
      _mode = _mode == _AuthMode.signIn ? _AuthMode.signUp : _AuthMode.signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == _AuthMode.emailSent) {
      return _buildEmailSentScreen();
    }

    final isSignUp = _mode == _AuthMode.signUp;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
            ),
          ),

          // Top-right decorative circle
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Back button
                  GestureDetector(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGlass,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    isSignUp ? 'Create account' : 'Welcome back',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),

                  const SizedBox(height: 8),

                  Text(
                    isSignUp
                        ? 'Start your language journey today — free forever.'
                        : 'Sign in to continue your progress.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ).animate(delay: 100.ms).fadeIn(duration: 500.ms),

                  const SizedBox(height: 40),

                  // Form card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name field (sign-up only)
                          if (isSignUp) ...[
                            _buildField(
                              controller: _nameCtrl,
                              label: 'Your name',
                              hint: 'e.g. Vivek',
                              icon: Icons.person_outline_rounded,
                              validator: (v) => null, // optional
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Email
                          _buildField(
                            controller: _emailCtrl,
                            label: 'Email',
                            hint: 'you@example.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!v.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Password
                          _buildField(
                            controller: _passwordCtrl,
                            label: 'Password',
                            hint: isSignUp
                                ? 'Min. 8 characters'
                                : 'Your password',
                            icon: Icons.lock_outline_rounded,
                            obscure: _obscurePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (isSignUp && v.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),

                          // Error message
                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.error.withOpacity(0.4)),
                              ),
                              child: Text(
                                _error!,
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      isSignUp
                                          ? 'Create Account'
                                          : 'Sign In',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(
                      begin: 0.2, curve: Curves.easeOutCubic),

                  const SizedBox(height: 20),

                  // Toggle sign-in / sign-up
                  Center(
                    child: TextButton(
                      onPressed: _toggleMode,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: isSignUp
                                  ? 'Already have an account? '
                                  : "Don't have an account? ",
                            ),
                            TextSpan(
                              text: isSignUp ? 'Sign in' : 'Sign up free',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildEmailSentScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          ),
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.correct.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Envelope icon
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.correct.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.correct.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Center(
                      child: Text('📧', style: TextStyle(fontSize: 44)),
                    ),
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.easeOutBack)
                      .fadeIn(),

                  const SizedBox(height: 32),

                  Text(
                    'Check your inbox!',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ).animate(delay: 200.ms).fadeIn(duration: 500.ms),

                  const SizedBox(height: 16),

                  Text(
                    'We sent a confirmation link to',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ).animate(delay: 300.ms).fadeIn(),

                  const SizedBox(height: 6),

                  Text(
                    _sentEmail,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ).animate(delay: 350.ms).fadeIn(),

                  const SizedBox(height: 12),

                  Text(
                    'Click the link in the email to activate\nyour account, then sign in below.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ).animate(delay: 400.ms).fadeIn(),

                  const SizedBox(height: 48),

                  // Sign in button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _mode = _AuthMode.signIn;
                          _error = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Sign In Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => context.go('/'),
                    child: Text(
                      'Back to home',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ).animate(delay: 600.ms).fadeIn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.surface.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: AppColors.textHint),
        hintStyle: TextStyle(color: AppColors.textHint.withOpacity(0.6)),
      ),
      validator: validator,
    );
  }
}
