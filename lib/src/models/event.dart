class Event {
  final String title;
  final String description;
  DateTime date;
  DateTime time;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });
  @override
  String toString() => title;
}
