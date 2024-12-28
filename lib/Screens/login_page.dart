import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trj_gold/Screens/home_page.dart';
import 'package:trj_gold/models/user.dart';
import 'package:trj_gold/widgets/snackbar.dart';

Color sColor = const Color(0xFFf9e09e);

enum AuthState { signIn, resetPassword }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  User user = User();
  final _formKey = GlobalKey<FormState>();

  var enteredNumber = '';
  var enteredPassword = '';
  var confirmPassword = '';

  final _passwordController = TextEditingController();
  final _numberController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _isLoading = false;
  var _authState = AuthState.signIn; // Enum to manage states
  var _isSecure = true;
  var _isSecure1 = true;

  Future<void> _submitCredentials() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();
      _formKey.currentState!.save();
      await _login();
    }
  }

  Future<void> _login() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String url = 'https://digigold.dreamyoursinfotech.com/trj/login';
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    try {
      Map<String, dynamic> body;
      if (_authState == AuthState.resetPassword) {
        url = 'https://digigold.dreamyoursinfotech.com/trj/confirmpassword';
        body = {
          "phone": enteredNumber,
          "new_password": enteredPassword,
          "confirm_password": confirmPassword
        };
      } else {
        body = {"phone": enteredNumber, "password": enteredPassword};
      }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        _passwordController.clear();
        if (_authState == AuthState.resetPassword) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: BottomBar(
                text: 'Password reset successfully!',
                icon: Icons.check_circle_outline,
                tcolor: Colors.green,
              ),
            ),
          );
          setState(() {
            _authState = AuthState.signIn;
          });
        } else if (data['firstTime'] == true) {
          setState(() {
            _authState = AuthState.resetPassword;
          });
        } else if (data['message'] == 'Login successful') {
          final String aToken = data['token'];
          user.settoken(aToken);
          navigator.pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => Homepage(
                token: aToken,
              ),
            ),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: BottomBar(
                text: 'Invalid credentials. Please try again.',
                icon: Icons.error_outline,
                tcolor: Colors.red,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _authState = AuthState.signIn;
        });
        _passwordController.clear();
        _numberController.clear();
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: BottomBar(
              text: 'An error occurred. Please try again later.',
              icon: Icons.error_outline,
              tcolor: Colors.red,
            ),
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: BottomBar(
            text: 'Network error: $e',
            icon: Icons.wifi_off,
            tcolor: Colors.red,
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF790007),
              height: (size >= 280 && _authState == AuthState.resetPassword)
                  ? 250
                  : 330,
              child: Image.asset(
                'assets/trj.png',
                height: 250,
                width: 250,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: (size >= 280 && _authState == AuthState.resetPassword)
                ? 230
                : 300,
            child: Form(
              key: _formKey,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 68),
                      Text(
                        _authState == AuthState.resetPassword
                            ? "Reset Password"
                            : "Sign In",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF790007),
                            ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.length < 10) {
                            return 'Enter at least 10 characters';
                          }
                          return null;
                        },
                        maxLength: 10,
                        readOnly: _authState == AuthState.resetPassword,
                        controller: _numberController,
                        decoration: const InputDecoration(
                          hintText: 'Phone',
                          prefixIcon: Icon(Icons.call_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Color(0xFF790007),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (phone) {
                          enteredNumber = phone!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: _isSecure,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return 'Enter at least 3 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isSecure = !_isSecure;
                              });
                            },
                            icon: Icon(
                              _isSecure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: _authState == AuthState.resetPassword
                              ? 'New Password'
                              : 'Password',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xFF790007)),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onSaved: (value) {
                          enteredPassword = value!;
                        },
                      ),
                      if (_authState == AuthState.resetPassword)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            obscureText: _isSecure1,
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isSecure1 = !_isSecure1;
                                  });
                                },
                                icon: Icon(
                                  _isSecure1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              hintText: 'Confirm Password',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16.0),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF790007), width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            onSaved: (value) {
                              confirmPassword = value!;
                            },
                          ),
                        ),
                      if (_authState == AuthState.signIn)
                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(0.64),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitCredentials,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF790007),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(_authState == AuthState.resetPassword
                                ? "Confirm"
                                : "Sign In"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
