import 'package:demo_card_codes/RouteNames.dart';
import 'package:demo_card_codes/enums/CardCodeActions.dart';
import 'package:demo_card_codes/model/CardCode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardCodeWidget extends StatelessWidget {
  final CardCode cardCode;
  final bool clickable;

  CardCodeWidget(this.cardCode, {this.clickable = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (clickable)
          Navigator.pushNamed(context, RouteNames.DISPLAY_CARD_CODE_PAGE,
              arguments: {'cardCode': cardCode});
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          children: [
            Card(
              elevation: 4,
              color: cardCode.background,
              child: AspectRatio(
                aspectRatio: 85.6 / 54,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        cardCode.name,
                        style: TextStyle(
                            color: cardCode.foreground,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ),
            Visibility(
              visible: clickable,
              child: Positioned(
                right: 12,
                top: 8,
                child: PopupMenuButton<CardCodeActions>(
                  onSelected: (value) {
                    switch (value) {
                      case CardCodeActions.EDIT:
                        Navigator.pushNamed(
                            context, RouteNames.EDIT_CARD_CODE_PAGE,
                            arguments: {'cardCode': cardCode});
                        break;
                      case CardCodeActions.REMOVE:
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Card will be deleted!'),
                              content: Text('Do you want to continue?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('NO')),
                                TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('codes')
                                          .doc(cardCode.id)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: Text('YES')),
                              ],
                            );
                          },
                        );
                        break;
                    }
                  },
                  child: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: cardCode.foreground,
                  ),
                  itemBuilder: (context) => <PopupMenuEntry<CardCodeActions>>[
                    const PopupMenuItem<CardCodeActions>(
                        value: CardCodeActions.EDIT, child: Text('Edit')),
                    const PopupMenuItem<CardCodeActions>(
                        value: CardCodeActions.REMOVE, child: Text('Remove')),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
