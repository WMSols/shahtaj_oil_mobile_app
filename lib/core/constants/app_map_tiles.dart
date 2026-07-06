/// Map tile settings for [AppMapPreview].
///
/// Do not use OpenStreetMap public tile servers in production apps.
/// See: https://operations.osmfoundation.org/policies/tiles
class AppMapTiles {
  AppMapTiles._();

  static const voyagerTemplate =
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';

  static const subdomains = ['a', 'b', 'c', 'd'];

  /// Default map center when no GPS coordinates are set (Islamabad, Pakistan).
  static const defaultLatitude = 33.6844;
  static const defaultLongitude = 73.0479;

  static const openStreetMapCopyrightUrl =
      'https://www.openstreetmap.org/copyright';
  static const cartoAttributionUrl = 'https://carto.com/attributions';

  static Uri googleMapsNavigationUri(
    double latitude,
    double longitude,
  ) => Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
  );

  static Uri googleMapsGeoUri(double latitude, double longitude) =>
      Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
}
