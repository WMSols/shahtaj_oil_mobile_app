import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_map_tiles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';

class AppMapPreview extends StatelessWidget {
  const AppMapPreview({
    super.key,
    this.latitude,
    this.longitude,
    this.defaultLatitude = AppMapTiles.defaultLatitude,
    this.defaultLongitude = AppMapTiles.defaultLongitude,
  });

  final double? latitude;
  final double? longitude;
  final double defaultLatitude;
  final double defaultLongitude;

  bool get _hasValidCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.abs() <= 90 &&
      longitude!.abs() <= 180;

  LatLng get _center => _hasValidCoordinates
      ? LatLng(latitude!, longitude!)
      : LatLng(defaultLatitude, defaultLongitude);

  Future<void> _openGoogleMaps() async {
    final lat = _center.latitude;
    final lng = _center.longitude;

    final uris = [
      AppMapTiles.googleMapsNavigationUri(lat, lng),
      AppMapTiles.googleMapsGeoUri(lat, lng),
    ];

    for (final uri in uris) {
      try {
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (opened) return;
      } catch (e, stackTrace) {
        debugPrint('AppMapPreview: failed to open $uri — $e');
        debugPrint('$stackTrace');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = AppResponsive.radius(context);
    final center = _center;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AbsorbPointer(
              child: FlutterMap(
                key: ValueKey(
                  'map-${center.latitude.toStringAsFixed(4)}-'
                  '${center.longitude.toStringAsFixed(4)}',
                ),
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: _hasValidCoordinates ? 15 : 12,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: AppMapTiles.voyagerTemplate,
                    subdomains: AppMapTiles.subdomains,
                    userAgentPackageName: 'com.shahtaj.oil.mobile',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 36,
                        height: 36,
                        alignment: Alignment.bottomCenter,
                        child: const Icon(
                          AppIcons.locationPin,
                          color: AppColors.error,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _openGoogleMaps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
