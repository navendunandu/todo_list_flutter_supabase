import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  List<Map<String, dynamic>> _tasks = [];

  Future<void> fetchNotes() async {
    try {
      final response = await supabase.from('tbl_todo').select();

      setState(() {
        _tasks = response;
      });
    } catch (e) {
      print('Exception during fetch: $e');
    }
  }

  Future<void> insertNote() async {
    try {
      await supabase.from('tbl_todo').insert({
        'note': _noteController.text,
      });
      fetchNotes();
      _noteController.clear();
    } catch (e) {
      print('Exception during insert: $e');
    }
  }

  Future<void> deleteNotes(int noteId) async {
    try {
      await supabase.from('tbl_todo').delete().eq('id', noteId);
      fetchNotes();
    } catch (e) {
      print("Error Deleting: $e");
    }
  }

  Future<void> updateNote() async {
    try {
      await supabase
          .from('tbl_todo')
          .update({'note': _noteController.text}).eq('id', _editId);
      fetchNotes();
      _noteController.clear();
      _editId = 0;
    } catch (e) {
      print('Exception during update: $e');
    }
  }

  final TextEditingController _noteController = TextEditingController();

  int _editId = 0;

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
                      if (_editId != 0) {
                        updateNote();
                      } else {
                        insertNote();
                      }
                    },
                    child: Text("Add"))
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text("No tasks yet."))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return ListTile(
                        title: Text(task['note']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    _editId = task['id'];
                                    _noteController.text = task['note'];
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteNotes(task['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      )),
    );
  }
}
