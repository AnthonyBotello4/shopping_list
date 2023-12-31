import 'package:shopping_list/ui/item_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/util/dbhelper.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/models/item_list.dart';

class ItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  const ItemScreen({Key? key, required this.shoppingList}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState(this.shoppingList);
}

class _ItemScreenState extends State<ItemScreen> {
  final ShoppingList shoppingList;
  _ItemScreenState(this.shoppingList);

  DbHelper ? helper = DbHelper();
  List<ListItem> items = <ListItem>[];
  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id);
    ItemListDialog dialog = ItemListDialog();
    return Scaffold(
        appBar: AppBar(
          title: Text(shoppingList.name),
        ),
        body: ListView.builder(
          itemCount: (items != null) ? items.length : 0,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
                key: Key(items[index].id.toString()),
                onDismissed: (direction){
                  String strName = items[index].name;
                  helper!.deleteItem(items[index].id);
                  setState(() {
                    items.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$strName deleted"),)
                  );
                },
                background: Container(
                  color: Colors.red,
                  child: Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(items[index].name),
                  subtitle: Text('Cantidad: ${items[index].quantity} - Nota: ${items[index].note}'),
                //   trailing: Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.edit),
                //       onPressed: () {
                //         showDialog(context: context, builder: (BuildContext context) => dialog.buildDialog(context, items[index], false));
                //       },
                //     ),
                //     SizedBox(width: 8.0), // Espacio entre los botones
                //     IconButton(
                //       icon: const Icon(Icons.delete),
                //       onPressed: () {
                //         print('Delete' + items[index].id.toString());
                //       },
                //     ),
                //   ],
                // ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: (){
                      showDialog(context: context, builder: (BuildContext context) => dialog.buildDialog(context, items[index], false));
                    },
                  ),
                  onTap: (){},
                )
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ListItem item = ListItem(0, shoppingList.id, '', '', '');
            showDialog(context: context, builder: (BuildContext context) => dialog.buildDialog(context, item, true));
          },
          child: const Icon(Icons.add),
          tooltip: 'Add new Item',
        )

    );
  }

  Future showData(int idList) async {
    await helper!.openDB();
    items = await helper!.getItems(idList);
    setState(() {
      items = items;
    });
  }
}