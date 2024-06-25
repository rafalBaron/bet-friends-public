import 'package:flutter/cupertino.dart';

import '../models/CustomMatch.dart';
import '../models/CustomUser.dart';
import 'DatabaseHandler.dart';

class UserDataProvider extends ChangeNotifier {
  CustomUser? _loggedUser;
  List<CustomMatch> _matchList = [];
  DatabaseHandler _databaseHandler = DatabaseHandler();

  CustomUser? get loggedUser => _loggedUser;
  List<CustomMatch> get matchList => _matchList;

  Future<void> fetchMatches() async {
    _matchList = await _databaseHandler.getMatches();
    notifyListeners();
  }

  void setUser(CustomUser user) {
    _loggedUser = user;
    notifyListeners();
  }

  void clearUserData() {
    _loggedUser = null;
    notifyListeners();
  }

  void updateUsername(String username) {
    _loggedUser?.displayName = username;
    notifyListeners();
  }

  void updateBet(String matchId, String bet) {
    if (_loggedUser != null && _loggedUser!.bets != null) {
      _loggedUser!.bets![matchId] = bet;
      notifyListeners();
    }
  }

  void updateLocal() {
    notifyListeners();
  }

}