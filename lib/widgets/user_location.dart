import 'package:flutter/material.dart';

class UserLocation extends StatelessWidget {
  final String locationName;

  const UserLocation({
    super.key,
    required this.locationName
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {},
        style: FilledButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: colorScheme.surfaceContainerLow,
          iconColor: colorScheme.primary,
          elevation: 2.0,
          alignment: const Alignment(-1.0, 0.0),
        ),
        icon: const Icon(Icons.near_me),
        label: Text(locationName, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}