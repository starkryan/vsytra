import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:me_lond/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      debugPrint(
        'Login with email: ${data['email']}, password: ${data['password']}',
      );

      // Get the UserProvider and attempt login
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.login(data['email'], data['password']).then((success) {
        if (!mounted) return;
        if (success) {
          // Login successful, navigation will be handled by router
          // The router will automatically redirect to '/' when user is logged in
          if (context.mounted) {
            context.go('/');
          }
        } else {
          // Show error snackbar
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(userProvider.error ?? 'Login failed'),
                backgroundColor: ShadTheme.of(context).colorScheme.destructive,
              ),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isLoading = userProvider.isLoading;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text('Welcome back', style: theme.textTheme.h2),
                const SizedBox(height: 8),
                Text(
                  'Enter your credentials to access your account',
                  style: theme.textTheme.muted,
                ),
                const SizedBox(height: 32),
                ShadForm(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ShadInputFormField(
                        id: 'email',
                        label: Text('Email', style: theme.textTheme.p),
                        placeholder: const Text('Enter your email'),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ShadInputFormField(
                        id: 'password',
                        label: Text('Password', style: theme.textTheme.p),
                        placeholder: const Text('Enter your password'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ShadButton.link(
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: theme.colorScheme.destructive,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            // Handle forgot password
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      ShadButton(
                        onPressed: isLoading ? null : _handleLogin,
                        child:
                            isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.primaryForeground,
                                  ),
                                )
                                : const Text('Sign in'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: theme.colorScheme.muted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.border)),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ShadButton.outline(
                    onPressed: () {
                      // Handle Google sign in
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.login,
                          size: 18,
                          color: theme.colorScheme.foreground,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Continue with Google',
                          style: TextStyle(color: theme.colorScheme.foreground),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: theme.colorScheme.muted),
                    ),
                    ShadButton.link(
                      onPressed: () {
                        // Navigate to sign up page
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
