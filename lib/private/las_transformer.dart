import 'package:las/private/las_line.dart';
import 'package:las/private/las_section.dart';

class LasTransformer {

  /// Stream transformer (identify line sections)
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

  /// Line ([line])section identification
  /// @returns section
  LasSection? _recognizeSection(String line) {
    if (line.startsWith('~V')) return LasSection.version;
    if (line.startsWith('~W')) return LasSection.well;
    if (line.startsWith('~C')) return LasSection.curve;
    if (line.startsWith('~P')) return LasSection.parameter;
    if (line.startsWith('~O')) return LasSection.other;
    if (line.startsWith('~A')) return LasSection.data;
    return null;
  }

  /// Coment [line] detection.
  bool _isCommentLine(String line) {
    return line.startsWith('#');
  }
}
