class CustomUser {
  String uid;
  String? displayName;
  String? email;
  String? photoURL;
  int points;
  Map<String, dynamic>? bets;

  CustomUser({
    required this.uid,
    this.points = 0,
    this.bets,
    this.displayName,
    this.email,
    this.photoURL,
  });

  factory CustomUser.fromMap(Map<String, dynamic> data) {
    return CustomUser(
      uid: data['uid'],
      displayName: data['displayName'],
      email: data['email'],
      photoURL: data['photoURL'],
      points: data['points'],
      bets: data['bets']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'points' : points,
      'bets' : bets
    };
  }
}