import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_logo.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate login delay
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing4,
          ),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            
            // Logo
            const AnimatedLogo(size: 120)
              .animate()
              .fadeIn(duration: AppTheme.slowAnimationDuration)
              .scale(delay: AppTheme.defaultAnimationDuration),
            
            const SizedBox(height: AppTheme.spacing5),
            
            // Welcome Text
            Text(
              'Welcome to CarbonX',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            )
              .animate()
              .fadeIn(
                delay: AppTheme.defaultAnimationDuration,
                duration: AppTheme.defaultAnimationDuration,
              ),
            
            const SizedBox(height: AppTheme.spacing2),
            
            Text(
              'Make carbon credits accessible to everyone',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )
              .animate()
              .fadeIn(
                delay: AppTheme.defaultAnimationDuration * 1.5,
                duration: AppTheme.defaultAnimationDuration,
              ),
            
            const SizedBox(height: AppTheme.spacing6),
            
            // Login Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Enter your email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 2,
                      duration: AppTheme.defaultAnimationDuration,
                    )
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      delay: AppTheme.defaultAnimationDuration * 2,
                      duration: AppTheme.defaultAnimationDuration,
                      curve: Curves.easeOutCubic,
                    ),
                  
                  const SizedBox(height: AppTheme.spacing3),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 2.3,
                      duration: AppTheme.defaultAnimationDuration,
                    )
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      delay: AppTheme.defaultAnimationDuration * 2.3,
                      duration: AppTheme.defaultAnimationDuration,
                      curve: Curves.easeOutCubic,
                    ),
                  
                  const SizedBox(height: AppTheme.spacing2),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 2.6,
                      duration: AppTheme.defaultAnimationDuration,
                    ),
                  
                  const SizedBox(height: AppTheme.spacing4),
                  
                  // Login Button
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('LOGIN'),
                    ),
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 2.9,
                      duration: AppTheme.defaultAnimationDuration,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: AppTheme.defaultAnimationDuration * 2.9,
                      duration: AppTheme.defaultAnimationDuration,
                      curve: Curves.easeOutCubic,
                    ),
                  
                  const SizedBox(height: AppTheme.spacing4),
                  
                  // Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to register screen
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  )
                    .animate()
                    .fadeIn(
                      delay: AppTheme.defaultAnimationDuration * 3.2,
                      duration: AppTheme.defaultAnimationDuration,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 