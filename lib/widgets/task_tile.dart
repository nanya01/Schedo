import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/global/global.dart';
import 'package:todo_app/view/mainScreens/edit_task.dart';

import '../model/task.dart';
import '../resources/colors_manager.dart';
import '../viewModel/home_viewmodel.dart';

class TaskTile extends StatefulWidget {
  final String docID;
  final Task task;
  const TaskTile({required this.task, required this.docID, Key? key})
      : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  IconData categoryIcon() {
    String category = widget.task.category;
    if (category == "study") {
      return Icons.school;
    } else if (category == "sport") {
      return Icons.emoji_events;
    } else if (category == "work") {
      return Icons.work;
    } else {
      return Icons.people;
    }
  }

  Color categoryIconColor() {
    String category = widget.task.category;
    if (category == "study") {
      return ColorManager.studyCategoryColor;
    } else if (category == "sport") {
      return ColorManager.sportsCategoryColor;
    } else if (category == "work") {
      return ColorManager.workCategoryColor;
    } else {
      return ColorManager.friendsCategoryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      decoration: const BoxDecoration(color: ColorManager.tileColor),
      child: Dismissible(
        confirmDismiss: (direction) {
          if (direction == DismissDirection.endToStart) {
            return showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    title: const Text("Are you sure you want to delete?"),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20),
                    actionsOverflowButtonSpacing: 20,
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Back")),
                      ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(firebaseAuth.currentUser!.uid)
                                .collection("tasks")
                                .doc(widget.docID)
                                .delete();

                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Task deleted",
                                backgroundColor: ColorManager.errorColor);
                          },
                          child: const Text("Ok")),
                    ],
                    content: const Text("Click ok to continue"),
                  );
                });
          } else {
            return Navigator.of(context).push(MaterialPageRoute(
                builder: (builder) => EditTask(docID: widget.docID)));
          }
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.green,
          child: const Icon(Icons.edit, color: Colors.white, size: 32),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          color: ColorManager.errorColor,
          child: const Icon(
            Icons.delete,
            color: ColorManager.white,
          ),
        ),
        key: ObjectKey(widget.docID),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            Fluttertoast.showToast(
                msg: "Task deleted", backgroundColor: ColorManager.errorColor);
          }
          if (direction == DismissDirection.startToEnd) {
            Fluttertoast.showToast(
                msg: "Task edited",
                backgroundColor: ColorManager.workCategoryColor);
          }
        },
        child: ListTile(
          leading: Checkbox(
            activeColor: ColorManager.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            value: widget.task.status,
            checkColor: Colors.green,
            onChanged: (bool? value) {
              setState(() async {
                widget.task.status = value!;
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(firebaseAuth.currentUser!.uid)
                    .collection("tasks")
                    .doc(widget.docID)
                    .update({"status": widget.task.status});

                Future.delayed(Duration.zero, () {
                  Provider.of<HomeViewModel>(context, listen: false)
                      .getNumberOfCompletedTasks();
                });
              });
              print("Value $value");
            },
          ),
          title: Text(widget.task.title,
              style: TextStyle(
                  color: widget.task.status ? null : ColorManager.white,
                  decoration:
                      widget.task.status ? TextDecoration.lineThrough : null)),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.watch_later,
                    color: widget.task.status ? null : ColorManager.white,
                  ),
                  Text(
                    widget.task.timeCreated,
                    style: TextStyle(
                      color: widget.task.status ? null : ColorManager.white,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    categoryIcon(),
                    color: widget.task.status ? null : categoryIconColor(),
                  ),
                  Text(
                    widget.task.category,
                    style: TextStyle(
                        color: widget.task.status ? null : ColorManager.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
