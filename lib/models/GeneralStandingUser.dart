import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralStandingUser {
  String? displayName;
  int points;

  GeneralStandingUser({this.points = 0, this.displayName});

  factory GeneralStandingUser.fromMap(Map<String, dynamic> data) {
    return GeneralStandingUser(
        displayName: data['displayName'], points: data['points']);
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'points': points,
    };
  }

  factory GeneralStandingUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return GeneralStandingUser(
        displayName: data['displayName'], points: data['points']);
  }
}
