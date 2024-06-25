import 'package:bet_friends/screens/SignupScreen.dart';
import 'package:bet_friends/services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/Constants.dart';
import '../logic/DatabaseHandler.dart';
import '../screens/HomeScreen.dart';
import '../models/CustomUser.dart';
import '../constants/Constants.dart';
import '../widgets/Widgets.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late final DatabaseHandler databaseHandler = DatabaseHandler();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoadingLogin = false;
  bool _isLoadingGoogle = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoadingLogin = true;
    });

    try {
      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Pobranie danych użytkownika z Firebase
      User? firebaseUser = await FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('Nie znaleziono użytkownika.', false);
      } else if (e.code == 'wrong-password') {
        _showSnackBar('Nieprawidłowe hasło.', false);
      } else {
        _showSnackBar('Wystąpił błąd podczas logowania.', false);
      }
    } finally {
      setState(() {
        _isLoadingLogin = false;
      });
    }
  }

  void _showSnackBar(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Constants.primaryGreen : Constants.primaryRed,
        content: Text(message),
        behavior: SnackBarBehavior.floating, // Make it float
        duration: Duration(seconds: 5), // Customize duration
      ),
    );
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    final _emailController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: Constants.borderRadiusMedium),
          backgroundColor: Constants.primaryBlack,
          title: const Text('Reset password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 8.0),
              hintText: 'E-mail',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: Constants.borderRadiusMedium,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: Constants.borderRadiusMedium,
                borderSide: BorderSide(
                  color: Constants.primaryGreen,
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Constants.primaryRed,
                  foregroundColor: Constants.primaryWhite,
                  shape: const RoundedRectangleBorder(
                      borderRadius: Constants.borderRadiusSmall)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Constants.primaryGreen,
                  foregroundColor: Constants.primaryWhite,
                  shape: const RoundedRectangleBorder(
                      borderRadius: Constants.borderRadiusSmall)),
              onPressed: () async {
                String email = _emailController.text.trim();
                if (email.isEmpty) {
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                  _showSnackBar('Fill e-mail!', false);
                  return;
                }
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                  _showSnackBar('Information sent via email!', true);
                } on FirebaseAuthException catch (e) {
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                  _showSnackBar('User not found!', false);
                }
              },
              child: Text('Reset'),
            ),
          ],
        );
      },
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
                  child: Image.asset(
                    "lib/assets/images/logo1.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 50),
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
                                    if (value == null || value.isEmpty) {
                                      return 'Enter password';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _showForgotPasswordDialog(context);
                                },
                                child: const Text(
                                  "Forgot password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                    color: Constants.primaryWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: Constants.paddingSmall,
                            child: ElevatedButton(
                              onPressed: _isLoadingLogin
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  _signInWithEmailAndPassword();
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
                                  : const Text('Sign in'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Column(children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: Constants.paddingSmall,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignupScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.primaryBlue,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(fontSize: 14),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: Constants.borderRadiusSmall,
                                    ),
                                    minimumSize: const Size(200, 45),
                                    maximumSize: const Size(210, 45),
                                    padding: const EdgeInsets.only(left: 6, right: 6)
                                ),
                                child: const Row(

                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.email_rounded),
                                    Text('  Continue with e-mail',
                                        style: TextStyle(
                                            fontSize: 16
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                                padding: Constants.paddingSmall,
                                child: InkWell(
                                  child: GestureDetector(
                                    onTap: _isLoadingGoogle
                                        ? null
                                        : () async {
                                      try {
                                        CustomUser userModel;

                                        setState(() {
                                          _isLoadingGoogle = true;
                                        });
                                        await _authService.signInWithGoogle();
                                        User? firebaseUser = await FirebaseAuth
                                            .instance.currentUser;
                                        if (firebaseUser != null) {
                                          final docRef = db
                                              .collection("Users")
                                              .doc(firebaseUser.uid);
                                          final DocumentSnapshot doc =
                                          await docRef.get();

                                          if (doc.exists) {
                                            final data = doc.data()
                                            as Map<String, dynamic>;
                                            userModel = CustomUser(
                                              uid: data['uid'],
                                              email: data['email'],
                                              displayName: data['username'],
                                            );
                                          } else {
                                            await db
                                                .collection("Users")
                                                .doc(firebaseUser.uid)
                                                .set({
                                              'uid': firebaseUser.uid,
                                              'email': firebaseUser.email,
                                              'username': firebaseUser.email
                                                  ?.split('@')[0]
                                            });

                                            final docRef = db
                                                .collection("Users")
                                                .doc(firebaseUser.uid);
                                            final DocumentSnapshot doc =
                                            await docRef.get();

                                            final data = doc.data()
                                            as Map<String, dynamic>;
                                            userModel = CustomUser(
                                              uid: data['uid'],
                                              email: data['email'],
                                              displayName: data['username'],
                                            );
                                          }
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(
                                                        onLogout: () {
                                                          _showLogoutConfirmation(
                                                              context);
                                                        },
                                                      )));
                                        }
                                        setState(() {
                                          _isLoadingGoogle = false;
                                        });
                                      } catch (e) {
                                        _showSnackBar(
                                            'Błąd podczas logowania: $e', false);
                                      }
                                    },
                                    child: _isLoadingGoogle
                                        ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                        : Container(
                                      padding: Constants.paddingSmall,
                                      width: 200,
                                      height: 45,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "lib/assets/images/google.png"),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                          Constants.borderRadiusSmall),
                                    ),
                                  ),
                                ))
                          ])
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
              borderRadius: Constants.borderRadiusLarge),
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
                      borderRadius: Constants.borderRadiusSmall)),
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
                      borderRadius: Constants.borderRadiusSmall)),
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
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