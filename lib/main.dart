import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_list/todo.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://wtqzqtnofaxczcpohdfw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind0cXpxdG5vZmF4Y3pjcG9oZGZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNTcwODcsImV4cCI6MjA0NjczMzA4N30.9q09jTP1QuyrDNmIxSoafAnFbaQ70rhQhBBda-c4zGY',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ToDoScreen());
  }
}
