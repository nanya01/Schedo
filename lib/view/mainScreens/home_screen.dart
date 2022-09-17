import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/global/global.dart';
import 'package:todo_app/resources/colors_manager.dart';
import 'package:todo_app/view/authentication/login.dart';
import 'package:todo_app/view/mainScreens/completed_tasks.dart';
import 'package:todo_app/widgets/progress_bar.dart';

import '../../model/task.dart';
import '../../model/user.dart';
import '../../viewModel/home_viewmodel.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/task_tile.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = "all";
  final ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;

  chooseCategory(String yourCategory) {
    setState(() {
      category = yourCategory;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloatingButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloatingButton();
      }
    });
  }

  void showFloatingButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloatingButton() {
    setState(() {
      _show = false;
    });
  }

  getCompletedTasksLength(BuildContext context) {
    Provider.of<HomeViewModel>(context, listen: false)
        .getNumberOfCompletedTasks();
  }

  @override
  void initState() {
    // TODO: implement initState
    getCompletedTasksLength(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Users users = Provider.of<HomeViewModel>(context).getUsers;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    users.photoUrl != null
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage("${users.photoUrl}"),
                          )
                        : CircleAvatar(
                            backgroundColor:
                                const Color.fromRGBO(255, 255, 255, 1),
                            radius: 25,
                            child: SvgPicture.asset(
                              'assets/images/orange.svg',
                              height: 27,
                              width: 27,
                            ),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Hi, ${users.firstName}",
                      style:
                          TextStyle(color: ColorManager.white, fontSize: 20.sp),
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => const CompletedTasks()));
                      },
                      child: Stack(
                        children: [
                          const Icon(
                            Icons.task,
                            color: ColorManager.white,
                            size: 32,
                          ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 10,
                                child: Consumer<HomeViewModel>(
                                  builder: (context, viewModel, _) {
                                    return Text(viewModel
                                        .getCompletedTasksLength
                                        .toString());
                                  },
                                )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: ColorManager.white,
                        ),
                        onPressed: () {
                          firebaseAuth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const LoginScreen()));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryTile(
                        backgroundColor:
                            category == "all" ? ColorManager.blue : null,
                        title: "All",
                        onPressed: () => chooseCategory("all"),
                      ),
                      CategoryTile(
                        backgroundColor:
                            category == "study" ? ColorManager.blue : null,
                        title: "Study",
                        onPressed: () => chooseCategory("study"),
                        iconData: Icons.school,
                        iconDataColor: ColorManager.studyCategoryColor,
                      ),
                      CategoryTile(
                        backgroundColor:
                            category == "sport" ? ColorManager.blue : null,
                        title: "Sport",
                        onPressed: () => chooseCategory("sport"),
                        iconData: Icons.emoji_events,
                        iconDataColor: ColorManager.sportsCategoryColor,
                      ),
                      CategoryTile(
                        backgroundColor:
                            category == "work" ? ColorManager.blue : null,
                        title: "Work",
                        onPressed: () => chooseCategory("work"),
                        iconData: Icons.work,
                        iconDataColor: ColorManager.workCategoryColor,
                      ),
                      CategoryTile(
                        backgroundColor:
                            category == "friends" ? ColorManager.blue : null,
                        title: "Friends",
                        onPressed: () => chooseCategory("friends"),
                        iconData: Icons.people,
                        iconDataColor: ColorManager.friendsCategoryColor,
                      ),
                    ],
                  ),
                ),
                category == "all"
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(firebaseAuth.currentUser!.uid)
                            .collection("tasks")
                            .where("status", isEqualTo: false)
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
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Task task = Task.fromJson(
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>);
                                      return TaskTile(
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
                                                fontSize: 16,
                                                color: Colors.white),
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
                                                fontSize: 16,
                                                color: Colors.white),
                                          )
                                        ]))
                                  ],
                                );
                              }
                          }
                        })
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(firebaseAuth.currentUser!.uid)
                            .collection("tasks")
                            .where("category", isEqualTo: category)
                            .where("status", isEqualTo: false)
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
                                    controller: _scrollController,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Task task = Task.fromJson(
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>);
                                      return TaskTile(
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
                                                fontSize: 16,
                                                color: Colors.white),
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
                                                fontSize: 16,
                                                color: Colors.white),
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
        floatingActionButton: Visibility(
          visible: _show,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffFD5454),
                    Color(0xffFF9061),
                    Color(0xffFFBA7B),
                    Color(0xffFFCEC3),
                  ],
                ),
                border: Border.all()),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const AddTaskScreen()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
