class BusinessHours {
  String businessHoursId;
  final int weekday;
  final int openingHour;
  final int openingMinute;
  final int closingHour;
  final int closingMinute;

  BusinessHours({
    this.businessHoursId = '',
    required this.weekday,
    required this.openingHour,
    required this.openingMinute,
    required this.closingHour,
    required this.closingMinute,
  });
}