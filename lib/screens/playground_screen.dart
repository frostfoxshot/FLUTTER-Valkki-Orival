import 'package:flutter/material.dart';
import '../services/language_parser.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final TextEditingController _controller = TextEditingController();
  final LanguageParser _parser = LanguageParser();
  String _output = '';

  void _parse() {
    setState(() {
      _output = _parser.parse(_controller.text).output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground'), centerTitle: true),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Input (Välkki-Örival)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write something...'),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: _parse, child: const Text('Parse →')),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Output',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    child: SelectableText(_output,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}