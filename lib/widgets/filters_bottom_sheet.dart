import 'package:flutter/material.dart';
import '../models/filters.dart';
import '../widgets/inherited_shared_data.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({super.key});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  List<String> selectedCategories = [];
  double distanceSliderValue = 500.0;
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<String> categories = SharedData.of(context).categories;

    if (!isInitialized) {
      _initializeFilters();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 32.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Search Filters',
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20.0),

          Text(
            'Product Categories',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 8.0),

          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              spacing: 6.0,
              children: [
                _buildFilterChip(categories[0]),
                _buildFilterChip(categories[1]),
                _buildFilterChip(categories[2]),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              spacing: 6.0,
              children: [
                _buildFilterChip(categories[3]),
                _buildFilterChip(categories[4]),
                _buildFilterChip(categories[5]),
              ],
            ),
          ),

          const SizedBox(height: 28.0),

          Text(
            'Distance',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 12.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('50m', style: textTheme.labelMedium),
                Text('>500m', style: textTheme.labelMedium),
              ],
            ),
          ),

          Slider(
            value: distanceSliderValue,
            onChanged: (value) {
              setState(() => distanceSliderValue = value);
            },
            min: 50.0,
            max: 500.0,
            divisions: 9,
            label: distanceSliderValue.round().toString(),
          ),

          const Expanded(child: SizedBox()),

          FilledButton(
            onPressed: () {
              final Filters filters = SharedData.of(context).filters;
              filters.selectedFood = selectedCategories.contains(categories[0]);
              filters.selectedDrinks = selectedCategories.contains(categories[1]);
              filters.selectedHygiene = selectedCategories.contains(categories[2]);
              filters.selectedMedicine = selectedCategories.contains(categories[3]);
              filters.selectedHousehold = selectedCategories.contains(categories[4]);
              filters.selectedConvenience = selectedCategories.contains(categories[5]);
              filters.distance = distanceSliderValue;
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: colorScheme.primaryContainer),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Apply Filters',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),

          OutlinedButton(
            onPressed: () {
              final Filters filters = SharedData.of(context).filters;
              filters.clearFilters();
              Navigator.pop(context);
            },
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Reset Filters',
                  style: textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String category) {
    return FilterChip(
      label: Text(category),
      selected: selectedCategories.contains(category),
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            selectedCategories.add(category);
          } else {
            selectedCategories.remove(category);
          }
        });
      },
      showCheckmark: false,
    );
  }

  void _initializeFilters() {
    final List<String> categories = SharedData.of(context).categories;
    final Filters filters = SharedData.of(context).filters;

    setState(() {
      if (filters.selectedFood) selectedCategories.add(categories[0]);
      if (filters.selectedDrinks) selectedCategories.add(categories[1]);
      if (filters.selectedHygiene) selectedCategories.add(categories[2]);
      if (filters.selectedMedicine) selectedCategories.add(categories[3]);
      if (filters.selectedHousehold) selectedCategories.add(categories[4]);
      if (filters.selectedConvenience) selectedCategories.add(categories[5]);
      distanceSliderValue = filters.distance;
      isInitialized = true;
    });
  }
}