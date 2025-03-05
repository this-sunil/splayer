import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/vimeo_models.dart';

String podErrorString(String val) {
  return '*\n------error------\n\n$val\n\n------end------\n*';
}

class VideoApis {
  // Helper method to make the request with or without a hash for Vimeo videos
  static Future<Response> _makeRequestHash(String videoId, String? hash) {
    if (hash == null) {
      return http.get(
        Uri.parse('https://player.vimeo.com/video/$videoId/config'),
      );
    } else {
      return http.get(
        Uri.parse('https://player.vimeo.com/video/$videoId/config?h=$hash'),
      );
    }
  }

  // Get Vimeo video quality URLs (public videos)
  static Future<List<VideoQalityUrls>?> getVimeoVideoQualityUrls(
      String videoId,
      String? hash,
      ) async {
    try {
      final response = await _makeRequestHash(videoId, hash);
      final jsonData = jsonDecode(response.body)['request']['files'];
      final dashData = jsonData['dash'];
      final hlsData = jsonData['hls'];
      final defaultCDN = hlsData['default_cdn'];
      final cdnVideoUrl = (hlsData['cdns'][defaultCDN]['url'] as String?) ?? '';
      final List<dynamic> rawStreamUrls =
          (dashData['streams'] as List<dynamic>?) ?? <dynamic>[];

      final List<VideoQalityUrls> vimeoQualityUrls = [];

      for (final item in rawStreamUrls) {
        final qualityString = (item['quality'] as String?)?.split('p').first;
        if (qualityString != null && qualityString.isNotEmpty) {
          final quality = int.tryParse(qualityString) ?? 0;
          if (quality > 0) {
            final sepList = cdnVideoUrl.split('/sep/video/');
            final firstUrlPiece = sepList.firstOrNull ?? '';
            final lastUrlPiece = (sepList.lastOrNull ?? '').split('/').lastOrNull ?? '';
            final String urlId = ((item['id'] ?? '') as String).split('-').firstOrNull ?? '';
            vimeoQualityUrls.add(
              VideoQalityUrls(
                quality: quality,
                url: '$firstUrlPiece/sep/video/$urlId/$lastUrlPiece',
              ),
            );
          }
        }
      }

      // If no quality URLs are found, fallback to a default 720p URL
      if (vimeoQualityUrls.isEmpty) {
        vimeoQualityUrls.add(
          VideoQalityUrls(
            quality: 720,
            url: cdnVideoUrl,
          ),
        );
      }

      return vimeoQualityUrls;
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        log(
          podErrorString(
            '(INFO) To play Vimeo video in WEB, please enable CORS in your browser',
          ),
        );
      }
      debugPrint('===== VIMEO API ERROR: $error ==========');
      rethrow;
    }
  }

  // Get Vimeo video quality URLs (private videos)
  static Future<List<VideoQalityUrls>?> getVimeoPrivateVideoQualityUrls(
      String videoId,
      Map<String, String> httpHeader,
      ) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.vimeo.com/videos/$videoId'),
        headers: httpHeader,
      );
      final jsonData = (jsonDecode(response.body)['files'] as List<dynamic>?) ?? [];

      final List<VideoQalityUrls> list = [];
      for (int i = 0; i < jsonData.length; i++) {
        final String quality = (jsonData[i]['rendition'] as String?)?.split('p').first ?? '0';
        final int? number = int.tryParse(quality);
        if (number != null && number > 0) {
          list.add(
            VideoQalityUrls(
              quality: number,
              url: jsonData[i]['link'] as String,
            ),
          );
        }
      }

      return list;
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        log(
          podErrorString(
            '(INFO) To play Vimeo video in WEB, please enable CORS in your browser',
          ),
        );
      }
      debugPrint('===== VIMEO API ERROR: $error ==========');
      rethrow;
    }
  }

  // Get YouTube video quality URLs
  static Future<List<VideoQalityUrls>?> getYoutubeVideoQualityUrls(
      String youtubeIdOrUrl,
      bool live,
      ) async {
    try {
      final yt = YoutubeExplode();
      final urls = <VideoQalityUrls>[];

      if (live) {
        // Fetch live stream URL
        final url = await yt.videos.streamsClient.getHttpLiveStreamUrl(
          VideoId(youtubeIdOrUrl),
        );
        urls.add(
          VideoQalityUrls(
            quality: 360, // Default quality for live streams
            url: url,
          ),
        );
      } else {
        // Fetch non-live video streams
        final manifest = await yt.videos.streamsClient.getManifest(youtubeIdOrUrl,ytClients:
        [Platform.isAndroid?YoutubeApiClient.android:YoutubeApiClient.ios]);

        urls.addAll(
          manifest.muxed.map(
                (element) => VideoQalityUrls(
              quality: int.tryParse(element.qualityLabel.split("p")[0]) ?? 0,
              url: element.url.toString(),
            ),
          ),
        );
      }

      // Close the YoutubeExplode client
      yt.close();

      return urls;
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        log(
          podErrorString(
            '(INFO) To play YouTube video in WEB, please enable CORS in your browser',
          ),
        );
      }
      debugPrint('===== YOUTUBE API ERROR: $error ==========');
      rethrow;
    }
  }
}
