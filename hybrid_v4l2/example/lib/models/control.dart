class Control {
  final double minimum;
  final double maximum;
  final int divisions;
  final double value;

  Control({
    required this.minimum,
    required this.maximum,
    required this.divisions,
    required this.value,
  });

  Control copyWith({
    double? value,
  }) {
    return Control(
      minimum: minimum,
      maximum: maximum,
      divisions: divisions,
      value: value ?? this.value,
    );
  }
}
