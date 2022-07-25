import 'package:flutter/material.dart';

Widget chatTypeMessageWidget(TextEditingController messageTextController,
    Function submitMessageFunction) {
  return ConstrainedBox(
    constraints: const BoxConstraints(
      minHeight: 60,
      maxHeight: 120.0,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 60,
                  maxHeight: 120.0,
                ),
                child: TextField(
                  controller: messageTextController,
                  scrollPhysics: const BouncingScrollPhysics(),
                  maxLines: null,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    filled: false,
                    focusedBorder: InputBorder.none,
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(16, 16, 32, 16),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => submitMessageFunction(),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.send,
                color: Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
