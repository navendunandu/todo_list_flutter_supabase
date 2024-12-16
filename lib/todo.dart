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
                        trailing: const Icon(Icons.check),
                      );
                    },
                  ),
          ),
        ],
      )),
    );
  }
}
