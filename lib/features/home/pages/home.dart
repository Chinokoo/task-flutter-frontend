import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/features/add_task/pages/add_task.dart';
import 'package:frontend/features/home/cubit/task_cubit.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => HomePage());
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    context.read<TaskCubit>().getTasks();
    super.initState();
  }

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
      body: BlocBuilder<TaskCubit, TaskCubitState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is TaskError) {
            return Center(
                child:
                    Text(state.message, style: TextStyle(color: Colors.red)));
          }
          if (state is GetTaskSuccess) {
            final tasks = state.tasks
                .where(
                  (elem) =>
                      DateFormat('d').format(elem.dueDate) ==
                          DateFormat('d').format(selectedDate) &&
                      selectedDate.month == elem.dueDate.month &&
                      selectedDate.year == elem.dueDate.year,
                )
                .toList();

            return Column(
              children: [
                DateSelector(
                  selectedDate: selectedDate,
                  onTap: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: hexToColor(task.hexColor),
                                headerText: task.title,
                                descriptionText: task.description,
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: hexToColor(task.hexColor),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                DateFormat.jm().format(task.dueDate),
                                style: TextStyle(fontSize: 17),
                              ),
                            )
                          ],
                        );
                      }),
                ),
              ],
            );
          }
          return Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
