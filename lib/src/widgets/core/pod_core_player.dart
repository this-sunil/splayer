part of 'package:splayer/src/splayer.dart';


class _PodCoreVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerCtr;
  final double videoAspectRatio;
  final String tag;




  const _PodCoreVideoPlayer({
    required this.videoPlayerCtr,
    required this.videoAspectRatio,
    required this.tag,

  });


  @override
  State<_PodCoreVideoPlayer> createState() => _PodCoreVideoPlayerState();
}

class _PodCoreVideoPlayerState extends State<_PodCoreVideoPlayer> {
  VideoPlayerController get videoPlayerCtr=>widget.videoPlayerCtr;
  double get videoAspectRatio=>widget.videoAspectRatio;
  String get tag=>widget.tag;

  late PlayerNotifier notifier;
 /* void setBrightness(double value) {
    // Implement logic to adjust brightness on your platform (Android/iOS)
    ScreenBrightness().setScreenBrightness(value);
    print('Brightness set to $value');
  }*/

 /* void setVolume(double value) {
    // Implement logic to adjust volume on your platform (Android/iOS)

    print('Volume set to $value');
  }
  void _handleHorizontalDrag(DragUpdateDetails details) {
    final mediaQuery = MediaQuery.of(context);
    final dragWidth = mediaQuery.size.width;
    final dragPos = details.localPosition.dx;

    // Adjust brightness (left side of the screen)
    if (dragPos < dragWidth / 3) {
      _brightness += details.delta.dx / dragWidth;
      _brightness = _brightness.clamp(0.0, 1.0);
      setBrightness(_brightness);
    }

    // Adjust volume (right side of the screen)
    if (dragPos > 2 * dragWidth / 3) {
      _volume += details.delta.dx / dragWidth;
      _volume = _volume.clamp(0.0, 1.0);
      setVolume(_volume);
    }
  }*/

  TransformationController transformationController=TransformationController();

  @override
  void initState() {

    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final podCtr = Get.find<PodGetXVideoController>(tag: tag);
    print("PodController =>${podCtr.videoCtr!.value.isPlaying}");
    return Builder(
      builder: (ctrx) {

        return RawKeyboardListener(
          autofocus: true,
          focusNode:
          (podCtr.isFullScreen ? FocusNode() : podCtr.keyboardFocusWeb) ??
              FocusNode(),
          onKey: (value) => podCtr.onKeyBoardEvents(
            event: value,
            appContext: ctrx,
            tag: tag,
          ),
         child: Flexi(
           tag: tag,


             controller:FlexiController(
               transformationController: transformationController,
                 maxScale: 100,
                 zoomAndPan: true,

                 looping: podCtr.podPlayerConfig.isLooping,
                 autoPlay: podCtr.podPlayerConfig.autoPlay,
                 isLive:podCtr.podPlayerConfig.isLive,
                 autoInitialize: true,


                 showControlsOnInitialize: true,
                 placeholder: const Text("Test",style:TextStyle(color: Colors.white)),

                 customControls: Stack(
                   fit: StackFit.loose,
                   children: [
                     CupertinoControls(tag: tag,backgroundColor: Colors.black, iconColor: Colors.white, playColor: Colors.red),
                     /*  Align(
                       alignment: Alignment.topRight,
                       child:IconButton(onPressed: (){
                         showModalBottomSheet<void>(
                           context: context,
                           builder: (context) => SafeArea(child: _MobileBottomSheet(tag: tag)),
                         );
                       }, icon: const Icon(BootstrapIcons.gear,color: Colors.white))

                   ),*/
                   ],
                 ),
                 /*additionalOptions: Align(
               alignment: Alignment.topRight,
               child:IconButton(onPressed: (){
                 showModalBottomSheet<void>(
                   context: context,
                   builder: (context) => SafeArea(child: _MobileBottomSheet(tag: tag)),
                 );
               }, icon: const Icon(BootstrapIcons.gear,color: Colors.white))

           ),*/

                 aspectRatio: 16/9,
                 isBrignessOptionDisplay: true,
                 isVolumnOptionDisplay: true,
                 hideControlsTimer: const Duration(seconds: 3),
                 videoPlayerController: videoPlayerCtr)),
         /* child: GestureDetector(
            behavior: HitTestBehavior.opaque,

            *//*  onHorizontalDragUpdate: _handleHorizontalDrag,*//*
              child:Stack(
            fit: StackFit.expand,
            children: [


              InteractiveViewer(
                  scaleEnabled: true,
                  maxScale: 100.0,
                  child:FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: 500,
                        width: MediaQuery.sizeOf(context).width,
                        child: VideoPlayer(videoPlayerCtr),
                      ))
              ),




              GetBuilder<PodGetXVideoController>(
                tag: tag,
                id: 'podVideoState',
                builder: (_) => GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'video-progress',
                  builder: (podCtr) {
                    if (podCtr.videoThumbnail == null) {
                      return const SizedBox();
                    }

                    if (podCtr.podVideoState == PodVideoState.paused &&
                        podCtr.videoPosition == Duration.zero) {
                      return SizedBox.expand(
                        child: TweenAnimationBuilder<double>(
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          tween: Tween<double>(begin: 0.7, end: 1),
                          duration: const Duration(milliseconds: 400),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: podCtr.videoThumbnail,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              _VideoOverlays(tag: tag),
              IgnorePointer(
                child: GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'podVideoState',
                  builder: (podCtr) {
                    final loadingWidget = podCtr.onLoading?.call(context) ??
                        const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );

                    if (kIsWeb) {
                      switch (podCtr.podVideoState) {
                        case PodVideoState.loading:
                          return loadingWidget;
                        case PodVideoState.paused:
                          return const Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          );
                        case PodVideoState.playing:
                          return Center(
                            child: TweenAnimationBuilder<double>(
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              tween: Tween<double>(begin: 1, end: 0),
                              duration: const Duration(seconds: 1),
                              child: const Icon(
                                Icons.pause,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          );
                        case PodVideoState.error:
                          return const SizedBox();
                      }
                    } else {
                      if (podCtr.podVideoState == PodVideoState.loading) {
                        return loadingWidget;
                      }
                      return const SizedBox();
                    }
                  },
                ),
              ),
              if (!kIsWeb)
                GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'full-screen',
                  builder: (podCtr) => podCtr.isFullScreen
                      ? const SizedBox()
                      : GetBuilder<PodGetXVideoController>(
                    tag: tag,
                    id: 'overlay',
                    builder: (podCtr) => podCtr.isOverlayVisible ||
                        !podCtr.alwaysShowProgressBar
                        ? const SizedBox()
                        : Align(
                      alignment: Alignment.bottomCenter,
                      child: PodProgressBar(
                        tag: tag,
                        alignment: Alignment.bottomCenter,
                        podProgressBarConfig:
                        podCtr.podProgressBarConfig,
                      ),
                    ),
                  ),
                ),

            ],
          )),*/
        );
      },
    );
  }
}
