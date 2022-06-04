class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;
  final bool isOnline;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
    required this.isOnline,
  });
}
