import 'dart:io';

import 'package:las/las.dart';
import 'package:test/test.dart';

/// Some download files from: https://minnelusa.com
void main() {

  File _getFile(String fileName) {
    final file = File('test/data/minnelusa/$fileName');
    return file;
  }

  test('reads basic data for file [4771-36-SESE.las]', () async {
    final reader = LasReader();
    final file = _getFile('4771-36-SESE.las');
    final lasData = await reader.readFile(file);
    expect(lasData.curves.length, 5);
    expect(lasData.wellInfos.length, 14);
    expect(lasData.parameters.length, 7);
  });

  test('reads depth values for file [4771-36-SESE.las]', () async {
    final reader = LasReader();
    final file = _getFile('4771-36-SESE.las');
    final lasData = await reader.readFile(file);
    final depth = lasData.getCurve('DEPT');
    expect(depth == null, false);
    expect(depth!.values.first, 10180.0);
    expect(depth.values.last,  10414.0);
    expect(depth.unit!.toLowerCase(), 'f');
  });

  test('reads some info for file [5070-14-SESW.las]', () async {
    final reader = LasReader();
    final file = _getFile('5070-14-SESW.las');
    final lasData = await reader.readFile(file);
    final depth = lasData.getCurve('DEPT');
    final bht = lasData.getParameter('BHT');
    expect(depth == null, false);
    expect(depth!.values.first, 8660.0);
    expect(depth.unit!.toLowerCase(), 'f');
    expect(bht == null, false);
    expect(bht!.unit!.toLowerCase(), 'degf');
    expect(double.tryParse(bht.value!), 168);
    expect(bht.description!, 'BOTTOM HOLE TEMPERATURE');
  });
}
