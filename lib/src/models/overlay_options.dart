import '../../splayer.dart';

class OverLayOptions {
  final PodVideoState podVideoState;
  final Duration videoDuration;
  final Duration videoPosition;
  final bool isFullScreen;
  final bool isLooping;
  final bool isOverlayVisible;
  final bool isMute;
  final bool autoPlay;
  final String currentVideoPlaybackSpeed;
  final List<String> videoPlayBackSpeeds;
  final Function setVideoPlayBack;
  final Function setLoop;
  final List<VideoQalityUrls> vimeoOrVideoUrls;
  final PodVideoPlayerType videoPlayerType;
  final PodProgressBar podProgresssBar;
  OverLayOptions({
    required this.podVideoState,
    required this.videoDuration,
    required this.videoPosition,
    required this.isFullScreen,
    required this.isLooping,
    required this.isOverlayVisible,
    required this.isMute,
    required this.autoPlay,
    required this.currentVideoPlaybackSpeed,
    required this.setVideoPlayBack,
    required this.videoPlayBackSpeeds,
    required this.setLoop,
    required this.videoPlayerType,
    required this.vimeoOrVideoUrls,
    required this.podProgresssBar,
  });
}
