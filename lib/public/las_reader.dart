import 'dart:convert';
import 'dart:io';

import 'package:las/private/las_line.dart';
import 'package:las/private/las_section.dart';
import 'package:las/public/las_data.dart';
import 'package:las/public/las_info.dart';
import 'package:las/private/las_transformer.dart';

class LASReader {
  
  Future<LasData> readFile(File file) async {
    if (!file.existsSync()) throw 'File ${file.absolute} not found';
    final stream = file.openRead().transform(utf8.decoder).transform(const LineSplitter());
    return readStream(stream);
  }

  /// Faz a análise de um arquivo LAS e produz um objeto {@link LAS}.
  /// @param reader reader que representa o arquivo LAS.
  /// @param listener listener de progresso.
  /// @param numBytes dica para o número de bytes total da entrada.
  /// @return objeto {@link LAS} resultante da leitura.
  Future<LasData> readStream(Stream<String> lines) async {
    final las = LasData();
    final lasLines = LasTransformer().linesToLasLines(lines);
    await for(LasLine lasLine in lasLines) {
      switch (lasLine.section) {
        case LasSection.version:
          parseVersionLine(lasLine, las);
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
          parseDataLine(lasLine, las);
          break;
      }
    }
    return las;
  }

  /// Analisa as linhas da seção [LASSection.version].
  /// @param lasLine linha atual.
  /// @param las objeto resultante.
  void parseVersionLine(LasLine lasLine, LasData las) {
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

  /// Analisa as linhas da seção {@link LASSection#WELL}.
  ///
  /// @param line linha atual.
  /// @param las objeto resultante.
  ///
  /// @throws LASSyntaxErrorException quando há erro de sintaxe na linha.
  void parseWellLine(LasLine lasLine, LasData las) {
    final info = _parseInfo(lasLine);
    if (info == null) return;
    las.addWellInfo(info);
  }

  /// Analisa as linhas da seção {@link LASSection#CURVE}.
  ///
  /// @param line linha atual.
  /// @param las objeto resultante.
  ///
  /// @throws LASSyntaxErrorException quando há erro de sintaxe na linha.
  void parseCurveLine(LasLine lasLine, LasData las) {
    final info = _parseInfo(lasLine);
    if (info == null) return;
    las.addCurveInfo(info);
  }

  /// Analisa as linhas da seção {@link LASSection#PARAMETER}.
  ///
  /// @param line linha atual.
  /// @param las objeto resultante.
  ///
  /// @throws LASSyntaxErrorException quando há erro de sintaxe na linha.
  void parseParameterLine(LasLine lasLine, LasData las) {
    final info = _parseInfo(lasLine);
    if (info == null) return;
    las.addParameterInfo(info);
  }

  /// Analisa as linhas da seção {@link LASSection#OTHER}.
  ///
  /// @param line linha atual.
  /// @param las objeto resultante.
  void parseOtherLine(LasLine lasLine, LasData las) {}

  /// Analisa as linhas da seção {@link LASSection#DATA}.
  ///
  /// NOTA: Para simplificar o parser, armazenamos temporariamente os dados na na
  /// estrutura {@link LASDataHolder} e depois atribuimos ao objeto {@link LAS}
  /// resultante.
  ///
  /// @param line linha atual.
  /// @param las objeto resultante.
  /// @param dataHolder estrutura que auxilia o armazenamento dos dados as suas
  ///        respectivas curvas.
  ///
  /// @throws LASSyntaxErrorException quando há erro de sintaxe na linha.
  void parseDataLine(LasLine lasLine, LasData las) {
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
