import 'package:bet_friends/screens/HomeScreen.dart';
import 'package:bet_friends/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'constants/Constants.dart';
import 'firebase_options.dart';
import 'logic/DatabaseHandler.dart';
import 'logic/UserDataProvider.dart';
import 'models/CustomUser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late final DatabaseHandler databaseHandler = DatabaseHandler();

  late CustomUser user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserDataProvider(),
        child: MaterialApp(
          title: 'BetFriends',
          theme: ThemeData(
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          home: StreamBuilder<User?>(
            stream: auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Use DatabaseHandler to get the user
                return FutureBuilder<CustomUser?>(
                  future:
                      databaseHandler.getUserFromDatabase(snapshot.data!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userProvider =
                          Provider.of<UserDataProvider>(context, listen: false);
                      userProvider.setUser(snapshot.data!);
                      userProvider.fetchMatches();
                      return HomeScreen(
                        onLogout: () {
                          _showLogoutConfirmation(context);
                        },
                      );
                    } else if (snapshot.hasError) {
                      // Handle error
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Show loading indicator
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Constants.primaryGreen,
                      ));
                    }
                  },
                );
              } else {
                // User is not logged in, redirect to LoginScreen
                return const LoginScreen();
              }
            },
          ),
        ));
  }



  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
