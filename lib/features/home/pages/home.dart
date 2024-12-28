import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/features/add_task/pages/add_task.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => HomePage());
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          DateSelector(),
          Row(
            children: [
              Expanded(
                child: TaskCard(
                    color: const Color.fromRGBO(246, 194, 222, 1),
                    headerText: "Hello",
                    descriptionText:
                        "This is a sample task, This is a sample taskThis is a sample taskThis is a sample taskThis is a sample taskThis is a sample taskThis is a sample taskThis is a sample task"),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: strengthenColor(Color.fromRGBO(246, 194, 222, 1), 1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("10:00AM", style: TextStyle(fontSize: 17)),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TaskCard(
                    color: const Color.fromRGBO(246, 194, 222, 1),
                    headerText: "Hello",
                    descriptionText: "This is a sample task"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
