import 'dart:ffi';

import 'package:first_flutter_app/database.dart';
import 'package:first_flutter_app/util/dialog_box.dart';
import 'package:first_flutter_app/util/todo_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  //reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db  = ToDoDataBase();
  @override
  void initState() {
    //if this is the 1st time ever opening the app, then create default data
    if(_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }else {
      //there already exist data
      db.loadData();
    }
    // TODO: implement initState
    super.initState();
  }

  // text controller
  final _controller = TextEditingController();



  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDetaBase();
  }

  //save new task
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDetaBase();
  }

  //create a new task
  void createNewTask(){
    showDialog(
      context: context,
        builder: (context) {
        return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
      );
    },
    );
  }
 // delete Task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDetaBase();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      //
      backgroundColor: Colors.yellow[500],
      appBar: AppBar(
        title: Text('To Do'),
        elevation: 0,
        backgroundColor: Colors.yellow[200],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
    child: Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index){
          return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
