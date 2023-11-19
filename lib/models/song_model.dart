import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongModel {
  final String videoId;
  final String title;
  final List<Map<String, dynamic>> artists;
  final Map<String, dynamic> album; // Add album information

  final List<Map<String, dynamic>> thumbnails;
  final String duration;
  final Rx<bool> isLiked;

  SongModel({
    required this.videoId,
    required this.title,
    required this.artists,
    required this.album, // Add album information

    required this.thumbnails,
    required this.duration,
    required this.isLiked,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      videoId: json['videoId']?.toString() ?? '',
      title: json['title'] ?? '',
      artists: List<Map<String, dynamic>>.from(json['artists'] ?? []),
      album: Map<String, dynamic>.from(
          json['album'] ?? {}), // Add album information
      thumbnails: List<Map<String, dynamic>>.from(json['thumbnails'] ?? []),
      duration: json['duration']?.toString() ?? '',
      isLiked: Rx<bool>(json['isLiked'] ??
          false), // Initialize with the value from JSON, or default to false
    );
  }
}
