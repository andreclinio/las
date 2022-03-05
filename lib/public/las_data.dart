import 'package:las/public/las_info.dart';

import 'las_curve.dart';

/// Resulting class after a input stream is read.
class LasData {
  
  /// Tipical value read: version
  String? version;

  /// Tipical value read: version description
  String? versionDescription;

  /// Wrap value
  bool? wrap;

  final List<LasCurve> _lasCurves = [];

  final List<LasInfo> _wellInfo = [];
  final List<LasInfo> _curveInfo = [];
  final List<LasInfo> _parameterInfo = [];

  void setVersion(String version) => this.version = version;
  void setVersionDescription(String versionDescription) => this.versionDescription = versionDescription;
  void setWrap(bool wrap) => this.wrap = wrap;

  void addWellInfo(LasInfo info) => _wellInfo.add(info);
  void addCurveInfo(LasInfo info) => _curveInfo.add(info);
  void addParameterInfo(LasInfo info) => _parameterInfo.add(info);

  int get numberOfCurves => _curveInfo.length;
  int get numberOfWellInfo => _wellInfo.length;
  int get numberOfParameters => _parameterInfo.length;

  LasCurve getCurve(int index) {
    if (index >= _lasCurves.length) {
      final mn = _curveInfo[index].mnemonic;
      final un = _curveInfo[index].unit;
      final ap = _curveInfo[index].value;
      final ds = _curveInfo[index].description;
      final curve = LasCurve(mn, un, ap, ds);
      _lasCurves.add(curve);
    }
    return _lasCurves[index];
  }
}
