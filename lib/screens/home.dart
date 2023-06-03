import 'package:flutter/material.dart';
import 'package:mobileapp/constants/colors.dart';

import '../model/todo.dart';
import '../widgets/todoItem.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = Todo.todoList();
  List<Todo> _foundTodo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _foundTodo = todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                SearchBox(),
                Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50, bottom: 50),
                          child: Text(
                            'All toDos',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if(_foundTodo.length == 0)
                          Container(
                            child: Text('No todos added'),
                          ),
                        for( Todo todo in _foundTodo.reversed)
                          TodoItem(todo: todo,onTodoChanged: _handleToDoChange,onDeleteItem:_deleteToDoItem,)
                      ],
                    )
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      margin:EdgeInsets.only(bottom: 20,right: 20,left: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [BoxShadow(
                              color: Colors.grey,
                              offset:Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0
                          ),
                          ],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: InputDecoration(
                            hintText: 'Add a new todo Item',
                            border: InputBorder.none
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20,right:20 ),
                  child: ElevatedButton(
                    child: Text('+',style: TextStyle(fontSize: 40),),
                    onPressed: (){
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: tdBlue,
                        minimumSize: Size(60, 60),
                        elevation: 10
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(Todo todo){
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id){
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }
  void _addToDoItem(String todo){
    setState(() {
      todoList.add(Todo(id:DateTime.now().millisecondsSinceEpoch.toString(),todoText: todo));
    });
    _todoController.clear();
  }
  void _runFilter(String enteredKeyword){
    List<Todo> results = [];
    if(enteredKeyword.isEmpty){
      results = todoList;
    }else{
      results = todoList.where((element) => element.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      _foundTodo = results;
    });
  }
  Widget SearchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(
              minHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: 'Search'),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpg'),
            ),
          )
        ],
      ),
    );
  }
}
