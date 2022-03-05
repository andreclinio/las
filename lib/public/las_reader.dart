import 'dart:convert';
import 'dart:io';

import 'package:las/private/las_line.dart';
import 'package:las/private/las_section.dart';
import 'package:las/public/las_data.dart';
import 'package:las/public/las_info.dart';
import 'package:las/private/las_transformer.dart';

/// LAS reader
class LASReader {

  /// Reads the content of a file [file] and returns a [LasData] object async.
  /// This methods is a syntatic sugar for [readStream] using a stream based on file lines.
  Future<LasData> readFile(File file) async {
    if (!file.existsSync()) throw 'File ${file.absolute} not found';
    final stream = file.openRead().transform(utf8.decoder).transform(const LineSplitter());
    return readStream(stream);
  }

  /// Reads the content of a stream of strings ([lines]) where each one represents a line.
  /// Returns an [LasData] object async.
  Future<LasData> readStream(Stream<String> lines) async {
    final las = LasData();
    final lasLines = LasTransformer().linesToLasLines(lines);
    await for (LasLine lasLine in lasLines) {
      switch (lasLine.section) {
        case LasSection.version:
          _parseVersionLine(lasLine, las);
          break;
        case LasSection.well:
          parseWellLine(lasLine, las);
          break;
        case LasSection.curve:
          parseCurveLine(lasLine, las);
          break;
        case LasSection.parameter:
          parseParameterLine(lasLine, las);
          break;
        case LasSection.other:
          parseOtherLine(lasLine, las);
          break;
        case LasSection.data:
          _parseDataLine(lasLine, las);
          break;
      }
    }
    return las;
  }

  /// Analysis for a version section line ([LASSection.version]).
  void _parseVersionLine(LasLine lasLine, LasData las) {
    if (lasLine.isSectionLine()) {
      return;
    }
    final regex = RegExp(r'^[ \t]*(.+?)[ \t]*\.(.*?)[ \t]*:[ \t]*(.*)$');
    final line = lasLine.line;
    final match = regex.firstMatch(line);
    if (match == null) throw 'Bad formatted line: $lasLine';
    final tag = match.group(1)!.trim();
    final info = match.group(2)!.trim();
    final description = match.group(3)!.trim();

    if (tag == 'VERS') {
      las.setVersion(info);
      las.setVersionDescription(description);
    } else if (tag == 'WRAP') {
      las.setWrap(info == 'YES');
    }
  }

  /// Analysis for a well section line ([LASSection.well]).
  void parseWellLine(LasLine lasLine, LasData las) {
    final info = _parseInfo(lasLine);
    if (info == null) return;
    las.addWellInfo(info);
  }

  /// Analysis for a well section line ([LASSection.curve]).
  void parseCurveLine(LasLine lasLine, LasData las) {
    final info = _parseInfo(lasLine);
    if (info == null) return;
    las.addCurveInfo(info);
  }

  /// Analysis for a well section line ([LASSection.parameter]).
  void parseParameterLine(LasLine lasLine, LasData las) {
    final info = _parseInfo(lasLine);
    if (info == null) return;
    las.addParameterInfo(info);
  }

  /// Analysis for a well section line ([LASSection.other]).
  void parseOtherLine(LasLine lasLine, LasData las) {}

  /// Analysis for a well section line ([LASSection.data]).
  void _parseDataLine(LasLine lasLine, LasData las) {
    if (lasLine.isSectionLine()) {
      return;
    }
    final line = lasLine.line.trim();
    if (line.isEmpty) return;
    final values = line.split(RegExp(r' +'));
    final result = values.map((s) => double.tryParse(s)).toList();
    for (var i = 0; i < result.length; i++) {
      final v = result[i];
      final curve = las.getCurve(i);
      curve.addValue(v);
    }
  }

  /// Utility parse function: creates a [LasInfo] object based on a line.
  LasInfo? _parseInfo(LasLine lasLine) {
    if (lasLine.isSectionLine()) {
      return null;
    }
    final line = lasLine.line;
    final regexp = RegExp(r'^[ \t]*(.+?)[ \t]*\.(.*?)[ \t]+(.*?)[ \t]*:[ \t]*(.*)$');
    final match = regexp.firstMatch(line);
    if (match == null) throw 'Bad formatted line: $lasLine';
    final mnemonic = match.group(1)!.trim();
    final unit = match.group(2)!.trim();
    final value = match.group(3)!.trim();
    final description = match.group(4)!.trim();
    return LasInfo(mnemonic, unit, value, description);
  }
}
