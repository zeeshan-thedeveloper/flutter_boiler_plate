import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/apis/api_manager.dart';
import 'package:flutter_boiler_plate/pages/dashboard.dart';
import 'package:flutter_boiler_plate/utils/app_styles.dart';
import 'package:flutter_boiler_plate/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  String _enteredUsername = ''; // Variable to hold entered username
  String _enteredPassword = ''; // Variable to hold entered password
  String _loginError = ''; // Variable to hold login error message

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> loginUser() async {
    try {
      print('_usernameController.text ' + _usernameController.text);

      print('_passwordController.text ' + _passwordController.text);

      final response = await ApiManager.callApi(
        endpoint: 'login/user', // Use your endpoint from constants
        method: 'POST',
        body: {
          'userName': _usernameController.text,
          'password': _passwordController.text,
        },
        headers: {'Content-Type': 'application/json'},
      );
      print('login response: $response');
      if (response['success']) {
        final Map<String, dynamic> data = response['data'];
        print('Login successful. User: ${data}');
        return true;
        // Handle storing user data and navigation here
        // ...
      } else {
        // Error handling for unsuccessful login
        final errorMessage = response['message'];
        setState(() {
          _loginError = errorMessage; // Set error message
        });
        return false;
        // showNotification(context, 'Invalid username or password');
      }
    } catch (error) {
      // Handle network or other errors
      // showNotification(context, 'Network or server error');
      setState(() {
        _loginError = 'Network or server error'; // Set error message
      });
      return false;
    }
  }

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
      bool isLoggedIn = await loginUser(); // Call your sign-in method

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_loginError),
            duration: Duration(seconds: 2),
          ),
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
                controller: _usernameController,
                onChanged: (value) {
                  setState(() {
                    _enteredUsername = value; // Store entered username
                  });
                },
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
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    _enteredPassword = value; // Store entered password
                  });
                },
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
