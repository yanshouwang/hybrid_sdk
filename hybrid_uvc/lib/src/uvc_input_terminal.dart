import 'uvc_input_terminal_type.dart';

class UVCInputTerminal {
  final int terminalId;
  final UVCInputTerminalType terminalType;
  final int minimumObjectiveFocalLength;
  final int maximumObjectiveFocalLength;
  final int ocularFocalLength;
  final int controls;

  UVCInputTerminal({
    required this.terminalId,
    required this.terminalType,
    required this.minimumObjectiveFocalLength,
    required this.maximumObjectiveFocalLength,
    required this.ocularFocalLength,
    required this.controls,
  });
}
