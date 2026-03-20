import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {

  List toDoList = [];

  //reference our box
  final _myBox = Hive.box('mybox');

  //run this method if this is the first ever opening this app
  void createInitiable(){
    toDoList = [
      ["Make Tutorial", false],
      ["Do Exercise", false],
    ];
  }

  //load the data from database
void loadData() {
    toDoList = _myBox.get("TODOLIST");
}
// update the database
void updateDetaBase() {
    _myBox.put("TODOLIST", toDoList);

}

  void createInitialData() {}
}