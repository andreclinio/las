class LasCurve {
  /// Mnemonic
  final String mnemonic;

  /// Unit
  final String? unit;

  /// API code.
  final String? apiCode;

  /// Description
  final String? description;

  /// Numeric values
  final List<double> values = [];

  /// Constructor
  LasCurve(this.mnemonic, this.unit, this.apiCode, this.description);

  /// Add value (when reading)
  void addValue(double value) {
    values.add(value);
  }
}
