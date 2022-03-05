
import 'dart:io';

import 'package:las/las.dart';
import 'package:test/test.dart';

void main() {
  test('reads basic data for file [test/data/4771-36-SESE.las]', () async {
    final reader = LASReader();
    final file = File('test/data/4771-36-SESE.las');
    final lasData = await reader.readFile(file);
    expect(lasData.numberOfCurves, 5);
    expect(lasData.numberOfWellInfo, 14);
    expect(lasData.numberOfParameters, 7);
  });
}
