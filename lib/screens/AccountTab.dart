import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/Constants.dart';
import '../logic/UserDataProvider.dart';
import '../models/CustomUser.dart';

class AccountTab extends StatefulWidget {
  final VoidCallback onLogout;

  const AccountTab({super.key, required this.onLogout});

  @override
  State<AccountTab> createState() => _AccountTabState(onLogout: onLogout);
}

class _AccountTabState extends State<AccountTab> {
  late final VoidCallback onLogout;

  _AccountTabState({Key? key, required this.onLogout});

  FirebaseAuth auth = FirebaseAuth.instance;
  String _newUsername = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.primaryBlack,
        body: Container(
            padding: Constants.paddingMedium,
            child: Column(
              children: [
                Column(
                  children: [
                    /*const Icon(
                      Icons.account_box_rounded,
                      color: Constants.primaryWhite,
                      size: 40,
                    ),*/
                    const SizedBox(height: 8),
                    const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      /*Expanded(
                          child: Divider()
                      ),
                      SizedBox(width: 8),*/
                      Text("Username",
                          style: TextStyle(
                            color: Constants.primaryWhite,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          )),
                      SizedBox(width: 8),
                      Expanded(
                          child: Divider()
                      ),
                    ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<UserDataProvider>(
                              builder: (context, model, child) {
                            return Text(
                              model.loggedUser!.displayName.toString(),
                              style: const TextStyle(
                                  color: Constants.primaryYellow,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            );
                          }),
                          ElevatedButton(
                              onPressed: () {
                                // Wyświetl AlertDialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: Constants.borderRadiusMedium),
                                      backgroundColor: Constants.primaryBlack,
                                      title: const Text('Edit Username', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                      content: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          initialValue:
                                          Provider.of<UserDataProvider>(context,
                                              listen: false)
                                              .loggedUser!
                                              .displayName,
                                          decoration: const InputDecoration(
                                            hintText: 'New Username',
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
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a new username';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _newUsername = value;
                                            });
                                          },
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
                                            Navigator.of(context).pop(); // Zamknij AlertDialog
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Constants.primaryGreen,
                                              foregroundColor: Constants.primaryWhite,
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: Constants.borderRadiusSmall)),
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              updateUsername(_newUsername);
                                              Navigator.of(context).pop(); // Zamknij AlertDialog
                                            }
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(30, 30),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: Constants.borderRadiusSmall,
                                  ),
                                  elevation: 10,
                                  backgroundColor: Constants.primaryGreen),
                              child: const Icon(
                                Icons.edit,
                                color: Constants.primaryBlack,
                              ))
                        ])
                  ],
                ),
                /*Divider(
                  color: Constants.lightBlack,
                ),*/
                Column(
                  children: [
                    /*Icon(
                      Icons.email_rounded,
                      color: Constants.primaryWhite,
                      size: 40,
                    ),*/
                    const SizedBox(height: 8),
                    const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      /*Expanded(
                          child: Divider()
                      ),
                      SizedBox(width: 8),*/
                      Text("E-mail",
                          style: TextStyle(
                            color: Constants.primaryWhite,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          )),
                      SizedBox(width: 8),
                      Expanded(
                          child: Divider()
                      ),
                    ]),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Consumer<UserDataProvider>(
                          builder: (context, model, child) {
                        return Text(
                          model.loggedUser!.email.toString(),
                          style: const TextStyle(
                              color: Constants.primaryYellow,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                    ])
                  ],
                ),
                const SizedBox(height: 8),
                /*const Divider(
                  color: Constants.lightBlack,
                ),*/
                const SizedBox(height: 8),
                Expanded(
                    child: ElevatedButton(
                        onPressed: onLogout,
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            /*side: BorderSide(
                              color: Constants.lightBlack,
                              width: 1,
                            ),*/
                            borderRadius: Constants.borderRadiusMedium,
                          ),
                          backgroundColor: Constants.primaryBlue.withOpacity(1),
                        ),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 50,
                                color: Constants.primaryWhite,
                              ),
                            ])))
              ],
            )));
  }

  Future<void> updateUsername(String newUsername) async {
    final user = FirebaseAuth.instance.currentUser; // Pobierz aktualnego użytkownika

    if (user != null) {
      try {
        // Zaktualizuj username w Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'username': newUsername});

        final userProvider =
        Provider.of<UserDataProvider>(context, listen: false);

        userProvider.updateUsername(newUsername);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated!')),
        );
      } catch (e) {
        print("Error updating username: ${e.toString()}");
        // Pokaż powiadomienie o błędzie
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating username: ${e.toString()}')),
        );
      }
    } else {
      // Pokaż powiadomienie o błędzie - użytkownik nie jest zalogowany
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in!')),
      );
    }
  }

}

