import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure you have this import

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  ToDoListState createState() => ToDoListState();
}

class ToDoListState extends State<ToDoList> {
  final TextEditingController _taskController = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];

  void _addTask() {
    final taskText = _taskController.text.trim();
    if (taskText.isNotEmpty) {
      setState(() {
        _tasks
            .add({'text': taskText, 'completed': false, 'completedTime': null});
      });
      _taskController.clear();
    }
  }

  void _completeTask(int index) {
    setState(() {
      if (_tasks[index]['completed']) {
        _tasks[index]['completed'] = false;
        _tasks[index]['completedTime'] = null;
      } else {
        _tasks[index]['completed'] = true;
        _tasks[index]['completedTime'] = DateTime.now();
      }
    });
  }

  void _editTask(int index) {
    if (_tasks[index]['completed']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot edit a completed task.')),
      );
      return;
    }

    final taskText = _tasks[index]['text'];
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController editController = TextEditingController();
        editController.text = taskText;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A00E0), // Start color
                  Color(0xFFFEB47B), // End color
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit your task',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: editController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final newText = editController.text.trim();
                          if (newText.isNotEmpty) {
                            setState(() {
                              _tasks[index]['text'] = newText;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF00C6FF), // Start color
                                Color(0xFF8E2DE2), // End color
                              ],
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFEB47B), // Start color
              Color(0xFF4A00E0), // End color
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new task...',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Task'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      color:
                          task['completed'] ? Colors.grey[300] : Colors.white,
                      child: ListTile(
                        title: Text(
                          task['text'],
                          style: TextStyle(
                            decoration: task['completed']
                                ? TextDecoration.lineThrough
                                : null,
                            color:
                                task['completed'] ? Colors.grey : Colors.black,
                          ),
                        ),
                        subtitle: task['completed']
                            ? Text(
                                'Completed on ${DateFormat('yyyy-MM-dd – kk:mm').format(task['completedTime'])}',
                                style: const TextStyle(color: Colors.black),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.amber),
                              onPressed: () => _completeTask(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTask(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
