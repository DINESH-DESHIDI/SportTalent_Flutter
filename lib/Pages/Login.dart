import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Signup.dart';
import '../MainScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String role = "athlete"; // default role
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sportController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = "";
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your details to continue',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Error Text
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: const TextStyle(
                      color: Color(0xFFE74C3C),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 16),

                // Role Dropdown
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "athlete", child: Text("Athlete")),
                    DropdownMenuItem(value: "coach", child: Text("Coach")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      role = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Name Input
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sport Input (only if athlete)
                if (role == "athlete")
                  TextField(
                    controller: sportController,
                    decoration: InputDecoration(
                      labelText: 'Sport Interest',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                if (role == "athlete") const SizedBox(height: 16),

                // Password Input
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 238, 156, 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      // Validate presence
                      if (nameController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          (role == "athlete" && sportController.text.isEmpty)) {
                        setState(() {
                          error = "Please fill all required fields.";
                        });
                        return;
                      }

                      final found = SignupPage.findUser(
                        role: role,
                        name: nameController.text.trim(),
                        password: passwordController.text,
                        sport: role == "athlete" ? sportController.text.trim() : null,
                      );

                      if (found == null) {
                        setState(() {
                          error = "Invalid credentials. Please try again.";
                        });
                        return;
                      }

                      setState(() {
                        error = "";
                      });

                      // user stored in SignupPage.loggedInUser by findUser()
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Signup Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ), // normal text style
                      children: [
                        TextSpan(
                          text: "Signup",
                          style: const TextStyle(
                            color: Color(0xFFFF5722),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupPage(),
                                ),
                              );
                            },
                        ),
                      ],
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
}
