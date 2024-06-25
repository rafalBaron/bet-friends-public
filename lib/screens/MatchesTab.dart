import 'package:bet_friends/constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../logic/UserDataProvider.dart';
import '../models/CustomMatch.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State createState() => _MatchesTabState();
}

class _MatchesTabState extends State {
  final List groupMatchDays = [
    DateTime(2024, 6, 14),
    DateTime(2024, 6, 15),
    DateTime(2024, 6, 16),
    DateTime(2024, 6, 17),
    DateTime(2024, 6, 18),
    DateTime(2024, 6, 19),
    DateTime(2024, 6, 20),
    DateTime(2024, 6, 21),
    DateTime(2024, 6, 22),
    DateTime(2024, 6, 23),
    DateTime(2024, 6, 24),
    DateTime(2024, 6, 25),
    DateTime(2024, 6, 26)
  ];

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

  Widget matchDay(CustomMatch singleMatch, int index, UserDataProvider userDataProvider) {
    return Container(
        width: double.maxFinite,
        margin: Constants.listPaddingMedium,
        padding: Constants.paddingMedium,
        decoration: const BoxDecoration(
          color: Constants.primaryWhite,
          borderRadius: Constants.borderRadiusMedium,
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                  borderRadius: Constants.borderRadiusSmall,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    color: Constants.primaryGreen,
                    child: Text(
                      DateFormat('dd MMM').format(singleMatch.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ))
            ]),
            const SizedBox(height: 16),
            match(singleMatch,index,userDataProvider),
          ],
        ));
  }

  Widget match(CustomMatch singleMatch, int index, UserDataProvider userDataProvider) {
    String date = DateFormat('dd MMM yyyy').format(singleMatch.date);
    String gameHour = DateFormat('HH:mm').format(singleMatch.date);

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
              decoration: const BoxDecoration(
                  color: Colors.transparent,
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
                  Text(
                    singleMatch.result.substring(0,1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Constants.primaryBlack,
                    ),
                  ),
                  const Text(
                    ":",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Constants.primaryBlack,
                    ),
                  ),
                  Text(
                    singleMatch.result.substring(2,3),
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
              ))
        ]));
  }
}
