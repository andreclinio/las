import 'package:las/private/las_section.dart';

/// Interpreted Las line
class LasLine {
  
  /// Content
  final String line;

  // Section
  final LasSection section;

  /// line number (for debugging and error porposes)
  final int lineNumber;

  /// Constructor
  LasLine(this.section, this.lineNumber, this.line);

  /// Section mark detecttion.
  bool isSectionLine() {
    return line.startsWith('~');
  }

  /// Debug toString method.
  @override
  String toString() {
    return '#$lineNumber : [$section] - "$line"';
  }
}
