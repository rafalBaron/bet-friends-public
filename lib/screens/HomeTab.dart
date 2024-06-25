import 'package:bet_friends/logic/DatabaseHandler.dart';
import 'package:bet_friends/logic/UserDataProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/Constants.dart';
import '../models/GeneralStandingUser.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseHandler();

    return SingleChildScrollView(
        padding: Constants.paddingMedium,
        child: Column(children: [
          Consumer<UserDataProvider>(builder: (context, model, child) {
            return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("Welcome, " + model.loggedUser!.displayName.toString() + "!",
                  style: const TextStyle(
                      color: Constants.primaryWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 22))
            ]);
          }),
          const SizedBox(height: 16),
          Opacity(
              opacity: 1,
              child: Container(
                  padding: const EdgeInsets.only(top: 100.0),
                  height: 150,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      )
                    ],
                    borderRadius: Constants.borderRadiusMedium,
                    image: const DecorationImage(
                      image: AssetImage('lib/assets/images/rules.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: Constants.borderRadiusSmall,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            color: Constants.primaryGreen,
                            child: const Text(
                              "Rules",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ],
                  ))),
          const SizedBox(height: 16),
          Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        )
                      ],
                      borderRadius: Constants.borderRadiusMedium,
                      color: Constants.primaryGreen),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Maximum 5",
                          style: TextStyle(
                            color: Constants.primaryWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      Image.asset(
                        "lib/assets/images/point.png",
                        height: 30,
                        width: 30,
                      ),
                      const Text(" per match:",
                          style: TextStyle(
                            color: Constants.primaryWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ]),
                    const SizedBox(
                      height: 8,
                    ),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Accurate result",
                              style: TextStyle(
                                color: Constants.primaryWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("3",
                          style: TextStyle(
                            color: Constants.primaryWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      Image.asset(
                        "lib/assets/images/point.png",
                        height: 30,
                        width: 30,
                      )
                    ]),
                    const SizedBox(
                      height: 8,
                    ),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Winner",
                              style: TextStyle(
                                color: Constants.primaryWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("2",
                          style: TextStyle(
                            color: Constants.primaryWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      Image.asset(
                        "lib/assets/images/point.png",
                        height: 30,
                        width: 30,
                      )
                    ]),
                  ])),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Constants.primaryWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 0), // changes position of shadow
                    )
                  ],
                  borderRadius: Constants.borderRadiusMedium,
                ),
                child: Column(children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("General standings",
                        style: TextStyle(
                          color: Constants.primaryBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),],
                  ),
                ]),
              )
            ],
          ),
        ]));
  }
}
