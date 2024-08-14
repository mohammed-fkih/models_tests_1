import 'package:flutter/material.dart';
import 'package:models_tests_1/control/addAdvncedAndNews.dart';
import 'package:models_tests_1/control/addModel.dart';
import 'package:models_tests_1/control/showModels.dart';

class HomeConntrol extends StatefulWidget {
  const HomeConntrol({super.key});

  @override
  State<HomeConntrol> createState() => _HomePageState();
}

class _HomePageState extends State<HomeConntrol> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TestForm()),
                            );
                          },
                          child: const Text("إضافة نموذج",
                              style: TextStyle(fontSize: 17)))),
                  const SizedBox(
                    height: 15,
                  ),
                  FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ModelsListPage()),
                            );
                          },
                          child: const Text("عرض النماذج",
                              style: TextStyle(fontSize: 17)))),
                  const SizedBox(
                    height: 15,
                  ),
                  FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const StudentTipsFormScreen()),
                            );
                          },
                          child: const Text(
                            " نصائح وأخبار مهمة للطلاب",
                            style: TextStyle(fontSize: 17),
                          ))),
                  const SizedBox(
                    height: 15,
                  ),
                  // FractionallySizedBox(
                  //     widthFactor: 0.8,
                  //     child: ElevatedButton(
                  //         onPressed: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => const UserListPage()),
                  //           );
                  //         },
                  //         child: const Text(
                  //           "المستخدمون",
                  //           style: TextStyle(fontSize: 17),
                  //         )))
                ],
              ),
            ),
          ),
        ));
  }
}
