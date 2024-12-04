


import 'package:flutter/material.dart';
import 'package:marketapp/languages/ar_constant.dart';
import 'package:marketapp/languages/en_constant.dart';

class PopupInfo extends StatelessWidget {
   PopupInfo({super.key,this.isArabic=false});

  bool isArabic ; 
  
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> selectedLanguage = isArabic ? ar : en;
    return AlertDialog(
          content:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const Icon(
                Icons.local_shipping_rounded,
                size: 40,
                color: Colors.greenAccent,
              ),
             const SizedBox(
                height: 10,
              ),
              Text(
                selectedLanguage['AppBarPopUpInfo'],
                textAlign: TextAlign.center,
                style:const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "00:07:51",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog when cancel is pressed
              },
              child: const Text('Cancel'),
            ),
          ],
        );
  }
}