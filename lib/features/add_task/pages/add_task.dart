import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/widgets/custom_auth_button.dart';
import 'package:frontend/features/auth/widgets/custom_auth_text_field.dart';
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
      body: Padding(
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
            CustomAuthButton(textButton: "Submit", onTap: () {}),
          ],
        ),
      ),
    );
  }
}
