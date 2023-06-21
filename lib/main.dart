import 'package:shopping_list/ui/items_screen.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/util/dbhelper.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/ui/shopping_list_dialog.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowList(),
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList = [];

  ShoppingListDialog? dialog;
  @override
  void initState(){
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
        appBar: AppBar(
          title: Text("My shopping list"),
        ),
        body: ListView.builder(
            itemCount: (shoppingList != null)? shoppingList.length:0,
            itemBuilder: (BuildContext context, int index){
              return Dismissible(
                  key: Key(shoppingList[index].id.toString()),
                  onDismissed: (direction){
                    String strName = shoppingList[index].name;
                    helper.deleteList(shoppingList[index].id);
                    setState(() {
                      shoppingList.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$strName list deleted"),)
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete),
                  ),
                  child: ListTile(
                    title: Text(shoppingList[index].name),
                    leading: CircleAvatar(
                      child: Text(shoppingList[index].priority.toString()),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){
                        //aqui llamo a la actualizacion
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                        dialog!.buildDialog(context, shoppingList[index], false));
                      },
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ItemScreen(shoppingList:shoppingList[index]))
                      );
                    },
                  )
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  dialog!.buildDialog(context, ShoppingList(0, '', 0), true));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  Future showData() async{
    await helper.openDB();

    shoppingList = await helper.getList();

    setState(() {
      shoppingList = shoppingList;
    });

  }

}
