import 'package:flutter/material.dart';
import '../services/dictionary_service.dart';
import '../models/word.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  late DictionaryService _service;
  List<Word> _displayWords = [];
  String _query = '';
  bool _showNSFW = false;

  @override
  void initState() {
    super.initState();
    _service = DictionaryService();
    _service.loadWords().then((_) {
      _filter(); // <-- apply the NSFW filter immediately
    });
  }

  void _filter() {
    setState(() {
      var filtered = _service.search(_query);
      if (!_showNSFW) filtered = filtered.where((w) => !w.nsfw).toList();
      _displayWords = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dictionary'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    hintText: 'Search word or meaning...',
                    onChanged: (value) {
                      _query = value;
                      _filter();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FilterChip(
                  label: const Text('NSFW'),
                  selected: _showNSFW,
                  onSelected: (val) {
                    setState(() => _showNSFW = val);
                    _filter();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _displayWords.length,
              itemBuilder: (context, index) {
                final w = _displayWords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(w.word, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${w.pos} · ${w.meaning}'),
                        Text('${w.pron}  → ${w.ipa}',
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                      ],
                    ),
                    trailing: w.nsfw ? const Icon(Icons.warning_amber_rounded, color: Colors.red) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}