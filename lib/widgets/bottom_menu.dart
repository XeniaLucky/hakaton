import 'package:flutter/material.dart';
import 'package:unexpected/pages/main_activity.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Color.fromARGB(255, 189, 187, 189),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Image.asset('image/teremok.gif', width: 74, height: 74),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainActivity()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}