part of 'package:splayer/src/splayer.dart';

class _VideoGestureDetector extends StatelessWidget {
  final Widget? child;
  final void Function()? onDoubleTap;
  final void Function()? onTap;
  final String tag;

  const _VideoGestureDetector({
    required this.tag,
    this.child,
    this.onDoubleTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return MouseRegion(
      onHover: (event) => podCtr.onOverlayHover(),
      onExit: (event) => podCtr.onOverlayHoverExit(),
      child: GestureDetector(
        onTap: onTap ?? podCtr.toggleVideoOverlay,
        onDoubleTap: onDoubleTap,
        child: child,
      ),
    );
  }
}
