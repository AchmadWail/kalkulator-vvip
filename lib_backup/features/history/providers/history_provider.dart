import 'package:flutter/material.dart';
import '../models/history_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryModel> _history = [];
  List<HistoryModel> get history => _history;

  HistoryProvider() {
    _loadHistory();
  }

  void addHistory(String expression, String result) {
    _history.insert(0, HistoryModel(expression: expression, result: result, timestamp: DateTime.now()));
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _history.map((h) => jsonEncode(h.toJson())).toList();
    prefs.setStringList('calc_history', jsonList);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('calc_history') ?? [];
    _history = jsonList.map((j) => HistoryModel.fromJson(jsonDecode(j))).toList();
    notifyListeners();
  }
}
