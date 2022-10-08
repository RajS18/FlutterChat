import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String imageUrl;
  MessageBubble(this.message, this.username, this.imageUrl, this.isMe,
      {this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1
                                .color),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: !isMe?120:null,
          right: isMe? 120:null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
        )
      ],
      clipBehavior: Clip
          .none, //Now when we place top=-10 in positioned Circular avatar, avatar goes up and is clipped/cut
//row element(Container) dimension height is limted to its children. as we say top=-10 avatar mover up and gets clipped.
// to avoid this we basically say overflow : none=> clipBehavior: Clip.none....tht is no need to cut the element if
// overflow is found.
    );
  }
}
