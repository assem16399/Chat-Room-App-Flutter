import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String imageUrl;
  final bool isMe;
  MessageBubble(
      {Key key,
      @required this.message,
      @required this.isMe,
      @required this.username,
      @required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: !isMe ? Radius.circular(12) : Radius.circular(0),
                ),
              ),
              constraints: BoxConstraints(maxWidth: deviceSize.width * 0.45),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color),
                    textAlign: isMe ? TextAlign.right : TextAlign.right,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: isMe ? -17 : null,
              right: isMe ? null : -17,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            )
          ],
          overflow: Overflow.visible,
          clipBehavior: Clip.none,
        ),
      ],
    );
  }
}
