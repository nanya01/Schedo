import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app/global/global.dart';
import 'package:todo_app/resources/colors_manager.dart';
import 'package:todo_app/widgets/progress_bar.dart';

import '../../model/task.dart';
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
  final HomeViewModel _homeViewModel = HomeViewModel();
  String category = "study";
  String? title;

  chooseCategory(String yourCategory) {
    setState(() {
      category = yourCategory;
    });
  }

  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    _homeViewModel.fetchUserDetails();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        userId = _homeViewModel.getUsers.uid;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    _homeViewModel.getUsers.photoUrl != null
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                "${_homeViewModel.getUsers.photoUrl}"),
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
                      "Hi, ${_homeViewModel.getUsers.firstName}",
                      style:
                          TextStyle(color: ColorManager.white, fontSize: 20.sp),
                    ),
                    SizedBox(
                      width: 85.w,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: ColorManager.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: ColorManager.white,
                      ),
                      onPressed: () {
                        firebaseAuth.signOut();
                      },
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
                            .doc(userId)
                            .collection("tasks")
                            .snapshots(),
                        builder: (context, snapshot) => snapshot.hasData
                            ? ListView.builder(
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
                                })
                            : circularProgress())
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .collection("tasks")
                            .where("category", isEqualTo: category)
                            .snapshots(),
                        builder: (context, snapshot) => snapshot.hasData
                            ? ListView.builder(
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
                                })
                            : circularProgress())
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
