/// An interface of persistence stores for settings.
abstract class SettingsPersistence {
  Future<void> saveMusicOn(bool value);
  Future<bool> getMusicOn({required bool defaultValue});
  Future<void> saveSoundsOn(bool value);
  Future<bool> getSoundsOn({required bool defaultValue});
}
