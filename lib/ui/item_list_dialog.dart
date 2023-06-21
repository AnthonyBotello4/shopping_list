import 'package:flutter/material.dart';
import 'package:shopping_list/util/dbhelper.dart';
import 'package:shopping_list/models/item_list.dart';

class ItemListDialog{
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew){
    DbHelper helper = DbHelper();
    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity.toString();
      txtNote.text =  item.note;
    }
    // else{
    //   //aquí ponen si no funciona bien los nombres
    //   txtName.text = "";
    //   txtNote.text = "";
    // }

    return AlertDialog(
      title: Text((isNew)? "New item" : "Edit item"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                  hintText: "Ingrese nombre"
              ),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                  hintText: "Ingrese cantidad"
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                  hintText: "Ingrese detalles"
              ),
            ),
            ElevatedButton(
              child: Text("Grabar item"),
              onPressed: (){
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;

                helper.insertItems(item);
                Navigator.pop(context);
              }, )
          ],
        ),
      ),
    );
  }
}