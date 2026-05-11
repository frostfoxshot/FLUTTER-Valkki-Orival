import 'package:flutter/material.dart';
import '../services/grammar_service.dart';
import '../models/grammar_section.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  late Future<List<GrammarSection>> _futureGrammar;

  @override
  void initState() {
    super.initState();
    final service = GrammarService();
    _futureGrammar = service.loadGrammar().then((_) => service.sections);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar & Phonology'), centerTitle: true),
      body: FutureBuilder<List<GrammarSection>>(
        future: _futureGrammar,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Failed to load grammar'));
          }
          final sections = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sections.length,
            itemBuilder: (context, i) {
              final sec = sections[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sec.title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 12),
                      child: Text(sec.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                  ...sec.blocks.map((block) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          initiallyExpanded: block.open,
                          title: Text(block.summary,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: _renderHtml(block.content),
                            ),
                          ],
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _renderHtml(String html) {
    // Very simple HTML to plain text (replace with flutter_html for full rendering)
    final plain = html.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    return SelectableText(plain);
  }
}