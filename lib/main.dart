import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> todoList = [];
  String todoItem = "";

  void _incrementTodoItem() {
    setState(() {
      todoList = [...todoList, todoItem];
    });
    todoItem = "";
    Navigator.pop(context);
  }

  void editTodoItem(int index, String text) {
    setState(() {
      todoList[index] = text;
    });
  }

  void _deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView( 
            children: todoList
                .asMap()
                .map((index, todoItem) => MapEntry(
                    index,
                    CardItem(
                        todoItem: todoItem,
                        index: index,
                        deleteTodoItem: _deleteTodoItem,
                        todoList: todoList,
                        editTodoItem: editTodoItem)))
                .values
                .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "add something bro";
                        }
                        return null;
                      },
                      decoration: (InputDecoration(hintText: 'Add some task')),
                      autofocus: true,
                      onChanged: (String text) {
                        setState(() {
                          todoItem = text;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: _incrementTodoItem,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CardItem extends StatefulWidget {
  final String? todoItem;
  final int index;
  final void Function(int) deleteTodoItem;
  final List<String> todoList;
  final void Function(int, String) editTodoItem;

  const CardItem(
      {super.key,
      this.todoItem,
      required this.index,
      required this.deleteTodoItem,
      required this.todoList,
      required this.editTodoItem});

  @override
  State<CardItem> createState() => _CardItem();
}

class _CardItem extends State<CardItem> {
  bool check = false;
  bool isEdited = false;

  String currentEdit = "";

  void handleClick(int item) {
    switch (item) {
      case 0:
        setState(() {
          isEdited = true;
        });
        break;
      case 1:
        widget.deleteTodoItem(widget.index);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: isEdited
            ? Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        autofocus: true,
                        initialValue: widget.todoList[widget.index],
                        onChanged: (String text) {
                          setState(() {
                            currentEdit = text;
                          });
                        },
                      )),
                  IconButton(
                      onPressed: () => setState(() {
                            widget.editTodoItem(widget.index, currentEdit);
                            isEdited = false;
                            currentEdit = "";
                          }),
                      icon: const Icon(Icons.check)),
                  IconButton(
                      onPressed: () => setState(() {
                            isEdited = false;
                            currentEdit = "";
                          }),
                      icon: const Icon(Icons.close))
                ],
              )
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Checkbox(
                      value: check,
                      onChanged: (bool? value) {
                        if (value != null) {
                          print(value);
                          setState(() {
                            check = value;
                          });
                        }
                      }),
                  Text('${widget.todoItem}',
                      style: check
                          ? TextStyle(decoration: TextDecoration.lineThrough)
                          : null),
                ]),
                PopupMenuButton<int>(
                    onSelected: (item) => handleClick(item),
                    itemBuilder: (context) => [
                          PopupMenuItem<int>(value: 0, child: Text('Edit')),
                          PopupMenuItem<int>(value: 1, child: Text('Delete'))
                        ]),
              ]));
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class Task {
//   String name;
//   bool isDone;
//
//   Task({required this.name, this.isDone = false});
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'To-Do List App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ToDoList(),
//     );
//   }
// }
//
// class ToDoList extends StatefulWidget {
//   @override
//   _ToDoListState createState() => _ToDoListState();
// }
//
// class _ToDoListState extends State<ToDoList> {
//   List<Task> tasks = [];
//   TextEditingController taskController = TextEditingController();
//   int? selectedIndex;
//
//   void addTask(String taskName) {
//     setState(() {
//       tasks.add(Task(name: taskName));
//       taskController.clear();
//     });
//   }
//
//   void editTask(int index, String newName) {
//     setState(() {
//       tasks[index].name = newName;
//       selectedIndex = null;
//       taskController.clear();
//     });
//   }
//
//   void removeTask(int index) {
//     setState(() {
//       tasks.removeAt(index);
//       selectedIndex = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('To-Do List'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return ListTile(
//                   title: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                         taskController.text = task.name;
//                       });
//                     },
//                     child: Text(
//                       task.name,
//                       style: TextStyle(
//                         decoration: task.isDone ? TextDecoration.lineThrough : null,
//                       ),
//                     ),
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       removeTask(index);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: taskController,
//               onSubmitted: (newTask) {
//                 if (selectedIndex == null) {
//                   if (newTask.isNotEmpty) {
//                     addTask(newTask);
//                   }
//                 } else {
//                   if (newTask.isNotEmpty) {
//                     editTask(selectedIndex!, newTask);
//                   }
//                 }
//               },
//               decoration: InputDecoration(
//                 hintText: selectedIndex == null ? 'Add a task...' : 'Edit task...',
//                 suffixIcon: IconButton(
//                   icon: Icon(selectedIndex == null ? Icons.add : Icons.edit),
//                   onPressed: () {
//                     if (selectedIndex == null) {
//                       final newTask = taskController.text;
//                       if (newTask.isNotEmpty) {
//                         addTask(newTask);
//                       }
//                     } else {
//                       final editedTask = taskController.text;
//                       if (editedTask.isNotEmpty) {
//                         editTask(selectedIndex!, editedTask);
//                       }
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
