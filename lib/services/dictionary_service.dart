import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';

class DictionaryService {
  List<Word> _allWords = [];

  Future<void> loadWords() async {
    final jsonString = await rootBundle.loadString('assets/data/dictionary.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _allWords = jsonList.map((e) => Word.fromJson(e)).toList();
  }

  List<Word> get words => _allWords;

  List<Word> search(String query) {
    if (query.isEmpty) return _allWords;
    final lowerQuery = query.toLowerCase();
    return _allWords.where((w) =>
        w.word.toLowerCase().contains(lowerQuery) ||
        w.meaning.toLowerCase().contains(lowerQuery)).toList();
  }
}