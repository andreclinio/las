import 'package:las/private/las_internal_data.dart';
import 'package:las/public/las_curve.dart';
import 'package:las/public/las_info.dart';

class LasData {
  final LasInternalData _lasInternalData;

  LasData(this._lasInternalData);

  LasCurve? getCurve(String curveName) {
    return _lasInternalData.getCurve(curveName);
  }

  LasInfo? getParameter(String parameterName) {
    return _lasInternalData.getParameter(parameterName);
  }

  LasInfo? getWellInfo(String infoName) {
    return _lasInternalData.getWellInfo(infoName);
  }

  String? get version => _lasInternalData.version;
  bool? get wrap => _lasInternalData.wrap;
  
  double? get nullValue {
    return _lasInternalData.nullValue;
  }

  Iterable<LasCurve> get curves => _lasInternalData.curves;
  Iterable<LasInfo> get parameters => _lasInternalData.parameters;
  Iterable<LasInfo> get wellInfos => _lasInternalData.wellInfos;
}
