import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;                     // ← for web download
import '../models/language_info.dart';
import '../services/dictionary_service.dart';
import '../services/grammar_service.dart';
import 'grammar_screen.dart';
import 'dictionary_screen.dart';
import 'playground_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  LanguageInfo? _info;

  final List<Widget> _screens = const [
    Center(child: Text("Welcome to Välkki-Örival", style: TextStyle(fontSize: 24))),
    GrammarScreen(),
    DictionaryScreen(),
    PlaygroundScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final jsonString = await rootBundle.loadString('assets/data/info.json');
    final info = LanguageInfo.fromJson(json.decode(jsonString));
    setState(() => _info = info);
    if (info.maintenance) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Under Construction'),
            content: Text(info.maintenanceMessage),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
            ],
          ),
        );
      });
    }
  }

  Future<void> _generateTXT() async {
    try {
      final dictService = DictionaryService();
      await dictService.loadWords();
      final grammarService = GrammarService();
      await grammarService.loadGrammar();
      final jsonString = await rootBundle.loadString('assets/data/info.json');
      final info = LanguageInfo.fromJson(json.decode(jsonString));

      final updated = DateTime.parse('${info.lastUpdated}T12:00:00');
      final generated = DateTime.now();
      final months = info.months;

      String txt = '══════════════════════════════════════════════════════════════\n'
          '          VÄLKKI-ÖRIVAL / VÄLKKI-HÄEN\n'
          '             Official Reference Document ♡\n'
          '══════════════════════════════════════════════════════════════\n\n'
          'Version           : ${info.version}\n'
          'Last updated      : ${updated.day} ${months[updated.month - 1]} ${updated.year}\n'
          'Generated today   : ${generated.day} ${months[generated.month - 1]} ${generated.year}\n'
          'Created with love by : ${info.author}\n\n'
          'Heart This language is alive and growing — tiny bugs and sudden bursts\n'
          'of new words are just proof it’s being hugged a lot right now!\n\n'
          '══════════════════════════════════════════════════════════════\n'
          'DICTIONARY\n'
          '══════════════════════════════════════════════════════════════\n'
          'Word                  PoS                    Meaning\n'
          'Pronunciation  →  IPA\n'
          '──────────────────────────────────────────────────────────────\n';

      for (final w in dictService.words) {
        txt += '${w.word.padRight(21)}${w.pos.padRight(22)}${w.meaning}\n';
        txt += '${" " * 22}→ ${w.pron}  → ${w.ipa}\n\n';
      }

      txt += '══════════════════════════════════════════════════════════════\n'
          'GRAMMAR & PHONOLOGY\n'
          '══════════════════════════════════════════════════════════════\n\n';

      for (final sec in grammarService.sections) {
        txt += 'Heart ${sec.title.toUpperCase()}\n';
        txt += '${"─" * (sec.title.length + 8)}\n\n';
        for (final block in sec.blocks) {
          txt += '• ${block.summary}\n';
          final clean = block.content
              .replaceAll(RegExp(r'<[^>]*>'), ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
          txt += '  $clean\n\n';
        }
        txt += '\n';
      }

      txt += '══════════════════════════════════════════════════════════════\n'
          'Thank you for holding this language close to your heart.\n'
          'Every “nä wee-rär” makes the stars shine brighter.\n\n'
          'nä wee-rär ♡\n\n'
          '— ${info.author}\n'
          '${generated.day} ${months[generated.month - 1]} ${generated.year}\n';

      // Web‑safe download
      final blob = html.Blob([txt], 'text/plain');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download',
            'Välkki-Örival_v${info.version}_${info.lastUpdated}_official.txt')
        ..click();
      html.Url.revokeObjectUrl(url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reference document downloaded! ♡')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating TXT: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Välkki-Örival'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Generate TXT',
            onPressed: _generateTXT,
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home_outlined), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.menu_book_outlined), label: Text('Grammar')),
              NavigationRailDestination(icon: Icon(Icons.book_outlined), label: Text('Dictionary')),
              NavigationRailDestination(icon: Icon(Icons.code), label: Text('Playground')),
            ],
          ),
          const VerticalDivider(thickness: 1),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}