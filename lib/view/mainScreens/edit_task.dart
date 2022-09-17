import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../firebaseMethods/cloud_firestore_service.dart';
import '../../resources/colors_manager.dart';
import 'home_screen.dart';

class EditTask extends StatefulWidget {
  final String docID;
  const EditTask({required this.docID, Key? key}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final CloudFirestoreService _cloudFirestoreService = CloudFirestoreService();
  String? title;

  editTask() async {
    if (_formKey.currentState!.validate()) {
      await _cloudFirestoreService.updateTask(title!, widget.docID);
      Fluttertoast.showToast(msg: "Task added successfully");
      Future.delayed(Duration.zero, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const HomeScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Edit Task",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                  style: const TextStyle(color: ColorManager.white),
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: "Edit task"),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  validator: (val) =>
                      val!.isNotEmpty ? null : "This field cannot be empty"),
            ),
            SizedBox(
              height: 100.h,
            ),
            ElevatedButton(onPressed: editTask, child: const Text("Edit Task"))
          ],
        ),
      ),
    ));
  }
}
