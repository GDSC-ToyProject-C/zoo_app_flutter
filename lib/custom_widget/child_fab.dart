import 'package:flutter/material.dart';
import '../size.dart';

class ChildActionButton extends StatelessWidget {
  final VoidCallback onpressed;
  final Icon icon;
  const ChildActionButton({required this.onpressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(
                icon.semanticLabel == 'big' ? 30 : 25 * getScaleWidth(context)),
            primary: Color(0xffa69988),
            elevation: 7,
            shadowColor: Colors.black,
            side: BorderSide(
              width: 1.0,
              color: Color(0xff707070),
            ),
          ),
          onPressed: onpressed,
          child: null,
          clipBehavior: Clip.antiAlias,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(8 * getScaleHeight(context)),
            primary: Color(0xffd6d2cb),
            side: BorderSide(
              width: 1.0,
              color: Color(0xff707070),
            ),
          ),
          onPressed: onpressed,
          child: icon,
          clipBehavior: Clip.antiAlias,
        ),
      ],
    );
  }
}
