import 'package:flutter/material.dart';
import '../services/location_service.dart';

class StoreCard extends StatefulWidget {
  final Map<String, dynamic> store;

  const StoreCard({super.key, required this.store});

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  double? distance;

  @override
  void initState() {
    super.initState();
    _loadDistance();
  }

  Future<void> _loadDistance() async {
    final dist = await LocationService.getDistance(widget.store['lat'], widget.store['lon']);
    if (mounted) {
      setState(() {
        distance = dist;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.store['name'], style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            Text(
              distance != null
                  ? '${LocationService.distanceToString(distance!)} away'
                  : 'Calculating distance...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
