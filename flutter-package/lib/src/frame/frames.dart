import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:preview/preview.dart';

import 'frame.dart';

class Frames {
  static final smallAndroidPhone = _smallPhone;
  static final mediumAndroidPhone = _mediumPhone;
  static final largeAndroidPhone = _largePhone;
  static final smallAndroidTablet = _smallTablet;
  static final mediumAndroidTablet = _mediumTablet;
  static final largeAndroidTablet = _largeTablet;

  static final iphoneXR = _iphoneXr;
  static final iphoneX = _iphoneX;
  static final iphoneXs = _iphoneXs;
  static final iphoneXsMax = _iphoneXsMax;
  static final iphone5 = _iphone5;
  static final iphone8 = _iphone8;
  static final ipadAir2 = _iPadAir2;
  static final ipadPro12 = _iPadPro12;

  static final androidAuto = _androidAutomotiveFrame;
  static final androidRoundWatch = _androidRoundWatchFrame;

  static final appleWatch5_40mm = _appleWatch5_40mmFrame;
  static final appleWatch5_44mm = _appleWatch5_44mmFrame;

  static final surfacePro7 = _surfacePro7Frame;
  static final macbookPro13 = _macbookPro13Frame;
  static final macbookPro15 = _macbookPro15Frame;

  static FrameData customLaptop(
      {FrameAspectRatio ratio = FrameAspectRatio.r_16_9,
      double inches = 13.0,
      double density = 1}) {
    final width = inches * 96 / density;
    final height = ratio.calculateFor(width);

    return FrameData(
      size: Size(width, height),
      orientation: Orientation.landscape,
      pixelRatio: density,
      platform: TargetPlatform.windows,
      bodyPadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      edgeRadius: BorderRadius.all(Radius.circular(20)),
      screenRadius: BorderRadius.all(Radius.circular(0)),
    );
  }

  static final values = [
    smallAndroidPhone,
    mediumAndroidPhone,
    largeAndroidPhone,
    smallAndroidTablet,
    mediumAndroidTablet,
    largeAndroidTablet,
    iphoneXR,
    iphoneX,
    iphoneXs,
    iphoneXsMax,
    iphone5,
    iphone8,
    ipadAir2,
    ipadPro12,
    androidAuto,
    androidRoundWatch,
    appleWatch5_40mm,
    appleWatch5_44mm,
    surfacePro7,
    macbookPro13,
    macbookPro15
  ];
}

final _iphoneX = _cupertinoWithNotchFrame.copyWith(
  size: const Size(375, 812),
  pixelRatio: 3.0,
  portraitSafeArea: const EdgeInsets.only(top: 44, bottom: 34),
  landscapeSafeArea: const EdgeInsets.only(left: 44, right: 44, bottom: 21),
);

final _iphoneXs = _cupertinoWithNotchFrame.copyWith(
  size: const Size(375, 812),
  pixelRatio: 3.0,
  portraitSafeArea: const EdgeInsets.only(top: 44, bottom: 34),
  landscapeSafeArea: const EdgeInsets.only(left: 44, right: 44, bottom: 21),
);
final _iphoneXsMax = _cupertinoWithNotchFrame.copyWith(
  size: const Size(375, 812),
  pixelRatio: 3.0,
  portraitSafeArea: const EdgeInsets.only(top: 44, bottom: 34),
  landscapeSafeArea: const EdgeInsets.only(left: 44, right: 44, bottom: 21),
);

final _iphoneXr = _cupertinoWithNotchFrame.copyWith(
  size: const Size(414, 896),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(top: 44, bottom: 34),
  landscapeSafeArea: const EdgeInsets.only(left: 44, right: 44, bottom: 21),
);

final _iphone5 = _cupertinoWithoutNotchFrame.copyWith(
  size: const Size(320, 568),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);
final _iphone8 = _cupertinoWithoutNotchFrame.copyWith(
  size: const Size(375, 667),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

final _iPadAir2 = _cupertinoTabletFrame.copyWith(
  size: const Size(768, 1024),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

final _iPadPro12 = _cupertinoTabletWithThinBordersFrame.copyWith(
  size: const Size(1024, 1336),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

const _cupertinoWithNotchFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: const EdgeInsets.only(top: 18, right: 18, left: 18, bottom: 18),
  edgeRadius: BorderRadius.all(Radius.circular(56)),
  screenRadius: BorderRadius.all(Radius.circular(38)),
  sideButtons: [
    const DeviceSideButton.left(fromTop: 116, size: 35, thickness: 6),
    DeviceSideButton.left(fromTop: 176, size: 60, thickness: 6),
    DeviceSideButton.left(fromTop: 240, size: 60, thickness: 6),
    DeviceSideButton.right(fromTop: 176, size: 90, thickness: 6),
  ],
  notch: DeviceNotch(
    width: 210,
    height: 28,
    joinRadius: Radius.circular(12),
    radius: Radius.circular(24),
  ),
);

const _cupertinoWithoutNotchFrame = FrameData(
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
    DeviceSideButton.left(fromTop: 96, size: 35, thickness: 6),
    DeviceSideButton.left(fromTop: 156, size: 60, thickness: 6),
    DeviceSideButton.left(fromTop: 220, size: 60, thickness: 6),
    DeviceSideButton.right(fromTop: 156, size: 60, thickness: 6),
  ],
);

const _cupertinoTabletWithThinBordersFrame = FrameData(
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
    DeviceSideButton.right(fromTop: 96, size: 42, thickness: 6),
    DeviceSideButton.right(fromTop: 146, size: 42, thickness: 6),
  ],
);

const _cupertinoTabletFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: const EdgeInsets.only(top: 96, right: 18, left: 18, bottom: 96),
  edgeRadius: BorderRadius.all(Radius.circular(56)),
  screenRadius: BorderRadius.all(Radius.circular(2)),
  sideButtons: [
    DeviceSideButton.left(fromTop: 96, size: 35, thickness: 6),
    DeviceSideButton.left(fromTop: 156, size: 60, thickness: 6),
    DeviceSideButton.left(fromTop: 220, size: 60, thickness: 6),
    DeviceSideButton.right(fromTop: 156, size: 60, thickness: 6),
  ],
);

const _appleWatch5_40mmFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: EdgeInsets.all(12),
  edgeRadius: BorderRadius.all(Radius.circular(42)),
  screenRadius: BorderRadius.all(Radius.circular(32)),
  size: Size(162, 197),
  pixelRatio: 2,
  sideButtons: [
    DeviceSideButton.right(fromTop: 40, size: 40, thickness: 12),
  ],
);

const _appleWatch5_44mmFrame = FrameData(
  platform: TargetPlatform.iOS,
  bodyPadding: EdgeInsets.all(12),
  edgeRadius: BorderRadius.all(Radius.circular(42)),
  screenRadius: BorderRadius.all(Radius.circular(32)),
  size: Size(184, 224),
  pixelRatio: 2,
  sideButtons: [
    DeviceSideButton.right(fromTop: 42, size: 40, thickness: 12),
  ],
);

//
//  ANDROID PHONES
//
//

final _smallPhone = _androidPhoneFrame.copyWith(
  size: const Size(320, 569),
  pixelRatio: 1.5,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

final _mediumPhone = _androidPhoneFrame.copyWith(
  size: const Size(360, 740),
  pixelRatio: 4.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

final _largePhone = _androidPhoneFrame.copyWith(
  size: const Size(480, 853),
  pixelRatio: 3.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

final _smallTablet = _androidTabletFrame.copyWith(
  size: const Size(600, 960),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

final _mediumTablet = _androidTabletFrame.copyWith(
  size: const Size(800, 1280),
  pixelRatio: 2.0,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

final _largeTablet = _androidTabletFrame.copyWith(
  size: const Size(320, 569),
  pixelRatio: 1.5,
  portraitSafeArea: const EdgeInsets.only(top: 20),
);

const _androidPhoneFrame = FrameData(
  platform: TargetPlatform.android,
  bodyPadding: EdgeInsets.only(
    top: 64,
    right: 8,
    left: 8,
    bottom: 38,
  ),
  edgeRadius: BorderRadius.all(Radius.circular(56)),
  screenRadius: BorderRadius.all(Radius.circular(24)),
  sideButtons: [
    DeviceSideButton.right(
      fromTop: 156,
      size: 60,
      thickness: 3,
    ),
    DeviceSideButton.right(
      fromTop: 236,
      size: 100,
      thickness: 3,
    ),
  ],
);

const _androidRoundWatchFrame = FrameData(
  platform: TargetPlatform.android,
  bodyPadding: EdgeInsets.all(
    20,
  ),
  edgeRadius: BorderRadius.all(Radius.circular((187.5 + 42 * 2) / 2)),
  screenRadius: BorderRadius.all(Radius.circular((187.5) / 2)),
  size: Size(187.5, 187.5),
  pixelRatio: 2,
);

const _androidTabletFrame = FrameData(
  platform: TargetPlatform.android,
  bodyPadding: EdgeInsets.only(
    top: 32,
    right: 12,
    left: 12,
    bottom: 48,
  ),
  edgeRadius: BorderRadius.all(Radius.circular(32)),
  screenRadius: BorderRadius.all(Radius.circular(16)),
  sideButtons: [
    DeviceSideButton.right(
      fromTop: 156,
      size: 60,
      thickness: 3,
    ),
    DeviceSideButton.right(
      fromTop: 236,
      size: 100,
      thickness: 3,
    ),
  ],
);

const _androidAutomotiveFrame = FrameData(
  size: const Size(768, 1024),
  orientation: Orientation.landscape,
  pixelRatio: 1,
  portraitSafeArea: const EdgeInsets.only(top: 20, bottom: 20),
  landscapeSafeArea: const EdgeInsets.only(top: 20, bottom: 20),
  platform: TargetPlatform.android,
  bodyPadding: EdgeInsets.only(
    top: 20,
    right: 20,
    left: 20,
    bottom: 20,
  ),
  edgeRadius: BorderRadius.all(Radius.circular(32)),
  screenRadius: BorderRadius.all(Radius.circular(16)),
);

const _surfacePro7Frame = FrameData(
  size: const Size(608, 912),
  orientation: Orientation.landscape,
  pixelRatio: 3,
  platform: TargetPlatform.android,
  bodyPadding: EdgeInsets.all(32),
  edgeRadius: BorderRadius.all(Radius.circular(12)),
  screenRadius: BorderRadius.all(Radius.circular(8)),
);

const _macbookPro13Frame = FrameData(
  size: const Size(800, 1280),
  orientation: Orientation.landscape,
  pixelRatio: 2,
  platform: TargetPlatform.android,
  bodyPadding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
  edgeRadius: BorderRadius.all(Radius.circular(20)),
  screenRadius: BorderRadius.all(Radius.circular(0)),
);

const _macbookPro15Frame = FrameData(
  size: const Size(900, 1440),
  orientation: Orientation.landscape,
  pixelRatio: 2,
  platform: TargetPlatform.android,
  bodyPadding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
  edgeRadius: BorderRadius.all(Radius.circular(20)),
  screenRadius: BorderRadius.all(Radius.circular(0)),
);

enum FrameAspectRatio { r_16_9, r_3_2, r_4_3 }

extension on FrameAspectRatio {
  double calculateFor(double value) {
    switch (this) {
      case FrameAspectRatio.r_16_9:
        return value * 16 / 9;
      case FrameAspectRatio.r_3_2:
        return value * 1.5;
      case FrameAspectRatio.r_4_3:
        return value * 4 / 3;
    }
    return null;
  }
}
