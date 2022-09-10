class Event {
  final String title;
  final String description;
  DateTime date;
  DateTime time;
  final String owner;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.owner,
  });
  @override
  String toString() => title;
}
