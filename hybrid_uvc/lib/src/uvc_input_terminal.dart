import 'uvc_input_terminal_type.dart';

abstract interface class UVCInputTerminal {
  int get id;
  UVCInputTerminalType get type;
  int get minimumObjectiveFocalLength;
  int get maximumObjectiveFocalLength;
  int get ocularFocalLength;
  int get controls;
}
