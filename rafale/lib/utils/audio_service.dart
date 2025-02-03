import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 0.5;

  AudioPlayerService() {
    _init();
  }

  Future<void> _init() async {
    try {
      await _loadInitialAudio();

      _audioPlayer.setVolume(_volume);
      _audioPlayer.setLoopMode(LoopMode.all);

      await _audioPlayer.play();
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  Future<void> _loadInitialAudio() async {
    try {
      await _audioPlayer.setAsset('lib/assets/audio/lofi-vocoder-thing-87499.wav');
    } catch (e) {
      print('Error loading initial audio: $e');
    }
  }

  double get volume => _volume;

  void setVolume(double volume) {
    _volume = volume;
    _audioPlayer.setVolume(volume);
    notifyListeners();
  }

  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
    notifyListeners();
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
    notifyListeners();
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
    notifyListeners();
  }

  Future<void> changeMusic(String path) async {
    try {
      await _audioPlayer.setAsset('lib/assets/audio/$path');
      // await _audioPlayer.play();
    } catch (e) {
      print('Error changing audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}