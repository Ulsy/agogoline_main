import 'package:flutter/material.dart';
import 'trajectory_story_service.dart';

class LoadingPage extends StatefulWidget {
  @override
  int bgColor;
  LoadingPage({
    required this.bgColor,
  });

  State<LoadingPage> createState() => _LoadingPage();
}

class _LoadingPage extends State<LoadingPage> {
  Color colorView1 = Color.fromARGB(255, 90, 72, 203);
  Color colorView2 = Colors.white;

  @override
  int moovPosition = 1;
  bool isDisposed = false;

  void moovLoading() async {
    colorView1 =
        widget.bgColor == 1 ? Color.fromARGB(255, 90, 72, 203) : Colors.white;
    colorView2 =
        widget.bgColor == 1 ? Colors.white : Color.fromARGB(255, 90, 72, 203);
    await Future.delayed(Duration(milliseconds: 300));

    if (!isDisposed) {
      if (moovPosition != 3) {
        setState(() {
          moovPosition++;
        });
        moovLoading();
      } else {
        setState(() {
          moovPosition = 1;
        });
        moovLoading();
      }
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void initState() {
    moovLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 7.0,
            height: 7.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: moovPosition == 1 ? colorView1 : colorView2,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 7.0,
            height: 7.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: moovPosition == 2 ? colorView1 : colorView2,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          Container(
            width: 7.0,
            height: 7.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: moovPosition == 3 ? colorView1 : colorView2,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
