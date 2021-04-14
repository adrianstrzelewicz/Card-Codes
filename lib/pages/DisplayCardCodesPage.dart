
import 'dart:io';

import 'package:demo_card_codes/custom_widgets/CardCodeWidget.dart';
import 'package:demo_card_codes/model/CardCode.dart';
import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';

class DisplayCardCodesPage extends StatefulWidget {

  DisplayCardCodesPage({Key key, this.title,}) : super(key: key);
  final String title;

  @override
  _DisplayCardCodesPage createState() => _DisplayCardCodesPage();
}

class _DisplayCardCodesPage extends State<DisplayCardCodesPage> {

  CardCode cardCode;

  void buildBarcode(
      Barcode barCode,
      String data, {
        String filename,
        double width,
        double height,
        double fontHeight,
      }) {
    /// Create the Barcode
    final svg = barCode.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
      fontHeight: fontHeight,
    );

    // Save the image
    filename ??= barCode.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
    File('$filename.svg').writeAsStringSync(svg);
  }

  @override
  Widget build(BuildContext context) {

    if (cardCode == null) {
      Map data = ModalRoute
          .of(context)
          .settings
          .arguments;
      cardCode = data['cardCode'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Card code'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CardCodeWidget(cardCode, clickable: false,),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 8, 60),
              child: BarcodeWidget(
                barcode: Barcode.ean13(), // Barcode type and settings
                data: cardCode.code, // Content
                width: 300,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}