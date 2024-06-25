import 'package:bet_friends/screens/LoginScreen.dart';
import 'package:bet_friends/services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/Constants.dart';
import '../logic/DatabaseHandler.dart';
import '../screens/HomeScreen.dart';
import '../models/CustomUser.dart';
import '../widgets/Widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late final DatabaseHandler databaseHandler = DatabaseHandler();

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool _isLoadingLogin = false;
  bool _isLoadingGoogle = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    setState(() {
      _isLoadingLogin = true;
    });

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        User? firebaseUser = await FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          await db.collection("Users").doc(firebaseUser.uid).set({
            'uid': firebaseUser.uid,
            'email': firebaseUser.email,
            'username': _username.text.trim()
          });

          final docRef = db.collection("Users").doc(firebaseUser.uid);
          final DocumentSnapshot doc = await docRef.get();

          final data = doc.data() as Map<String, dynamic>;
          CustomUser userModel = CustomUser(
            uid: data['uid'],
            email: data['email'],
            displayName: data['username'],
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        onLogout: () {
                          _showLogoutConfirmation(context);
                        },
                      )));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('Nie znaleziono użytkownika.');
      } else if (e.code == 'wrong-password') {
        _showSnackBar('Nieprawidłowe hasło.');
      } else {
        _showSnackBar('Wystąpił błąd podczas rejestracji.');
      }
    } finally {
      setState(() {
        _isLoadingLogin = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TopSnackBar(message: message),
        behavior: SnackBarBehavior.floating, // Make it float
        duration: Duration(seconds: 5), // Customize duration
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryBlack,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: 300,
                child: Image.asset(
                  "lib/assets/images/logo1.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            //const SizedBox(height: 50),
            Center(
                child: Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: Constants.paddingSmall,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.primaryWhite,
                          borderRadius: Constants.borderRadiusSmall,
                          boxShadow: [Constants.primaryShadow],
                        ),
                        child: TextFormField(
                          controller: _username,
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                  height: 0.01, color: Colors.transparent),
                              prefixIcon: Icon(Icons.account_box_rounded),
                              hintText: 'Username',
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: Constants.borderRadiusSmall,
                                borderSide: BorderSide(
                                    color: Constants.primaryGreen, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: Constants.borderRadiusSmall,
                                borderSide: BorderSide(
                                    color: Constants.primaryRed, width: 2),
                              ),
                              focusedErrorBorder: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter password';
                            }
                            return null;
                          },
                        ),
                      )),
                  Padding(
                      padding: Constants.paddingSmall,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.primaryWhite,
                          borderRadius: Constants.borderRadiusSmall,
                          boxShadow: [Constants.primaryShadow],
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            //filled: true,
                            //fillColor: Constants.primaryWhite,
                            //contentPadding: EdgeInsets.symmetric(vertical: 10),
                            prefixIcon: Icon(Icons.email_rounded),
                            hintText: 'E-mail',
                            border: InputBorder.none,
                            errorStyle: TextStyle(
                                height: 0.01, color: Colors.transparent),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: Constants.borderRadiusSmall,
                              borderSide: BorderSide(
                                  color: Constants.primaryGreen, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: Constants.borderRadiusSmall,
                              borderSide: BorderSide(
                                  color: Constants.primaryRed, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: Constants.borderRadiusSmall,
                              borderSide: BorderSide(
                                  color: Constants.primaryRed, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter e-mail';
                            }
                            if (!value.contains('@')) {
                              return 'Invalid e-mail';
                            }
                            return null;
                          },
                        ),
                      )),
                  Padding(
                      padding: Constants.paddingSmall,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.primaryWhite,
                          borderRadius: Constants.borderRadiusSmall,
                          boxShadow: [Constants.primaryShadow],
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                  height: 0.01, color: Colors.transparent),
                              prefixIcon: Icon(Icons.lock_rounded),
                              hintText: 'Password',
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: Constants.borderRadiusSmall,
                                borderSide: BorderSide(
                                    color: Constants.primaryGreen, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: Constants.borderRadiusSmall,
                                borderSide: BorderSide(
                                    color: Constants.primaryRed, width: 2),
                              ),
                              focusedErrorBorder: InputBorder.none),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != _rePasswordController.text ||
                                value.length < 8) {
                              return 'Error';
                            }
                            return null;
                          },
                        ),
                      )),
                  Padding(
                      padding: Constants.paddingSmall,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.primaryWhite,
                          borderRadius: Constants.borderRadiusSmall,
                          boxShadow: [Constants.primaryShadow],
                        ),
                        child: TextFormField(
                          controller: _rePasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                  height: 0.01, color: Colors.transparent),
                              prefixIcon: Icon(Icons.lock_rounded),
                              hintText: 'Re-password',
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: Constants.borderRadiusSmall,
                                borderSide: BorderSide(
                                    color: Constants.primaryGreen, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: Constants.borderRadiusSmall,
                                borderSide: BorderSide(
                                    color: Constants.primaryRed, width: 2),
                              ),
                              focusedErrorBorder: InputBorder.none),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != _passwordController.text ||
                                value.length < 8) {
                              return 'Error';
                            }
                            return null;
                          },
                        ),
                      )),
                  Padding(
                    padding: Constants.paddingSmall,
                    child: ElevatedButton(
                      onPressed: _isLoadingLogin
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                _signUpWithEmailAndPassword();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryGreen,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18),
                        shape: const RoundedRectangleBorder(
                          borderRadius: Constants.borderRadiusSmall,
                        ),
                        minimumSize: const Size(200, 45),
                      ),
                      child: _isLoadingLogin
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    ));
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: Constants.borderRadiusMedium),
          backgroundColor: Constants.primaryBlack,
          title: const Text('Sign Out',
              style: TextStyle(color: Constants.primaryWhite)),
          content: const Text('Are you sure?',
              style: TextStyle(color: Constants.primaryWhite)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Constants.primaryWhite,
                  backgroundColor: Constants.primaryGreen,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Constants.primaryRed,
                  foregroundColor: Constants.primaryWhite,
                  shape: const RoundedRectangleBorder(
                      borderRadius: Constants.borderRadiusMedium)),
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                });
              },
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );
  }
}
