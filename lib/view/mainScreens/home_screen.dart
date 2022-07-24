import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app/firebaseMethods/auth_service.dart';
import 'package:todo_app/resources/colors_manager.dart';

import '../../model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  Users? users;
  @override
  void initState() {
    // TODO: implement initState
    fetchUserDetails();
    super.initState();
  }

  void fetchUserDetails() async {
    Users user = await _authService.getUserDetails();
    setState(() {
      users = user;
    });
    print("Photo Url: ${users!.photoUrl}");
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
                    users?.photoUrl != null
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage("${users!.photoUrl}"),
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
                      "Hi, ${users?.firstName}",
                      style:
                          TextStyle(color: ColorManager.white, fontSize: 20.sp),
                    ),
                    SizedBox(
                      width: 120.w,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: ColorManager.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
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
            onPressed: () {},
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
