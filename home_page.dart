import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller= TextEditingController();
  List<String> items = [];


  void addItem() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter Task name"
            ),

          ),
          actions: [
            TextButton(
                onPressed: (){
                  _controller.clear();
                  Navigator.pop(context);
                },
                child: Text("Cancel")),

            ElevatedButton(
                onPressed: (){
                  String task= _controller.text.toString();
                  if(task.isNotEmpty){
                    setState(() {
                      items.add(task);
                    });
                  };
                  saveList(items);
                  _controller.clear();
                  Navigator.pop(context);
                },
                child: Text("Add Task"))
          ],
        ));
  }

  void _removeTask(int index) {
    setState(() {
      items.removeAt(index);
    });
    saveList(items);
  }

  // void editItem(){
  //   setState(() {
  //
  //   });
  // }


  void _editItem(int index) {
    TextEditingController _editController =
    TextEditingController(text: items[index]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Item'),
        content: TextField(
          controller: _editController,
          decoration: InputDecoration(hintText: 'Edit task'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                items[index] = _editController.text.trim();

              });
              saveList(items);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  //Save the list or any value:
  Future<void> saveList(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todo_items', items);
  }

  //Load the list on app start:
  Future<List<String>> loadList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('todo_items') ?? [];
  }

  @override
  void initState() {
    super.initState();
    loadList().then((savedItems) {
      setState(() {
        items = savedItems;
      });
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("To Do List"),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Expanded(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: InkWell(
                    onTap: (){
                      _editItem(index);
                    },
                      child: Text(items[index])),
                  leading: CircleAvatar(
                      child: Text("${index+1}")),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,),
                    onPressed: () {
                      _removeTask(index);
                      },),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addItem();
          },
          child: Icon(Icons.add),
        ));
  }
}
