
import 'package:flutter/material.dart';

class ColorFormField extends StatelessWidget {

  final Color color;
  final String description;
  final Function onPressed;

  ColorFormField({this.color, this.description, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              color: Colors.black,
              child: Center(
                child: Container(
                  width: 22,
                  height: 22,
                  color: color,
                ),
              ),
            ),
            SizedBox(width: 16,),
            Text(description)
          ],
        ),
      ),
    );
  }
}