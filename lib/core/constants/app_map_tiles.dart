/// Map tile settings for [AppMapPreview].
///
/// Uses OpenStreetMap standard tiles (no API key). Fine for light in-app use;
/// respect OSM tile usage policy for heavy production traffic.
/// See: https://operations.osmfoundation.org/policies/tiles
class AppMapTiles {
  AppMapTiles._();

  static const osmTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Kept as an alias so older call sites still compile.
  static const voyagerTemplate = osmTemplate;

  static const List<String> subdomains = <String>[];

  /// Default map center when no GPS coordinates are set (Islamabad, Pakistan).
  static const defaultLatitude = 33.6844;
  static const defaultLongitude = 73.0479;

  static const openStreetMapCopyrightUrl =
      'https://www.openstreetmap.org/copyright';

  static Uri googleMapsNavigationUri(
    double latitude,
    double longitude,
  ) => Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
  );

  static Uri googleMapsGeoUri(double latitude, double longitude) =>
      Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
}
