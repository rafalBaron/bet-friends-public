import 'package:bet_friends/constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/DatabaseHandler.dart';
import '../logic/UserDataProvider.dart';
import '../models/CustomMatch.dart';

class GroupsTab extends StatefulWidget {
  const GroupsTab({super.key});

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("")
    );
  }
}
