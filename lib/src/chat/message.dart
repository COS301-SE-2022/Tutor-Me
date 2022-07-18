class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;
  final bool isOnline;
  final String sentBy;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
    required this.isOnline,
    required this.sentBy,
  });
}
