import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/business_hours.dart';
import '../models/store.dart';
import '../theme/custom_colors.dart';

class StoreDetailsScreen extends StatelessWidget {
  final Store store;
  final List<BusinessHours> storeBusinessHours;

  const StoreDetailsScreen({
    super.key,
    required this.store,
    required this.storeBusinessHours,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Profile',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onTertiaryContainer,
            fontWeight: FontWeight.bold
          ),
        ),
        shadowColor: colorScheme.shadow,
        backgroundColor: colorScheme.tertiaryContainer,
        iconTheme: IconThemeData(color: colorScheme.onTertiaryContainer),
      ),
      body: Stack(
        children: [
          Container(
            color: colorScheme.primary,
            width: double.infinity,
            height: double.infinity,
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 160.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 64.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),

                  Row(
                    children: [
                      _buildHoursIndicator(context),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  Text(
                    store.blurb,
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16.0),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: const Icon(Icons.call),
                      label: Text('Call', style: textTheme.labelLarge),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  const Divider(),
                  const SizedBox(height: 16.0),

                  Text(
                    'Contact Information',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12.0,
                      children: [
                        Icon(
                          Icons.map,
                          size: 20.0,
                          color: colorScheme.onSurfaceVariant,
                        ),

                        Expanded(
                          child: Text(
                            store.address,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12.0,
                      children: [
                        Icon(
                          Icons.phone_android,
                          size: 20.0,
                          color: colorScheme.onSurfaceVariant,
                        ),

                        Expanded(
                          child: Text(
                            store.phoneNumber,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  SizedBox(
                    height: 200.0,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(store.latitude, store.longitude),
                        initialZoom: 16.0,
                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                      ),
                      children: [
                        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(store.latitude, store.longitude),
                              child: Icon(
                                Icons.location_on,
                                size: 28.0,
                                color: colorScheme.primaryContainer,
                                shadows: [
                                  const Shadow(offset: Offset(2.0, 2.0), blurRadius: 4.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  const Divider(),
                  const SizedBox(height: 16.0),

                  Text(
                    'Business Hours',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Column(
                    spacing: 8.0,
                    children: _buildHoursRow(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursIndicator(BuildContext context) {
    final CustomColors customColors = Theme.of(context).extension<CustomColors>()!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    Color? containerColor;
    Color? shapeColor;
    Color? textColor;
    late String indicatorText;

    if (_isStoreOpen(storeBusinessHours)) {
      containerColor = customColors.openContainer;
      shapeColor = customColors.open;
      textColor = customColors.onOpenContainer;
      indicatorText = 'Open';
    } else {
      containerColor = customColors.closedContainer;
      shapeColor = customColors.closed;
      textColor = customColors.onClosedContainer;
      indicatorText = 'Closed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        spacing: 6.0,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: ShapeDecoration(
              color: shapeColor,
              shape: const CircleBorder(),
            ),
          ),

          Text(
            indicatorText,
            style: textTheme.labelLarge?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHoursRow(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<String> dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return storeBusinessHours.map((businessHours) {
      String openingHour = businessHours.openingHour.toString().padLeft(2, '0');
      String openingMinute = businessHours.openingMinute.toString().padLeft(2, '0');
      String openingMeridian = (businessHours.openingHour < 12) ? 'AM' : 'PM';
      String closingHour = businessHours.closingHour.toString().padLeft(2, '0');
      String closingMinute = businessHours.closingMinute.toString().padLeft(2, '0');
      String closingMeridian = (businessHours.closingHour < 12) ? 'AM' : 'PM';
      String hours = '$openingHour:$openingMinute $openingMeridian – $closingHour:$closingMinute $closingMeridian';
      bool isHoursForToday = _isHoursForToday(businessHours);

      return SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 90.0,
              child: Text(
                dayNames[businessHours.weekday - 1],
                style: textTheme.bodyLarge?.copyWith(
                  color: isHoursForToday ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: isHoursForToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),

            Expanded(
              child: Text(
                hours,
                style: textTheme.bodyLarge?.copyWith(
                  color: isHoursForToday ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: isHoursForToday ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  bool _isStoreOpen(List<BusinessHours> storeBusinessHours) {
    DateTime now = DateTime.now();
    BusinessHours hoursToday = storeBusinessHours[now.weekday - 1];  
    DateTime closingHours = now.copyWith(
      hour: hoursToday.closingHour,
      minute: hoursToday.closingMinute,
    ).toLocal();

    return now.compareTo(closingHours) < 0;
  }

  bool _isHoursForToday(BusinessHours businessHours) {
    DateTime now = DateTime.now();
    return now.weekday == businessHours.weekday;
  }
}
