
import 'package:demo_card_codes/RouteNames.dart';
import 'package:demo_card_codes/custom_widgets/CardCodeWidget.dart';
import 'package:demo_card_codes/model/CardCode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title,}) : super(key: key);
  final String title;

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Codes'),
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white,),
              onPressed: () => Navigator.of(context).pushNamed(RouteNames.EDIT_CARD_CODE_PAGE))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('codes').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Text('Loading ...');

            return GridView.count(
            crossAxisCount: 2,
            childAspectRatio:  85.6/54,
            children: snapshot
                .data
                .documents
                .map<Widget>((dataSnapshot) => CardCodeWidget(CardCode.fromDataSnapshot(dataSnapshot))).toList(),
          );
          },
        ),
      ),
    );
  }
}