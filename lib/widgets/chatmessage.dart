import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sender)
            .text
            .white
            .subtitle1(context)
            .make()
            .box
            .color(Colors.white)
            .p16
            .rounded
            .alignCenter
            .makeCentered(),
        Expanded(
          child: text.trim().text.bodyText1(context).make().px8().color(Colors.white),
        ),
      ],
    ).py8();
  }
}
