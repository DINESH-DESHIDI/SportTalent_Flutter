import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../MainScreen.dart';
import 'Login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  // In-memory user store
  static List<Map<String, dynamic>> _users = [];

  // Current logged-in user (session)
  static Map<String, dynamic>? loggedInUser;

  /// Adds a user. Returns false if user with same role+name already exists.
  static bool addUser({
    required String role,
    required String name,
    required String password,
    String? age,
    String? gender,
    String? region,
    String? sport,
    String? specialization,
    String? experience,
    String? team,
    String? certification,
  }) {
    // Prevent duplicate by role + name
    final exists =
        _users.any((u) => u['role'] == role && u['name'] == name);
    if (exists) return false;

    final Map<String, dynamic> user = {
      'role': role,
      'name': name,
      'password': password,
      // athlete info
      'age': (age != null && age.isNotEmpty) ? int.tryParse(age) : null,
      'gender': gender,
      'region': region,
      'sport': sport,
      // coach info
      'specialization': specialization,
      'experience': (experience != null && experience.isNotEmpty)
          ? int.tryParse(experience)
          : null,
      'team': team,
      'certification': certification,
      // default performance stats
      'workouts': 0,
      'correctReps': 0,
      'wrongForm': 0,
      'rank': 0,
    };

    _users.add(user);
    // Auto-login on signup
    loggedInUser = user;
    return true;
  }

  /// Finds user by credentials. For athlete role, sport must match if provided.
  /// Returns the user map (and sets loggedInUser) when found, otherwise null.
  static Map<String, dynamic>? findUser({
    required String role,
    required String name,
    required String password,
    String? sport,
  }) {
    for (final u in _users) {
      if (u['role'] == role &&
          u['name'] == name &&
          u['password'] == password) {
        // if athlete, check sport matches (if provided)
        if (role == 'athlete') {
          final storedSport = u['sport'] ?? '';
          if ((sport ?? '') != storedSport) {
            // Not matching sport -> continue search
            continue;
          }
        }
        loggedInUser = u;
        return u;
      }
    }
    return null;
  }

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String role = "athlete"; // default role
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Athlete-specific
  final TextEditingController ageController = TextEditingController();
  String gender = "";
  final TextEditingController regionController = TextEditingController();
  final TextEditingController sportController = TextEditingController();

  // Coach-specific
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController teamController = TextEditingController();
  final TextEditingController certificationController = TextEditingController();

  bool _obscurePassword = true;
  String error = ""; // 🔹 Added for error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(24),
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
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Your Profile',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in your details to personalize your experience.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // 🔹 Error Text
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

                // Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Athlete Fields
                if (role == "athlete") ...[
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: gender.isEmpty ? null : gender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: "male", child: Text("Male")),
                      DropdownMenuItem(value: "female", child: Text("Female")),
                      DropdownMenuItem(value: "other", child: Text("Other")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: regionController,
                    decoration: InputDecoration(
                      labelText: 'Region',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: sportController,
                    decoration: InputDecoration(
                      labelText: 'Sport Interest',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Coach Fields
                if (role == "coach") ...[
                  TextField(
                    controller: specializationController,
                    decoration: InputDecoration(
                      labelText: 'Specialization',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: experienceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Years of Experience',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: teamController,
                    decoration: InputDecoration(
                      labelText: 'Team / Academy',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: certificationController,
                    decoration: InputDecoration(
                      labelText: 'Certifications',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Signup Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 238, 156, 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      // 🔹 Validation before signup
                      if (nameController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          (role == "athlete" &&
                              (ageController.text.isEmpty ||
                                  gender.isEmpty ||
                                  regionController.text.isEmpty ||
                                  sportController.text.isEmpty)) ||
                          (role == "coach" &&
                              (specializationController.text.isEmpty ||
                                  experienceController.text.isEmpty ||
                                  teamController.text.isEmpty ||
                                  certificationController.text.isEmpty))) {
                        setState(() {
                          error = "Please fill all required fields.";
                        });
                        return;
                      }

                      final success = SignupPage.addUser(
                        role: role,
                        name: nameController.text.trim(),
                        password: passwordController.text,
                        age: role == "athlete" ? ageController.text.trim() : null,
                        gender: role == "athlete" ? gender : null,
                        region: role == "athlete" ? regionController.text.trim() : null,
                        sport: role == "athlete" ? sportController.text.trim() : null,
                        specialization: role == "coach" ? specializationController.text.trim() : null,
                        experience: role == "coach" ? experienceController.text.trim() : null,
                        team: role == "coach" ? teamController.text.trim() : null,
                        certification: role == "coach" ? certificationController.text.trim() : null,
                      );

                      if (!success) {
                        setState(() {
                          error = "User with this name already exists.";
                        });
                        return;
                      }

                      setState(() {
                        error = "";
                      });

                      // loggedInUser already set inside addUser
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Already have account link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Login",
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
                                    builder: (_) => const LoginPage()),
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
