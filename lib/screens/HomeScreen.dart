import 'package:bet_friends/screens/AccountTab.dart';
import 'package:bet_friends/screens/GroupsTab.dart';
import 'package:bet_friends/screens/HomeTab.dart';
import 'package:bet_friends/screens/MatchesTab.dart';
import 'package:flutter/material.dart';

import '../constants/Constants.dart';
import '../models/CustomUser.dart';
import 'BetsTab.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout; // Add this to receive the callback

  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState(onLogout: onLogout);
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  late final VoidCallback onLogout;

  _HomeScreenState({Key? key, required this.onLogout});

  late TabController _tcontroller;
  final List<String> titleList = [
    "Account",
    "Matches",
    "Home",
    "Bets",
    "Groups"
  ];
  late String currentTitle;

  @override
  void initState() {
    currentTitle = titleList[2];
    _tcontroller = TabController(length: 5, vsync: this, initialIndex: 2);
    _tcontroller.addListener(changeTitle); // Registering listener
    super.initState();
  }

  // This function is called, every time active tab is changed
  void changeTitle() {
      currentTitle = titleList[_tcontroller.index];
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Constants.primaryBlack,
        appBar: appBar(),
        bottomNavigationBar: tabBarMenu(),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tcontroller,
          children: [
            AccountTab(onLogout: onLogout),
            const MatchesTab(),
            const HomeTab(),
            const BetsTab(),
            const GroupsTab(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 43, 44, 54),
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: AppBar(
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80))),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 43, 44, 54),
              title: Text(currentTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              foregroundColor: Constants.primaryYellow,
            )));
  }

  Widget tabBarMenu() {
    return Container(
      height: 60,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Constants.primaryBlack,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: _tcontroller,
        labelColor: Constants.primaryYellow,
        indicatorColor: Colors.transparent,
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(
          fontSize: 11.0,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.account_circle_rounded), text: "Account"),
          Tab(icon: Icon(Icons.sports_soccer_outlined), text: "Matches"),
          Tab(icon: Icon(Icons.home_filled), text: "Home"),
          Tab(icon: Icon(Icons.confirmation_number), text: "Bets"),
          Tab(icon: Icon(Icons.group), text: "Groups")
        ],
      ),
    );
  }
}
