import 'package:flutter/material.dart';


void main() => runApp(const MaterialApp(home: SuccessPage()));

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        // child: TextButton(
        // onPressed: () {

        //},
        child: const Text('Success'),

      ),

    );
  }
}