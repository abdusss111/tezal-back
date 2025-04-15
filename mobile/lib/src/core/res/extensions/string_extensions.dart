extension StringExtensions on String {
  String capitalizeFirstLetter() {
    return isEmpty ? this : this[0].toUpperCase() + substring(1);
  }
}
