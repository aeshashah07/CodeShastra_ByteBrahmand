import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String Title;
  final String Info;
  const ProfileInfo({Key? key, required this.Title, required this.Info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey[400],
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
        // width: MediaQuery.of(context).size.width*0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Title,
              style: TextStyle(
                  color: secondaryColorDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              Info,
              style: TextStyle(color: secondaryColorDark, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}