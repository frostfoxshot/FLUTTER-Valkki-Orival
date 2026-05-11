class ParsedResult {
  final String output;
  ParsedResult(this.output);
}

class LanguageParser {
  ParsedResult parse(String input) {
    // TODO: tokenizing, grammar rules, etc.
    // For now, just echoes input.
    return ParsedResult("Parsed: $input");
  }
}