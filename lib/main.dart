import 'dart:convert';
import 'dart:io';

import 'package:las/las.dart';

void main() {
  final file = File('test/data/4771-36-SESE.las');
  final stream = file.openRead().transform(utf8.decoder).transform(const LineSplitter());
  final reader = LASReader();
  final lasData$ = reader.readStream(stream);
  lasData$.then((lasData) {
    final nc = lasData.numberOfParameters;
    print('R: $nc');
  });
}
