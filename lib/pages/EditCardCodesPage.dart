
import 'dart:async';

import 'package:demo_card_codes/custom_widgets/CardCodeWidget.dart';
import 'package:demo_card_codes/custom_widgets/ColorFormField.dart';
import 'package:demo_card_codes/model/CardCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCardCodesPage extends StatefulWidget {

  EditCardCodesPage({Key key, this.title,}) : super(key: key);
  final String title;

  @override
  _EditCardCodesPage createState() => _EditCardCodesPage();
}

class _EditCardCodesPage extends State<EditCardCodesPage> {

  CardCode cardCode;
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _codeTextEditingController = TextEditingController();

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    cardCode.code = barcodeScanRes;
    _codeTextEditingController.text = barcodeScanRes;
  }

  Color pickerColor = new Color(0xff443a49);

  @override
  Widget build(BuildContext context) {

    if (cardCode == null) {
      Map data = ModalRoute
          .of(context)
          .settings
          .arguments;

      cardCode = data != null ? data['cardCode'] : CardCode();

      _nameTextEditingController.text = cardCode.name;
      _codeTextEditingController.text = cardCode.code;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Card Codes'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CardCodeWidget(cardCode, clickable: false,),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: _nameTextEditingController,
                    onChanged: (value) => setState(() => cardCode.name = value),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: "Card name",
                        contentPadding: const EdgeInsets.only(left: 8, right: 48),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () => _nameTextEditingController.clear(),
                        icon: Icon(Icons.clear)),
                  ),
                ],
              ),
            ),
            ColorFormField(
              color: cardCode.foreground,
              description: 'Foreground',
              onPressed: () {
                pickerColor = cardCode.foreground;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pick a foreground color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (value) => setState(() => pickerColor = value),
                        enableLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Got it'),
                        onPressed: () {
                          setState(() => cardCode.foreground = pickerColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            ColorFormField(
              color: cardCode.background,
              description: 'Background',
              onPressed: () {
                pickerColor = cardCode.background;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pick a background color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (value) => setState(() => pickerColor = value),
                        enableLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Got it'),
                        onPressed: () {
                          setState(() => cardCode.background = pickerColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          controller: _codeTextEditingController,
                          onChanged: (value) => setState(() => cardCode.code = _codeTextEditingController.text.trim()),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'Code',
                              contentPadding: const EdgeInsets.only(left: 8, right: 48),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)))),

                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => scanBarcodeNormal(),
                              child: Image.asset('assets/icons/bacode_scaner.png', width: 36, height: 36,)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                  child: Text('CANCEL', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
                SizedBox(width: 20,),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                    child: Text('SAVE', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      if (cardCode.id != null) {
                        DocumentReference docRef = FirebaseFirestore.instance.collection('codes').doc(cardCode.id);
                        docRef.update(cardCode.toJson());
                      } else {
                        CollectionReference collection = FirebaseFirestore.instance.collection('codes');
                        collection.add(cardCode.toJson());
                      }

                      Navigator.of(context).pop();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}