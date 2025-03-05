import 'package:flutter/material.dart';
import 'package:splayer/src/controllers/pod_getx_video_controller.dart';

import '../cupertino/cupertino_controls.dart';

class AdaptiveControls extends StatelessWidget {
  final String tag;
  final bool tap;
  final PodGetXVideoController podCtr;
  const AdaptiveControls({

    super.key,
    required this.tag,
    required this.tap,
    required this.podCtr,

  });

  @override
  Widget build(BuildContext context) {

    return CupertinoControls(
      podGetXVideoController: podCtr,
      tap: tap,

      playColor: Colors.red,
        backgroundColor:const Color.fromRGBO(41, 41, 41, 0.5),
        iconColor: Colors.white, tag: tag,//fromARGB(255, 200, 200, 200),
      );
    // switch (Theme.of(context).platform) {
    //   case TargetPlatform.android:
    //   case TargetPlatform.fuchsia:
    //
    // return
    //   CupertinoControls(
    //     backgroundColor:Color.fromRGBO(41, 41, 41, 0.5),
    //     iconColor: Colors.white,//fromARGB(255, 200, 200, 200),
    //   );
    //   //  return
    //   //    const MaterialControls();
    //
    //   case TargetPlatform.macOS:
    //   case TargetPlatform.windows:
    //   case TargetPlatform.linux:
    //     return const MaterialDesktopControls();
    //
    //   case TargetPlatform.iOS:
    //     return const CupertinoControls(
    //       backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
    //       iconColor: Color.fromARGB(255, 200, 200, 200),
    //     );
    //   default:
    //     return const MaterialControls();
    // }
  }
}
