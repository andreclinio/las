

import 'package:las/private/las_section.dart';

class LasLine{
  
  final String line;
  final LasSection section;
  final int lineNumber;

  LasLine(this.section, this.lineNumber, this.line);

  bool isSectionLine() {
    return line.startsWith('~');
  }

  @override
  String toString() {
    return '#$lineNumber : [$section] - "$line"';
  }

}