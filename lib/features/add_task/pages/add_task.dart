import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/widgets/custom_auth_button.dart';
import 'package:frontend/features/auth/widgets/custom_auth_text_field.dart';
import 'package:frontend/features/home/cubit/task_cubit.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => AddTaskPage());
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color selectedColor = Color.fromRGBO(246, 194, 222, 1);
  final taskRemoteResository = TaskRemoteRepository();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void createTask() async {
    await context.read<TaskCubit>().createTask(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          color: selectedColor,
          dueDate: selectedDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Task"), actions: [
        GestureDetector(
            onTap: () async {
              final _selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)));
              if (_selectedDate != null) {
                setState(() {
                  selectedDate = _selectedDate;
                });
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(DateFormat("MM-d-y").format(selectedDate))))
      ]),
      body: BlocConsumer<TaskCubit, TaskCubitState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.message,
                  style: TextStyle(color: Colors.white),
                )));
          } else if (state is TaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Task created successfully",
                  style: TextStyle(color: Colors.white),
                )));
            Navigator.pop(context);
            context.read<TaskCubit>().getTasks();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              spacing: 10,
              children: [
                //title textfield
                CustomAuthTextField(
                  hintText: "Title",
                  obscureText: false,
                  controller: titleController,
                ),
                //description textfield
                CustomAuthTextField(
                  controller: descriptionController,
                  hintText: "Description",
                  obscureText: false,
                  maxlines: 5,
                ),
                ColorPicker(
                    heading: const Text(
                      "Choose Color",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subheading: Text("Choose a different shade"),
                    color: selectedColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        selectedColor = color;
                      });
                    }),
                CustomAuthButton(
                    textButton: state is TaskLoading ? "Loading..." : "Submit",
                    onTap: createTask),
              ],
            ),
          );
        },
      ),
    );
  }
}
