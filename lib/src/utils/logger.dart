import 'dart:developer';


import '../sPlayer.dart';

void podLog(String message) =>
    PodVideoPlayer.enableLogs ? log(message, name: 'POD') : null;
