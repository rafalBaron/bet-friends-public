import 'package:bet_friends/constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../logic/UserDataProvider.dart';
import '../models/CustomMatch.dart';

class BetsTab extends StatefulWidget {
  const BetsTab({super.key});

  @override
  State<BetsTab> createState() => _BetsTabState();
}

class _BetsTabState extends State<BetsTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<int>> _localBets = {};
  Map<String, bool> _isPlacedLocal = {};

  @override
  void initState() {
    super.initState();
    _loadIsPlacedLocalFromUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        return ListView.builder(
          padding: Constants.paddingMedium,
          itemCount: userDataProvider.matchList.length,
          itemBuilder: (context, index) {
            return match(
                userDataProvider.matchList[index], index, userDataProvider);
          },
        );
      },
    );
  }

  void _loadIsPlacedLocalFromUserData() {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final bets = userDataProvider.loggedUser?.bets;
    if (bets != null) {
      setState(() {
        _isPlacedLocal = {};
        for (String matchId in bets.keys) {
          _isPlacedLocal[matchId] = true;
        }
      });
    }
  }

  void _updateIsPlacedLocal(String matchId, bool newValue) {
    setState(() {
      _isPlacedLocal[matchId] = newValue;
    });
  }

  Widget match(
      CustomMatch singleMatch, int index, UserDataProvider userDataProvider) {
    String date = DateFormat('dd MMM yyyy').format(singleMatch.date);
    String gameHour = DateFormat('HH:mm').format(singleMatch.date);
    String matchId = singleMatch.id.toString();

    Map<String, dynamic>? bets = userDataProvider.loggedUser?.bets;
    String? bet = bets?[matchId];
    List<String> betValues = bet != null ? bet.split(':') : ['0', '0'];

    List<int> localBet = _localBets[matchId] ??
        [int.tryParse(betValues[0]) ?? 0, int.tryParse(betValues[1]) ?? 0];

    bool isBetPlaced = bet != null;
    bool isPlacedLocal = _isPlacedLocal[matchId] ?? false;

    final homeGoals = ValueNotifier<int>(localBet[0]);
    final awayGoals = ValueNotifier<int>(localBet[1]);

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Constants.borderRadiusMedium,
            boxShadow: [Constants.primaryShadow]),
        padding: Constants.paddingMedium,
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                singleMatch.stadion,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Constants.primaryBlue,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Constants.primaryBlack,
                ),
              ),
              Text(
                gameHour,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Constants.primaryBlack,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
              padding: Constants.paddingMedium,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: Constants.borderRadiusLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 38,
                    height: 30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'lib/assets/images/flags/${singleMatch.homeTeam.toLowerCase()}.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [Constants.primaryShadow],
                        borderRadius: Constants.borderRadiusSmall),
                  ),
                  Text(
                    singleMatch.homeTeam,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Constants.primaryBlack,
                    ),
                  ),
                  const Text(
                    "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Constants.primaryBlack,
                    ),
                  ),
                  Text(
                    singleMatch.awayTeam,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Constants.primaryBlack,
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'lib/assets/images/flags/${singleMatch.awayTeam.toLowerCase()}.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [Constants.primaryShadow],
                        borderRadius: Constants.borderRadiusSmall),
                  ),
                ],
              )),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (!isPlacedLocal)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        homeGoals.value = (homeGoals.value + 1);
                        _localBets[matchId] = [
                          homeGoals.value,
                          awayGoals.value
                        ];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: Constants.borderRadiusSmall,
                        ),
                        elevation: 3,
                        backgroundColor: Constants.primaryGreen),
                    child: const Text("+",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (homeGoals.value > 0) {
                          homeGoals.value = (homeGoals.value - 1);
                          _localBets[matchId] = [
                            homeGoals.value,
                            awayGoals.value
                          ];
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius: Constants.borderRadiusSmall,
                        ),
                        elevation: 3,
                        backgroundColor: Constants.primaryRed),
                    child: const Text("-",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                ],
              ),
            ValueListenableBuilder<int>(
              valueListenable: homeGoals,
              builder: (context, value, child) => Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50)),
                padding: Constants.paddingMedium,
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Constants.primaryBlack,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: awayGoals,
              builder: (context, value, child) => Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50)),
                padding: Constants.paddingMedium,
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Constants.primaryBlack,
                  ),
                ),
              ),
            ),
            if (!isPlacedLocal)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        awayGoals.value = (awayGoals.value + 1);
                        _localBets[matchId] = [
                          homeGoals.value,
                          awayGoals.value
                        ];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: Constants.borderRadiusSmall,
                        ),
                        elevation: 3,
                        backgroundColor: Constants.primaryGreen),
                    child: const Text("+",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (awayGoals.value > 0) {
                          awayGoals.value = (awayGoals.value - 1);
                          _localBets[matchId] = [
                            homeGoals.value,
                            awayGoals.value
                          ];
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius: Constants.borderRadiusSmall,
                        ),
                        elevation: 3,
                        backgroundColor: Constants.primaryRed),
                    child: const Text("-",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                ],
              )
          ]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isPlacedLocal)
                ElevatedButton(
                  onPressed: () {
                    if (!(DateTime.now().isAfter(singleMatch.date) ||
                        DateTime.now().isAtSameMomentAs(singleMatch.date))) {
                      _saveBet(matchId, '${homeGoals.value}:${awayGoals.value}',
                          userDataProvider);
                      _showSnackBar(
                          "Bet saved!", true);
                    } else {
                      _showSnackBar(
                          "You can't save bet after play time!", false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: Constants.paddingSmall,
                      shape: const RoundedRectangleBorder(
                        borderRadius: Constants.borderRadiusSmall,
                      ),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      backgroundColor: Constants.primaryBlue),
                  child: Text('SAVE', style: const TextStyle(fontSize: 14)),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    if (!(DateTime.now().isAfter(singleMatch.date) ||
                        DateTime.now().isAtSameMomentAs(singleMatch.date))) {
                      _updateIsPlacedLocal(matchId, false);
                    } else {
                      _showSnackBar(
                          "You can't edit bet after play time!", false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: Constants.paddingSmall,
                      shape: const RoundedRectangleBorder(
                        borderRadius: Constants.borderRadiusSmall,
                      ),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      backgroundColor: Constants.primaryBlue),
                  child: Text('EDIT', style: const TextStyle(fontSize: 14)),
                ),
            ],
          )
        ]));
  }

  void _showSnackBar(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            success ? Constants.primaryGreen : Constants.primaryRed,
        content: Text(message),
        behavior: SnackBarBehavior.floating, // Make it float
        duration: Duration(seconds: 2), // Customize duration
      ),
    );
  }

  void _saveBet(
      String matchId, String bet, UserDataProvider userDataProvider) async {
    String userId = userDataProvider.loggedUser!.uid;
    DocumentReference userDoc = _firestore.collection('Users').doc(userId);

    await userDoc.update({'bets.$matchId': bet});

    userDataProvider.updateBet(matchId, bet);

    _updateIsPlacedLocal(matchId, true);
    _localBets.clear();

    setState(() {});
  }
}
