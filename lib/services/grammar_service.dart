import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/grammar_section.dart';

class GrammarService {
  List<GrammarSection> _sections = [];

  Future<void> loadGrammar() async {
    final jsonString = await rootBundle.loadString('assets/data/grammar.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _sections = jsonList.map((e) => GrammarSection.fromJson(e)).toList();
  }

  List<GrammarSection> get sections => _sections;
}