import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../screens/home/home_screen.dart';
import '../services/auth_provider.dart';
import '../models/user_model.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Apply button press animation
      await _buttonAnimationController.forward();
      await Future.delayed(const Duration(milliseconds: 100));
      await _buttonAnimationController.reverse();

      // Use the AuthProvider to sign in
      debugPrint("Starting Google Sign-In process from button...");

      final authProvider = AuthProvider.of(context, listen: false);

      // Allow up to 3 retries if we get errors
      UserModel? user;
      String? lastError;

      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          user = await authProvider.signInWithGoogle();
          // If success, break out of the loop
          if (user != null) break;

          // Capture the last error message
          lastError = authProvider.errorMessage;
          debugPrint("Attempt ${attempt + 1} failed: $lastError");

          // Wait a moment before retrying
          if (attempt < 2) {
            await Future.delayed(const Duration(seconds: 1));
          }
        } catch (e) {
          debugPrint("Sign-in attempt ${attempt + 1} threw exception: $e");
          lastError = e.toString();
        }
      }

      debugPrint(
          "Final Google Sign-In result: ${user != null ? 'Success' : 'Failed'}");

      if (!mounted) return;

      if (user != null) {
        debugPrint("Navigating to Home screen...");
        // Navigate to home screen on success
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false, // Remove all previous routes
        );
      } else if (lastError != null) {
        debugPrint("Authentication error: $lastError");
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: $lastError'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        debugPrint("Authentication failed without specific error message");
        // Show a generic error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Authentication failed. Please try again."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      debugPrint("Exception during sign-in process: $e");
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isLoading ? null : _handleGoogleSignIn,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing4,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  'https://www.google.com/favicon.ico',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.g_mobiledata,
                                      size: 24,
                                      color: Colors.red,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          strokeWidth: 2,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            Colors.blue,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing3),
                            Text(
                              'Continue with Google',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    )
        .animate()
        .fadeIn(
          duration: AppTheme.defaultAnimationDuration,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: AppTheme.defaultAnimationDuration,
          curve: Curves.easeOutCubic,
        );
  }
}
