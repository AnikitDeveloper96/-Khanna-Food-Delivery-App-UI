import 'package:flutter/material.dart';

// Placeholder for AppColors class
// In a real project, this would likely be in a separate file (e.g., constants/color.dart)
class AppColors {
  static const Color primary = Color(0xFFFF6F00); // A shade of orange/amber
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Global key for the form, used for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Separate Text editing controllers for Login form fields
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  // Separate Text editing controllers for Sign-up form fields
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController(); // Only used for Sign-up

  // State variable to manage the selected tab (Login or Sign-up)
  String _selectedTab = 'Login'; // Default to Login tab

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Function to validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address.';
    }
    // Basic email regex for validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null; // Return null if the input is valid
  }

  // Function to validate password strength
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null; // Return null if the input is valid
  }

  // Function to validate phone number (only used for Sign-up)
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number.';
    }
    // Basic validation: 10-15 digits, adjust regex for specific country codes if needed
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'Please enter a valid phone number (10-15 digits).';
    }
    return null; // Return null if the input is valid
  }

  // Handles the logic when the main action button (Login/Sign Up) is pressed
  void _handleAuthAction() {
    // Validate all fields in the form
    // When `validate()` is called, it triggers the validator for each TextFormField
    // and updates their error messages accordingly.
    if (_formKey.currentState!.validate()) {
      if (_selectedTab == 'Login') {
        final String email = _loginEmailController.text;
        final String password = _loginPasswordController.text;
        _showSnackBar('Login attempt for $email. (Backend check needed)');
        // In a real app, if login is successful:
        // Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
      } else {
        // Sign-up tab selected
        final String email = _signupEmailController.text;
        final String password = _signupPasswordController.text;
        final String phoneNumber = _phoneNumberController.text;

        _showSnackBar(
          'Sign-up attempt for $email, Phone: $phoneNumber. (Backend registration needed)',
        );
        setState(() {
          _selectedTab =
              'Login'; // Suggest switching to login after simulated signup attempt
        });
      }
    }
  }

  // Helper function to show a SnackBar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // Builds the tab selection UI (Login/Sign-up)
  Widget _buildTab(String title) {
    final bool isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
          // IMPORTANT: These lines clear the text fields and reset validation state
          // whenever the tab is switched, preventing previous inputs from showing up.
          _loginEmailController.clear();
          _loginPasswordController.clear();
          _signupEmailController.clear();
          _signupPasswordController.clear();
          _phoneNumberController.clear(); // Clear phone number field
          _formKey.currentState?.reset(); // Reset form validation state
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey[500],
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 3,
              width: 80, // Fixed width for the tab indicator is usually fine
              decoration: BoxDecoration(
                color:
                    AppColors
                        .primary, // Used AppColors.primary for tab indicator
                borderRadius: BorderRadius.circular(5),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints
                          .maxHeight, // Ensure content takes at least full screen height
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize
                            .min, // Crucial for correct layout with SingleChildScrollView and Spacer
                    children: [
                      // Top Section with Logo and Tabs
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Logo (Chef Hat/Lips)
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                'assets/chef_logo.png', // Placeholder, replace with actual asset
                                height:
                                    120, // Fixed height/width for a logo is acceptable and often desired
                                width: 120,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback: Display a placeholder if the image fails to load
                                  return Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Icon(
                                      Icons.restaurant_menu,
                                      size: 60,
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Login/Sign-up Tabs
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTab("Login"),
                                _buildTab("Sign-up"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Login/Sign-up Form
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                Text(
                                  "Email address",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                TextFormField(
                                  // Use different controller based on selected tab
                                  controller:
                                      _selectedTab == 'Login'
                                          ? _loginEmailController
                                          : _signupEmailController,
                                  validator: _validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "example@email.com",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    errorStyle: TextStyle(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                // Phone Number Field (only for Sign-up)
                                if (_selectedTab == 'Sign-up') ...[
                                  const SizedBox(height: 30),
                                  Text(
                                    "Phone Number",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  TextFormField(
                                    controller: _phoneNumberController,
                                    validator: _validatePhoneNumber,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: "+1234567890",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      errorStyle: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 30),
                                Text(
                                  "Password",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                TextFormField(
                                  // Use different controller based on selected tab
                                  controller:
                                      _selectedTab == 'Login'
                                          ? _loginPasswordController
                                          : _signupPasswordController,
                                  validator: _validatePassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "********",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    errorStyle: TextStyle(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (_selectedTab == 'Login')
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        _showSnackBar(
                                          "Forgot passcode clicked!",
                                        );
                                      },
                                      child: Text(
                                        "Forgot passcode?",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                const Spacer(), // This spacer will push the button to the bottom
                                SizedBox(
                                  width: double.infinity,
                                  height:
                                      55, // Fixed height for a button is standard
                                  child: ElevatedButton(
                                    onPressed: _handleAuthAction,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      _selectedTab == 'Login'
                                          ? "Login"
                                          : "Sign-up",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ), // Padding below the button to match the image
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
