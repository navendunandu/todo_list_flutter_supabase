import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final supabase = Supabase.instance.client;

  Future<void> insertNote() async {
    try {
      // Inserting the note into Supabase
      await supabase.from('tbl_todo').insert({
        'note': _noteController.text,
      });
    } catch (e) {
      print('Exception during insert: $e');
    }
  }

  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
      ),
      body: Form(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(
                        labelText: "Task", border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: () {
                      insertNote();
                    },
                    child: Text("Add"))
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text("Task 1"),
                trailing: Icon(Icons.check),
              ),
              ListTile(
                title: Text("Task 2"),
                trailing: Icon(Icons.check),
              ),
              // Add more ListTiles as needed...
            ],
          )
        ],
      )),
    );
  }
}
