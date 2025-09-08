///Singleton Class with Getters & Setters
class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  ///The _internal constructor is a private named constructor in Dart.
  /// It ensures that the GlobalData class cannot be instantiated from outside the class.
  factory GlobalData() {
    return _instance;
  }

  GlobalData._internal();

  // Private boolean variables
  bool _tabletLayout = false;
  bool _arabic = true;

  // Getters
  bool get isTabletLayout => _tabletLayout;

  bool get isArabic => _arabic;

  // Setters
  set isTabletLayout(bool value) {
    _tabletLayout = value;
  }

  set isArabic(bool value) {
    _arabic = value;
  }
}
