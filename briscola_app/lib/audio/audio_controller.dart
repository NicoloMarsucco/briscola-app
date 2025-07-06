import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:briscola_app/app_lifecycle/app_lifecycle.dart';
import 'package:briscola_app/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'songs.dart';
import 'sounds.dart';

///Allows playing music and sound. A facade to `package:audioplayers`
class AudioController {
  static final _log = Logger("AudioController");

  /// The player of the background music.
  final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final List<AudioPlayer> _sfxPlayers;

  SettingsController? _settings;

  final Queue<Song> _playlist;

  final Random _random = Random();

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  int _currentSfxPlayer = 0;

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion of
  /// [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overriden by sound effects because that would be silly.
  AudioController({int polyphony = 2})
      : assert(polyphony >= 1),
        _musicPlayer = AudioPlayer(playerId: "musicPlayer"),
        _sfxPlayers = List.generate(
            polyphony, (i) => AudioPlayer(playerId: "sfxPlayer#$i"),
            growable: false),
        _playlist = Queue.of(List<Song>.of(songs)..shuffle()) {
    _musicPlayer.onPlayerComplete.listen(_handleSongFinished);
    unawaited(_preloadSfx());
  }

  /// Makes sure the audio controller is listening to changes of
  /// the app lifecyle.
  void attachDependencies(AppLifecycleStateNotifier lifecycleNotifier,
      SettingsController settings) {
    _attachLifeCycleNotifier(lifecycleNotifier);
    _attachSettings(settings);
    startOrResumeMusic();
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  /// Enables the [AudioController] to listen to [AppLifeCycleState] events,
  /// and therefore do things like stopping playback when the game goes into
  /// background.
  void _attachLifeCycleNotifier(AppLifecycleStateNotifier lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Enables [AudioController] to track changes to settings.
  void _attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.musicOn.removeListener(_musicOnHandler);
    }

    _settings = settingsController;

    // Add handlers
    settingsController.musicOn.addListener(_musicOnHandler);
  }

  void _musicOnHandler() {
    if (_settings!.musicOn.value) {
      startOrResumeMusic();
    } else {
      // Music got turned off.
      _musicPlayer.pause();
    }
  }

  /// Plays a single sound effect, defined by [type].
  void playSfx(SfxType type) {
    _log.fine(() => 'Playing sound: $type');
    final options = soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    _log.fine(() => '- Chosen filename: $filename');

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    currentPlayer.play(AssetSource('sfx/$filename'),
        volume: soundTypeToVolume(type));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  void _handleSongFinished(void _) {
    _log.info("Last song finished playing.");
    // Move the song that just finished playing to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the song at the beginning of the playlist.
    _playCurrentSongInPlaylist();
  }

  Future<void> _playCurrentSongInPlaylist() async {
    _log.info(() => 'Playing ${_playlist.first} now.');
    try {
      await _musicPlayer.play(AssetSource('music/${_playlist.first.filename}'));
    } catch (e) {
      _log.severe('Could not play song ${_playlist.first}', e);
    }
  }

  /// Preloads all sound effects.
  Future<void> _preloadSfx() async {
    _log.info('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.
    await AudioCache.instance.loadAll(SfxType.values
        .expand(soundTypeToFilename)
        .map((path) => 'sfx/$path')
        .toList());
  }

  void stopAllSound() {
    _log.info('Stopping all sound');
    _musicPlayer.pause();
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        stopAllSound();
      case AppLifecycleState.resumed:
        if (_settings!.musicOn.value) {
          startOrResumeMusic();
        }
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  void startOrResumeMusic() async {
    if (_musicPlayer.source == null) {
      _log.info('No music source set. '
          'Start playing the current song in playlist.');
      await _playCurrentSongInPlaylist();
      return;
    }

    _log.info('Resuming paused music.');
    try {
      _musicPlayer.resume();
    } catch (e) {
      // Sometimes, resuming fails with an "Unexpected" error.
      _log.severe('Error resuming music', e);
      // Try starting the song from scratch.
      _playCurrentSongInPlaylist();
    }
  }
}
