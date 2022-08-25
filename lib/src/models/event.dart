class Event {
  final String title;
  final String description;
  Event ({required this.title, required this.description});
  @override
  String toString() => title;
}