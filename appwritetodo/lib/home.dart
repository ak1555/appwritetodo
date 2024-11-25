import 'package:appwritetodo/Todo.dart';
import 'package:appwritetodo/services/appwrite.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = TextEditingController();
  late AppwriteServices _appwriteServices;
  List? _tasks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appwriteServices = AppwriteServices();
    _tasks = [];
    LoadTask();
  }

  Future<void> addtask() async {
    final task = _controller.text;

    if (task.isNotEmpty) {
      try {
        await _appwriteServices.addtask(task);
        _controller.clear();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> LoadTask() async {
    try {
      final tasks = await _appwriteServices.getTask();
      setState(() {
        _tasks = tasks.map((e) => Task.formDocument(e)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateTaskStatus(Task taskk) async {
    try {
      final updatetask =
          await _appwriteServices.updateTaskstatus(taskk.id, !taskk.isComplete);
      setState(() {
        taskk.isComplete != updatetask.data['completed'];
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TODOS",
          style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addtask();
                        LoadTask();
                      },
                      child: Text("SEND"))
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Expanded(
                child: ListView.builder(
              itemCount: _tasks!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Container(
                            height: 200,
                            width: 250,
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Are you Want to Delete?"),
                                  MaterialButton(
                                    onPressed: () {
                                      print("longpressed");
                                      final DocumentId = _tasks![index].id;
                                      print(DocumentId);
                                      _appwriteServices.delete(DocumentId);
                                      LoadTask();
                                    },
                                    child: Text("DELETE"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  trailing: IconButton(
                      onPressed: () {
                        _updateTaskStatus(_tasks![index]);
                      },
                      icon: Icon(Icons.check)),
                  title: Text(
                    _tasks![index].taskk.toString(),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
