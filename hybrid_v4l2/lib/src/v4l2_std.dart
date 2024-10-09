import 'v4l2_ffi.dart' as ffi;

/// Video devices typically support one or more different video standards or
/// variations of standards. Each video input and output may support another set
/// of standards. This set is reported by the std field of struct v4l2_input and
/// struct v4l2_output returned by the ioctl VIDIOC_ENUMINPUT and ioctl
/// VIDIOC_ENUMOUTPUT ioctls, respectively.
enum V4L2Std {
  palB(ffi.V4L2_STD_PAL_B),
  palB1(ffi.V4L2_STD_PAL_B1),
  palG(ffi.V4L2_STD_PAL_G),
  palH(ffi.V4L2_STD_PAL_H),
  palI(ffi.V4L2_STD_PAL_I),
  palD(ffi.V4L2_STD_PAL_D),
  palD1(ffi.V4L2_STD_PAL_D1),
  palK(ffi.V4L2_STD_PAL_K),
  palM(ffi.V4L2_STD_PAL_M),
  palN(ffi.V4L2_STD_PAL_N),
  palNc(ffi.V4L2_STD_PAL_Nc),
  pal60(ffi.V4L2_STD_PAL_60),
  ntscM(ffi.V4L2_STD_NTSC_M),
  ntscMJP(ffi.V4L2_STD_NTSC_M_JP),
  ntsc443(ffi.V4L2_STD_NTSC_443),
  ntscMKR(ffi.V4L2_STD_NTSC_M_KR),
  secamB(ffi.V4L2_STD_SECAM_B),
  secamD(ffi.V4L2_STD_SECAM_D),
  secamG(ffi.V4L2_STD_SECAM_G),
  secamH(ffi.V4L2_STD_SECAM_H),
  secamK(ffi.V4L2_STD_SECAM_K),
  secamK1(ffi.V4L2_STD_SECAM_K1),
  secamL(ffi.V4L2_STD_SECAM_L),
  secamLC(ffi.V4L2_STD_SECAM_LC),
  atsc8VSB(ffi.V4L2_STD_ATSC_8_VSB),
  atsc16VSB(ffi.V4L2_STD_ATSC_16_VSB),
  ntsc(ffi.V4L2_STD_NTSC),
  secamDK(ffi.V4L2_STD_SECAM_DK),
  secam(ffi.V4L2_STD_SECAM),
  palBG(ffi.V4L2_STD_PAL_BG),
  palDK(ffi.V4L2_STD_PAL_DK),
  pal(ffi.V4L2_STD_PAL),
  b(ffi.V4L2_STD_B),
  g(ffi.V4L2_STD_G),
  h(ffi.V4L2_STD_H),
  l(ffi.V4L2_STD_L),
  gh(ffi.V4L2_STD_GH),
  dk(ffi.V4L2_STD_DK),
  bg(ffi.V4L2_STD_BG),
  mn(ffi.V4L2_STD_MN),
  mts(ffi.V4L2_STD_MTS),
  std525_60(ffi.V4L2_STD_525_60),
  std625_50(ffi.V4L2_STD_625_50),
  atsc(ffi.V4L2_STD_ATSC),
  unknown(ffi.V4L2_STD_UNKNOWN),
  all(ffi.V4L2_STD_ALL);

  final int value;

  const V4L2Std(this.value);
}
