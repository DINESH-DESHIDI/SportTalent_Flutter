import 'package:flutter/material.dart';
import 'Signup.dart'; // 🔹 To access loggedInUser from Signup/Login

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
   static Map<String, dynamic>? loggedInUser;

  @override
  
  Widget build(BuildContext context) {
    // 🔹 Get logged in user from SignupPage static storage
    final Map<String, dynamic>? user = SignupPage.loggedInUser;

    // If user is null or empty, show fallback
    if (user == null || user.isEmpty) {
      return Scaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "No Profile Found",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Please login again.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[500],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Go to Login",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Main profile UI
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top Section - Avatar + Info + Logout
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.indigo[600],
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user['name'] != null
                              ? user['name'][0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name + Sport
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${user['sport'] ?? 'N/A'} Enthusiast",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Logout Button
                    ElevatedButton(
                      onPressed: () {
                        SignupPage.loggedInUser = null; // 🔹 Clear session
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[500],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Main Content - Two Column Layout
              Column(
                children: [
                  // User Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Age: ${user['age'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Gender: ${user['gender'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Region: ${user['region'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Sport: ${user['sport'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  // Performance Stats Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Performance Summary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 20,
                          runSpacing: 16,
                          children: [
                            _statCard(
                              "Workouts",
                              (user['workouts'] ?? 0).toString(),
                              Colors.indigo,
                            ),
                            _statCard(
                              "Correct Reps",
                              (user['correctReps'] ?? 0).toString(),
                              Colors.green,
                            ),
                            _statCard(
                              "Wrong Form",
                              (user['wrongForm'] ?? 0).toString(),
                              Colors.red,
                            ),
                            _statCard(
                              "Rank",
                              "#${user['rank'] ?? 0}",
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Growth Graph Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Growth Over Time",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              "[Mini Dashboard Graph will be displayed here]",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "This graph is synced with your Dashboard and will update automatically once backend data is available.",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for stats card
  Widget _statCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
