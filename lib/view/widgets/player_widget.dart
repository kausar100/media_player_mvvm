import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_flutter/model/model.dart';
import 'package:mvvm_flutter/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

enum PlayerState { stopped, playing, paused }

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});


  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String? _prevSongName;

  late AudioPlayer _audioPlayer;
  Duration? _duration;
  Duration? _position;

  PlayerMode mode = PlayerMode.MEDIA_PLAYER;

  PlayerState _playerState = PlayerState.stopped;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  void _playCurrentMedia(Media? media) {
    if (media != null && _prevSongName != media.trackName) {
      _prevSongName = media.trackName;
      _position = null;
      _stop();
      _play(media);
    }
  }

  @override
  Widget build(BuildContext context) {
    Media? media = Provider.of<MediaViewModel>(context).media;
    _playCurrentMedia(media);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => null,
              icon: Icon(
                // Icons.skip_previous,
                Icons.fast_rewind,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.secondary
                    : const Color(0xFF787878),
              ),
            ),
            ClipOval(
                child: Container(
              color: Theme.of(context).colorScheme.secondary.withAlpha(30),
              width: 50.0,
              height: 50.0,
              child: IconButton(
                onPressed: () {
                  if (_isPlaying) {
                    setState(() {});
                    _pause();
                  } else {
                    if (media != null) {
                      setState(() {});
                      _play(media);
                    }
                  }
                },
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            )),
            IconButton(
              onPressed: () => null,
              icon: Icon(
                //Icons.skip_next,
                Icons.fast_forward,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.secondary
                    : const Color(0xFF787878),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Slider.adaptive(
                value: (_position != null &&
                        _duration != null &&
                        _position!.inMilliseconds > 0 &&
                        _position!.inMilliseconds < _duration!.inMilliseconds)
                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                    : 0.0,
                onChanged: (value) {
                  final position = value * _duration!.inMilliseconds;
                  _audioPlayer.seek(Duration(milliseconds: position.round()));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((pos) => setState(() {
              _position = pos;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = _duration;
        _playerState = PlayerState.stopped;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = const Duration(seconds: 0);
        _position = const Duration(seconds: 0);
      });
    });
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();

    if (result == 1) {
      setState(() {
        _playerState = PlayerState.paused;
      });
    }

    return result;
  }

  Future<int> _play(Media media) async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position!.inMilliseconds > 0 &&
            _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;

    final result =
        await _audioPlayer.play(media.previewUrl!, position: playPosition);

    if (result == 1) {
      setState(() {
        _playerState = PlayerState.playing;
      });
    }

    // _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = const Duration();
      });
    }

    _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    return result;
  }

  void _onComplete() {
    setState(() {
      _playerState = PlayerState.stopped;
    });
  }
}
