import 'package:flutter/material.dart';
import 'package:shopping_list/util/dbhelper.dart';
import 'package:shopping_list/models/shopping_list.dart';

class ShoppingListDialog{
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();
    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    else{
      txtName.text = "";
      txtPriority.text = "";
    }

      return AlertDialog(
        title: Text((isNew)? "New shoppinglist" : "Edit shoppinglist"),
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
                controller: txtPriority,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Ingrese prioridad (1..3)"
                ),
              ),
              ElevatedButton(
                child: Text("Grabar"),
                onPressed: (){
                  list.name = txtName.text;
                  list.priority = int.parse(txtPriority.text);
                  helper.insertList(list);
                  Navigator.pop(context);
                }, )
            ],
          ),
        ),
      );
    }
}