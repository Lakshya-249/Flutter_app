import 'package:flutter/material.dart';
import 'todo.dart';

class TodoWidget extends StatefulWidget {

  final Todo todo;
  final Function? delete;
  final Function(String, String)? update;
  final Function check;

  const TodoWidget({super.key, required this.todo,this.delete,this.update, required this.check});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  final List<String> _items = ["Delete", "Update", "Complete"];

  void _showUpdateDialog() {
    final titleController = TextEditingController(text: widget.todo.title);
    final descController = TextEditingController(text: widget.todo.desc);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                if (widget.update != null) {
                  widget.update!(titleController.text, descController.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(18, 20, 16, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if(widget.todo.checked)
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.todo.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(widget.todo.desc,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 95.0,
              child: DropdownButton(
                items: _items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? val) {
                  if(val == "Delete"){
                    widget.delete!();
                  }else if(val == "Complete" || val == "Uncheck"){
                    setState(() {
                      _items[2] = _items[2] == "Complete"?"Uncheck":"Complete";
                    });
                    widget.check();
                  }else{
                    _showUpdateDialog();
                  }
                },
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            )
          ],

        ),
      ),
    );
  }
}