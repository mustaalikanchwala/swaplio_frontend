import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text("Home Screen"),
          decoration: BoxDecoration(
            color: Colors.amberAccent,
          ),
        ),
      ),
    );
  }

}