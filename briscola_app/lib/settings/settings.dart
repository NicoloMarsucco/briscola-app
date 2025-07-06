import 'package:briscola_app/settings/persistence/local_storage_settings_persistence.dart';
import 'package:briscola_app/settings/persistence/settings_persistence.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

class SettingsController {
  static final _log = Logger('SettingsController');

  /// The persistence store that is used to save settings.
  final SettingsPersistence _store;

  /// Whether the music is on or not.
  ValueNotifier<bool> musicOn = ValueNotifier(true);

  /// Whether the sounds effects should be played or not.
  ValueNotifier<bool> soundsOn = ValueNotifier(true);

  /// Creates a new instance of [SettingsController] backed by [store].
  SettingsController({SettingsPersistence? store})
      : _store = store ?? LocalStorageSettingsPersistence() {
    _loadStateFromPersistence();
  }

  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
    _store.saveMusicOn(musicOn.value);
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _store.saveSoundsOn(soundsOn.value);
  }

  /// Asynchronously loads values from the injected persistence store.
  Future<void> _loadStateFromPersistence() async {
    final loadedValues = await Future.wait([
      _store
          .getMusicOn(defaultValue: true)
          .then((value) => musicOn.value = value),
      _store.getSoundsOn(defaultValue: true).then((value) => soundsOn.value),
    ]);
    _log.fine(() => "Loaded settings: $loadedValues");
  }
}
