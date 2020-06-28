import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:preview/frame/frame.dart';

class Frames {
  static final iphoneXR = _iphoneXr;
  static final iphoneX = _iphoneX;
  static final iphoneXs = _iphoneXs;
  static final iphoneXsMax = _iphoneXsMax;
  static final iphone5 = _iphone5;
  static final iphone8 = _iphone8;
  static final ipadAir2 = _iPadAir2;
  static final ipadPro12 = _iPadPro12;
}

FrameData _iphoneX = _cupertinoWithNotchFrame.copyWith(
  size: const Size(375, 812),
  pixelRatio: 3.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 44,
    bottom: 34,
  ),
  landscapeSafeArea: const EdgeInsets.only(
    left: 44,
    right: 44,
    bottom: 21,
  ),
);

FrameData _iphoneXs = _cupertinoWithNotchFrame.copyWith(
  size: const Size(375, 812),
  pixelRatio: 3.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 44,
    bottom: 34,
  ),
  landscapeSafeArea: const EdgeInsets.only(
    left: 44,
    right: 44,
    bottom: 21,
  ),
);
FrameData _iphoneXsMax = _cupertinoWithNotchFrame.copyWith(
  size: const Size(375, 812),
  pixelRatio: 3.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 44,
    bottom: 34,
  ),
  landscapeSafeArea: const EdgeInsets.only(
    left: 44,
    right: 44,
    bottom: 21,
  ),
);

FrameData _iphoneXr = _cupertinoWithNotchFrame.copyWith(
  size: const Size(414, 896),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 44,
    bottom: 34,
  ),
  landscapeSafeArea: const EdgeInsets.only(
    left: 44,
    right: 44,
    bottom: 21,
  ),
);

FrameData _iphone5 = _cupertinoWithoutNotchFrame.copyWith(
  size: const Size(320, 568),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 20,
  ),
);
FrameData _iphone8 = _cupertinoWithoutNotchFrame.copyWith(
  size: const Size(375, 667),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 20,
  ),
);

FrameData _iPadAir2 = _cupertinoWithoutNotchFrame.copyWith(
  size: const Size(768, 1024),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 20,
  ),
);

FrameData _iPadPro12 = _cupertinoWithoutNotchFrame.copyWith(
  size: const Size(1024, 1336),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(
    top: 20,
  ),
);

FrameData _cupertinoWithNotchFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: const EdgeInsets.only(
    top: 18,
    right: 18,
    left: 18,
    bottom: 18,
  ),
  edgeRadius: BorderRadius.all(Radius.circular(56)),
  screenRadius: BorderRadius.all(Radius.circular(38)),
  sideButtons: [
    const DeviceSideButton.left(
      fromTop: 116,
      size: 35,
      thickness: 6,
    ),
    DeviceSideButton.left(
      fromTop: 176,
      size: 60,
      thickness: 6,
    ),
    DeviceSideButton.left(
      fromTop: 240,
      size: 60,
      thickness: 6,
    ),
    DeviceSideButton.right(
      fromTop: 176,
      size: 90,
      thickness: 6,
    ),
  ],
  notch: DeviceNotch(
    width: 210,
    height: 28,
    joinRadius: Radius.circular(12),
    radius: Radius.circular(24),
  ),
);

FrameData _cupertinoWithoutNotchFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: const EdgeInsets.only(
    top: 96,
    right: 18,
    left: 18,
    bottom: 96,
  ),
  edgeRadius: BorderRadius.all(Radius.circular(56)),
  screenRadius: BorderRadius.all(Radius.circular(2)),
  sideButtons: [
    DeviceSideButton.left(
      fromTop: 96,
      size: 35,
      thickness: 6,
    ),
    DeviceSideButton.left(
      fromTop: 156,
      size: 60,
      thickness: 6,
    ),
    DeviceSideButton.left(
      fromTop: 220,
      size: 60,
      thickness: 6,
    ),
    DeviceSideButton.right(
      fromTop: 156,
      size: 60,
      thickness: 6,
    ),
  ],
);

FrameData _cupertinoTabletWithThinBordersFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: const EdgeInsets.only(
    top: 36,
    right: 36,
    left: 36,
    bottom: 36,
  ),
  edgeRadius: BorderRadius.all(Radius.circular(56)),
  screenRadius: BorderRadius.all(Radius.circular(16)),
  sideButtons: [
    DeviceSideButton.right(
      fromTop: 96,
      size: 42,
      thickness: 6,
    ),
    DeviceSideButton.right(
      fromTop: 146,
      size: 42,
      thickness: 6,
    ),
  ],
);

FrameData _cupertinoTabletFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: const EdgeInsets.only(
    top: 96,
    right: 18,
    left: 18,
    bottom: 96,
  ),
  edgeRadius: BorderRadius.all(Radius.circular(56)),
  screenRadius: BorderRadius.all(Radius.circular(2)),
  sideButtons: [
    DeviceSideButton.left(
      fromTop: 96,
      size: 35,
      thickness: 6,
    ),
    DeviceSideButton.left(
      fromTop: 156,
      size: 60,
      thickness: 6,
    ),
    DeviceSideButton.left(
      fromTop: 220,
      size: 60,
      thickness: 6,
    ),
    DeviceSideButton.right(
      fromTop: 156,
      size: 60,
      thickness: 6,
    ),
  ],
);
