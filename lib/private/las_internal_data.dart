import 'package:las/public/las_info.dart';

import '../public/las_curve.dart';

/// Resulting class after a input stream is read.
class LasInternalData {
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

  int _curveIndex = 0;

  void setVersion(String version) => this.version = version;
  void setVersionDescription(String versionDescription) => this.versionDescription = versionDescription;
  void setWrap(bool wrap) => this.wrap = wrap;

  void addWellInfo(LasInfo info) => _wellInfo.add(info);
  void addCurveInfo(LasInfo info) => _curveInfo.add(info);
  void addParameterInfo(LasInfo info) => _parameterInfo.add(info);

  void createCurvesIfNeeded() {
    if (_lasCurves.isNotEmpty) return;
    _curveInfo.forEach((ci) { 
      final mn = ci.mnemonic;
      final un = ci.unit;
      final ap = ci.value;
      final ds = ci.description;
      final curve = LasCurve(mn, un, ap, ds);
      _lasCurves.add(curve);
    });
  }

  LasCurve findOrCreateCurve() {
    return _lasCurves[_curveIndex];
  }

  void curveIndexInc() {
    _curveIndex = _curveIndex + 1;
    if (_curveIndex >= curves.length) _curveIndex = 0;
  }

  LasCurve? getCurve(String curveName) {
    final found = _lasCurves.where((lc) => lc.mnemonic == curveName);
    return found.isEmpty ? null : found.first;
  }

  LasInfo? getParameter(String paramaterName) {
    final found = parameters.where((lc) => lc.mnemonic == paramaterName);
    return found.isEmpty ? null : found.first;
  }

  LasInfo? getWellInfo(String infoName) {
    final found = wellInfos.where((lc) => lc.mnemonic == infoName);
    return found.isEmpty ? null : found.first;
  }

  double? get nullValue {
    final info = getWellInfo('NULL');
    if (info == null || info.value == null) return null;
    return double.tryParse(info.value!);
  }

  Iterable<LasCurve> get curves => _lasCurves;
  Iterable<LasInfo> get wellInfos => _wellInfo;
  Iterable<LasInfo> get parameters => _parameterInfo;


}
