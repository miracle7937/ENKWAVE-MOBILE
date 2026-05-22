import 'dart:async';

import 'package:etop_pos_plugin/etop_pos_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _etopPosPlugin = EtopPosPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _etopPosPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  var data = {
    "payments": [
      {
        "RRN": "230001075885",
        "STAN": "075805",
        "acquiringInstitutionIdCode": "111145",
        "cardCardSequenceNum": "000",
        "cardExpireData": "2607",
        "forwardingInstCode": "013622",
        "institutionData": {
          "tid": "2ETP0012",
          "email": "",
          "level": "secondary",
          "amount": "1",
          "accountType": "00",
          "phoneNumber": "055667777779",
          "studentClass": "SS 2",
          "institutionID": "915957",
          "institutionName": "Holy Cross Secondary School",
          "studentFullName": "CHukwude Miracle"
        },
        "pan": "4685886200790125",
        "pinBlock": "9ACC4BE2DBD085B6",
        "receiptNumber": "30123302133",
        "respCode": "75",
        "responseMessage": "PIN tries exceeded",
        "status": true,
        "successResponse": "RESPONSE RECEIVED",
        "systemTraceAuditNo": "075805",
        "terminalId": "000000000100",
        "transactionDate": "0901",
        "transactionDateTime": "0901075806",
        "transactionTime": "075806",
        "transactionType": "PURCHASE",
        "createdAt": "2023-09-08T11:27:55.154Z",
        "updatedAt": "2023-09-08T11:27:55.154Z"
      },
      {
        "RRN": "230001075885",
        "STAN": "075805",
        "acquiringInstitutionIdCode": "111145",
        "cardCardSequenceNum": "000",
        "cardExpireData": "2607",
        "forwardingInstCode": "013622",
        "institutionData": {
          "tid": "2ETP0012",
          "email": "",
          "level": "secondary",
          "amount": "1",
          "accountType": "00",
          "phoneNumber": "055667777779",
          "studentClass": "SS 2",
          "institutionID": "123456",
          "institutionName": "Holy Cross Secondary School",
          "studentFullName": "CHukwude Miracle"
        },
        "pan": "4685886200790125",
        "pinBlock": "9ACC4BE2DBD085B6",
        "receiptNumber": "30123302133",
        "respCode": "75",
        "responseMessage": "PIN tries exceeded",
        "status": true,
        "successResponse": "RESPONSE RECEIVED",
        "systemTraceAuditNo": "075805",
        "terminalId": "000000000100",
        "transactionDate": "0901",
        "transactionDateTime": "0901075806",
        "transactionTime": "075806",
        "transactionType": "PURCHASE",
        "createdAt": "2023-09-08T11:27:55.154Z",
        "updatedAt": "2023-09-08T11:27:55.154Z"
      },
      {
        "RRN": "230001075885",
        "STAN": "075805",
        "acquiringInstitutionIdCode": "111145",
        "cardCardSequenceNum": "000",
        "cardExpireData": "2607",
        "forwardingInstCode": "013622",
        "institutionData": {
          "tid": "2ETP0012",
          "email": "",
          "level": "secondary",
          "amount": "1",
          "accountType": "00",
          "phoneNumber": "055667777779",
          "studentClass": "SS 2",
          "institutionID": "123456",
          "institutionName": "Holy Cross Secondary School",
          "studentFullName": "CHukwude Miracle",
          'paymentPeriod': 'FIRST TERM',
          'paymentPurpose': 'SCHOOL FEES',
          "examinations": "Neco"
        },
        "pan": "4685886200790125",
        "pinBlock": "9ACC4BE2DBD085B6",
        "receiptNumber": "30123302133",
        "respCode": "75",
        "responseMessage": "PIN tries exceeded",
        "status": true,
        "successResponse": "RESPONSE RECEIVED",
        "systemTraceAuditNo": "075805",
        "terminalId": "000000000100",
        "transactionDate": "0901",
        "transactionDateTime": "0901075806",
        "transactionTime": "075806",
        "transactionType": "PURCHASE",
        "createdAt": "2023-09-08T11:27:55.154Z",
        "updatedAt": "2023-09-08T11:27:55.154Z"
      },
    ],
    "totalItems": 6
  };

  // TID: 2030A459
  //
  // IP : 196.6.103.10
  // Port: 55533
  //
  // Component keys
  // key 1= 5D25072F04832A2329D93E4F91BA23A2
  // key 2= 86CBCDE3B0A22354853E04521686863

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: () {
                  _etopPosPlugin.prepDevice("2EWV0002", {
                    "ip": "core.medusang.com",
                    "port": "8080",
                    "ssl": "false",
                    "compKey1": "64BF59DCF87756A3D49A3050A8D1F245",
                    "compKey2": "052378E8D0B894522471B254D0D6C83A",
                    "baseUrl": "https://test2.enkpay.com/api/",
                    "logoUrl": "https: //enkpay.com/icon.jpeg"
                  });
                },
                child: const Text("Prep"),
              ),
              ElevatedButton(
                onPressed: () {
                  var data = {
                    "printTwice": "true",
                    "merchantName": "Elbuhaj Royal Academy",
                    "merchantNo": "220437",
                    "terminalNo": "2EWV0002",
                    "amount": "10",
                    "accountType": "00",
                  };
                  _etopPosPlugin.pay(data);
                },
                child: const Text("Pay"),
              ),
              ElevatedButton(
                onPressed: () {
                  var data = {
                    "printTwice": "false",
                    "merchantName": "Elbuhaj Royal Academy",
                    "merchantNo": "220437",
                    "terminalNo": "2EWV0002",
                    "amount": "1",
                    "accountType": "00",
                  };
                  _etopPosPlugin.balanceInquiry(data);
                },
                child: const Text("Balance Inquiry"),
              ),
              ElevatedButton(
                onPressed: () {
                  _etopPosPlugin.print();
                },
                child: const Text("PRINT"),
              ),
              ElevatedButton(
                onPressed: () {
                  _etopPosPlugin.printEOD(
                    map: data,
                  );
                },
                child: const Text("EOD PRINT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
