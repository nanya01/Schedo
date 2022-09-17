import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global/global.dart';
import '../../model/task.dart';
import '../../widgets/completed_task_tile.dart';
import '../../widgets/progress_bar.dart';

class CompletedTasks extends StatelessWidget {
  const CompletedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
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
                        "Completed Tasks",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(firebaseAuth.currentUser!.uid)
                      .collection("tasks")
                      .where("status", isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Text("No network");
                      case ConnectionState.waiting:
                        return circularProgress();

                      default:
                        if (snapshot.data!.docs.isNotEmpty) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Task task = Task.fromJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);
                                return CompletedTaskTile(
                                  docID: snapshot.data!.docs[index].id,
                                  task: task,
                                );
                              });
                        } else {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              const Text(
                                "No task created",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  text: const TextSpan(
                                      text: "Click on the ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                      children: [
                                    TextSpan(
                                      text: " + ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xffFF9061),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "button to create a new task",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )
                                  ]))
                            ],
                          );
                        }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
