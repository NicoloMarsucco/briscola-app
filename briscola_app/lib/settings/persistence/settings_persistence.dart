/// An interface of persistence stores for settings.
abstract class SettingsPersistence {
  Future<void> saveMusicOn(bool value);
  Future<bool> getMusicOn({required bool defaultValue});
}
