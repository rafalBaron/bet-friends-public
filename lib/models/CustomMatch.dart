import 'package:cloud_firestore/cloud_firestore.dart';

class CustomMatch {
  String awayTeam;
  DateTime date;
  String homeTeam;
  String result;
  String stadion;
  String? id;

  CustomMatch({
    required this.awayTeam,
    required this.date,
    required this.homeTeam,
    required this.result,
    required this.stadion,
    this.id
  });

  factory CustomMatch.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return CustomMatch(
      awayTeam: data['awayTeam'],
      date: (data['date'] as Timestamp).toDate(),
      homeTeam: data['homeTeam'],
      result: data['result'],
      stadion: data['stadion'],
      id: snapshot.id,
    );
  }

}