import 'package:las/private/las_line.dart';
import 'package:las/private/las_section.dart';

class LasTransformer {
  Stream<LasLine> linesToLasLines(Stream<String> lines) async* {
    LasSection? section;
    var lineNumber = 1;
    await for (final line in lines) {
      if (!_isCommentLine(line)) {
        final lineSection = _recognizeSection(line);
        if (lineSection != null && section != lineSection) section = lineSection;
        if (section != null) yield LasLine(section, lineNumber, line); 
      }
      lineNumber++;
    }
  }

  /// Identifica a seção a qual a linha pertence e armazena a declaração na tabela de símbolos.
  /// @param line linha atual.
  LasSection? _recognizeSection(String line) {
    if (line.startsWith('~V')) return LasSection.version;
    if (line.startsWith('~W')) return LasSection.well;
    if (line.startsWith('~C')) return LasSection.curve;
    if (line.startsWith('~P')) return LasSection.parameter;
    if (line.startsWith('~O')) return LasSection.other;
    if (line.startsWith('~A')) return LasSection.data;
    return null;
  }

  bool _isCommentLine(String line) {
    return line.startsWith('#');
  }
}
