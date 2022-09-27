library forms;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'scanner.dart';
class MyHome extends StatelessWidget {

  String name,email,linkedid;
  //String qrData = 'bharathiselvakumar.bs@gmail.com';
  MyHome({required this.name, required this.email,required this.linkedid});
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'helo',
      home: Scaffold(
        appBar: AppBar(
            title:const Text('qrcode')),
        body: Builder(
          builder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  QrImage(
                    data: '${email}',
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                  ),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewExample(email : '${email}')),
                      // Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyHome1(myHome: new MyHome(name,email,linkedid)));
                    );
                  }, child: Text('expand',
                    style: TextStyle(fontSize: 25),),
                  ),
                ],
              )


          ),
        ),
      ),
    );
  }


}