class Filters {
  String query;
  bool selectedFood;
  bool selectedDrinks;
  bool selectedHygiene;
  bool selectedMedicine;
  bool selectedHousehold;
  bool selectedConvenience;
  double distance;

  Filters({
    this.query = '',
    this.selectedFood = true,
    this.selectedDrinks = true,
    this.selectedHygiene = true,
    this.selectedMedicine = true,
    this.selectedHousehold = true,
    this.selectedConvenience = true,
    this.distance = 500.0,
  });

  void clearFilters() {
    selectedFood = true;
    selectedDrinks = true;
    selectedHygiene = true;
    selectedMedicine = true;
    selectedHousehold = true;
    selectedConvenience = true;
    distance = 500.0;
  }
}