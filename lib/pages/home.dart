import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/pages/dashboard.dart';
import 'package:flutter_boiler_plate/utils/app_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background_color,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _buildRightSection(context),
            ),
            Expanded(
              flex: 1,
              child: _buildLeftSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(8.0), // Optional: Add border radius
            child: Image.asset(
              'lib/utils/images/girl_sitting.png', // Replace this with your image path
              fit: BoxFit.cover,
              width: double.infinity, // Expand horizontally
              height: double.infinity, // Expand vertically
            ),
          ),
        ),

        // Add more widgets for details if needed
      ],
    );
  }

  Widget _buildRightSection(BuildContext context) {
    final double buttonWidth = 30.0; // Set your desired button width
    final double buttonHeight = 30.0; // Set your desired button height

    final double textFieldWidth = 40.0; // Set your desired text field width
    final double textFieldHeight = 40.0; // Set your desired text field height

    void navigateToDashboard(BuildContext context) async {
      bool isLoggedIn = true; // Call your sign-in method

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time 🚀 jet 🔥',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Track employee time and activities efficiently!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: SizedBox(
              width: textFieldWidth,
              height: textFieldHeight,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle:
                      const TextStyle(color: AppTheme.textColor, fontSize: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryBorderColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryBorderColor,
                      width: 1.0,
                    ),
                  ),
                  fillColor: AppTheme.textFieldBgColor,
                  filled: true,
                ),
                style: const TextStyle(color: AppTheme.textColor, fontSize: 13),
              ),
            )),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: SizedBox(
              width: textFieldWidth,
              height: textFieldHeight,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      const TextStyle(color: AppTheme.textColor, fontSize: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryBorderColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryBorderColor,
                      width: 1.0,
                    ),
                  ),
                  fillColor: AppTheme.textFieldBgColor,
                  filled: true,
                ),
                style: const TextStyle(color: AppTheme.textColor, fontSize: 13),
              ),
            )),
        const SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: SizedBox(
              width: textFieldWidth,
              height: textFieldHeight,
              child: Row(
                children: [
                  Checkbox(
                    value: false, // Use state management to handle the value
                    onChanged: (bool? value) {
                      // Handle checkbox change
                    },
                  ),
                  Text(
                    'Remember Me',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Action for "Forgot Password?" link
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryBorderColor,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200.0),
            child: SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  navigateToDashboard(context);
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.buttonColor,
                  onPrimary: AppTheme.buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(
                      color: AppTheme.primaryBorderColor,
                      width: 1.0,
                    ),
                  ),
                  elevation: 4,
                  minimumSize:
                      Size(double.infinity, 40), // Adjust button height
                ),
              ),
            )),
      ],
    );
  }
}
