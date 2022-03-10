import 'dart:io';

import 'package:las/las.dart';
import 'package:test/test.dart';

///
void main() {
  File _getFile(String fileName) {
    final file = File('test/assets/data/other/$fileName');
    return file;
  }

  test('reads basic data for file [ashec1.las]', () async {
    final reader = LasReader();
    final file = _getFile('ashec1.las');
    final lasData = await reader.readFile(file);
    expect(lasData.version, '2.0');
    expect(lasData.wrap, true);
    expect(lasData.nullValue, -99999);
    expect(lasData.getWellInfo('NULL')!.unit, '');

    final depth = lasData.getCurve('DEPTH');
    expect(depth == null, false);
    expect(depth!.values.first, 4578.0);
    expect(depth.values.last, 5960.0);
    expect(depth.unit!.toLowerCase(), 'ft');

    final rild = lasData.getCurve('RILD');
    expect(rild == null, false);
    expect(rild!.values.first, 5.475);
    expect(rild.values.last, 50.111);
    expect(rild.unit!.toLowerCase(), 'ohmm');

    final sp = lasData.getCurve('SP');
    expect(sp == null, false);
    expect(sp!.values.first.isNaN, true);
    expect(sp.values.last.isNaN, true);
    expect(sp.unit!.toLowerCase(), 'mv');
  });

  test('reads basic data for file [by18d.las]', () async {
    final reader = LasReader();
    final file = _getFile('by18d.las');
    final lasData = await reader.readFile(file);
    expect(lasData.version, '2.0');
    expect(lasData.wrap, true);
    expect(lasData.nullValue, -99999);
    expect(lasData.getWellInfo('NULL')!.unit, '');

    final depth = lasData.getCurve('DEPTH');
    expect(depth == null, false);
    expect(depth!.values.first, 4700);
    expect(depth.values.last, 5740.0, reason: 'last depth of by is 5740!');
    expect(depth.unit!.toLowerCase(), 'ft');

    final gr = lasData.getCurve('GR');
    expect(gr == null, false);
    expect(gr!.values.first, 118.214073);
    expect(gr.values.last.isNaN, true);
    expect(gr.unit!.toLowerCase(), 'api');

    final sp = lasData.getCurve('SP');
    expect(sp == null, false);
    expect(sp!.values.first, -19.789886);
    expect(sp.values.last.isNaN, true);
    expect(sp.unit!.toLowerCase(), 'mv');
  });
}
