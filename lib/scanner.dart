
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:login_singup/successpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class QRViewExample extends StatefulWidget {
  // const QRViewExample({Key? key}) : super(key: key);
  QRViewExample({required this.email});
  String email;
  // print(email);
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;


  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //           onPressed: () async {
                  //             await controller?.toggleFlash();
                  //             setState(() {});
                  //           },
                  //           child: FutureBuilder(
                  //             future: controller?.getFlashStatus(),
                  //             builder: (context, snapshot) {
                  //               return Text('Flash: ${snapshot.data}');
                  //             },
                  //           )),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //           onPressed: () async {
                  //             await controller?.flipCamera();
                  //             setState(() {});
                  //           },
                  //           child: FutureBuilder(
                  //             future: controller?.getCameraInfo(),
                  //             builder: (context, snapshot) {
                  //               if (snapshot.data != null) {
                  //                 return Text(
                  //                     'Camera facing ${describeEnum(snapshot.data!)}');
                  //               } else {
                  //                 return const Text('loading');
                  //               }
                  //             },
                  //           )),
                  //     )
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       await controller?.pauseCamera();
                      //     },
                      //     child: const Text('pause',
                      //         style: TextStyle(fontSize: 20)),
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('Scan',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  late String username;
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });


    int counter=0;
    controller.scannedDataStream.listen((scanData) async {
      counter++;
      await controller.pauseCamera();

      String? url = scanData.code;
      log('$url');

      if (counter == 1) {
        setState(() {
          result = scanData;
          username = scanData.code!;
          // mailsend(username);

          MailFeedback(username);
          _launchURLBrowser();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SuccessPage()),
          );

          //
        }); //setstate
      }
    });//controller
  }//fun

  _launchURLBrowser() async {
    var url = Uri.parse("linkedin.com/in/sabhari-p");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      // ,forceWebView: true);
      // await closeWebView();
    } else {
      throw 'Could not launch $url';
    }
  }

  Future MailFeedback(String username) async {
    // final service_id = 'your_server_id';
    // final template_id = 'your_temp_id';
    // final user_id = 'your_user_id';

    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try {
      var response = await  http.post(url,
          headers: {
            'origin': 'http://localhost',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'service_id': 'service_tkdt08p',
            'template_id': 'template_qpwea4m',
            'user_id': 'hSL5EiltIGF_1VXfd',
            // 'from_mail': 'paavanimugi.m@gmail.com',
            // 'to_mail': 'bharathiselvakumar.bs@gmail.com',

            'template_params': {
              'message': 'Hi,hope you do well ,Wolud like to join your network.',
              'from_mail': widget.email,
              'to_mail': username,
              // 'rating': rating,
              // 'date': date,
            }
          }));
      print('[FEED BACK RESPONSE]');
      print(response.body);
    } catch (error) {
      print('[SEND FEEDBACK MAIL ERROR]');
    }
  }


  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
