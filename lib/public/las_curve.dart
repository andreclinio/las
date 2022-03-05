class LasCurve {
  /// Mnemônico que identifica a curva.
  final String mnemonic;

  /// Unidade da curva.
  final String? unit;

  /// API code. */
  final String? apiCode;

  /// Descrição da curva.
  final String? description;

  /// Dados da curva.
  final List<double?> values = [];

  LasCurve(this.mnemonic, this.unit, this.apiCode, this.description);

  void addValue(double? value) {
    values.add(value);
  }
}
