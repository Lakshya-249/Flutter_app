import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo_Template.dart';
import 'todo.dart';

void main() {
  runApp(const MaterialApp(
    home: TodoApp(),
  ));
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> todos = [];

  bool _showInputForm = false;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString('todos');
    if (todosJson != null) {
      final List<dynamic> decodedJson = json.decode(todosJson);
      setState(() {
        todos = decodedJson.map((item) => Todo.fromJson(item)).toList();
      });
    }
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTodos = json.encode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', encodedTodos);
  }

  void _toggleInputForm() {
    setState(() {
      _showInputForm = !_showInputForm;
    });
  }

  void _addTodo() {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      setState(() {
        todos.add(Todo(title: _titleController.text, desc: _descController.text,checked: false));
        _titleController.clear();
        _descController.clear();
        _showInputForm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Todo App",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Add your Todos by clicking on the Add Icon down below",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TodoWidget(
                todo: todos[index],
                delete: () {
                  setState(() {
                    todos.removeAt(index);
                  });
                },
                update: (String newTitle, String newDesc) {
                  setState(() {
                    todos[index].title = newTitle;
                    todos[index].desc = newDesc;
                  });
                },
                check: () {
                  setState(() {
                    todos[index].checked = !todos[index].checked;
                  });
                },
              );
            },
          ),
            if(_showInputForm)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[800],
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          hintText: 'Enter description',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addTodo,
                        child: const Text('Add Todo'),
                      ),
                    ],
                  )
                ),
              )
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleInputForm,
        child: Icon(_showInputForm ? Icons.close : Icons.add),
      ),
    );
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}



