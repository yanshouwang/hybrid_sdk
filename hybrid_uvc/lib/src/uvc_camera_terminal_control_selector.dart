enum UVCCameraTerminalControlSelector {
  undefinedControl(0x00),
  scanningModeControl(0x01),
  aeModeControl(0x02),
  aePriorityControl(0x04),
  exposureTimeAbsoluteControl(0x08),
  exposureTimeRelativeControl(0x10),
  focusAbsoluteControl(0x20),
  focusRelativeControl(0x40),
  focusAutoControl(0x80),
  irisAbsoluteControl(0x100),
  irisRelativeControl(0x200),
  zoomAbsoluteControl(0x400),
  zoomRelativeControl(0x800),
  pantiltAbsoluteControl(0x1000),
  pantiltRelativeControl(0x2000),
  rollAbsoluteControl(0x4000),
  rollRelativeControl(0x8000),
  privacyControl(0x10000),
  focusSimpleControl(0x20000),
  digitalWindowControl(0x40000),
  regionOfInterestControl(0x80000);

  final int value;

  const UVCCameraTerminalControlSelector(this.value);
}
