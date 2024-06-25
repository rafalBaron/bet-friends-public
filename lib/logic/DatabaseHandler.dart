import 'package:bet_friends/models/GeneralStandingUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CustomMatch.dart';
import '../models/CustomUser.dart';
import '../models/GeneralStandingUser.dart';


class DatabaseHandler {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Method to get a user from the database
  Future<CustomUser?> getUserFromDatabase(String uid) async {
    final docRef = db.collection("Users").doc(uid);
    final DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return CustomUser(
        uid: data['uid'],
        email: data['email'],
        displayName: data['username'],
        bets: data['bets'],
        points: data['points']
      );
    } else {
      return null;
    }
  }

  Future<List<CustomMatch>> getMatches() async {
    QuerySnapshot querySnapshot = await db.collection('Match').orderBy('date', descending: false).get();
    List<CustomMatch> matches = querySnapshot.docs.map((doc) {
      return CustomMatch.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
    return matches;
  }

  Future<List<GeneralStandingUser>> getAllUsers() async {
    QuerySnapshot querySnapshot = await db.collection('Users').orderBy('points', descending: true).get();
    List<GeneralStandingUser> users = querySnapshot.docs.map((doc) {
      return GeneralStandingUser.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
    return users;
  }

}