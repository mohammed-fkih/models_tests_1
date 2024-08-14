import 'package:flutter/material.dart';
import 'package:models_tests_1/control/homeControl.dart';
import 'package:models_tests_1/models/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTabPage extends StatefulWidget {
  const MyTabPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyTabPageState createState() => _MyTabPageState();
}

class _MyTabPageState extends State<MyTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            'نماذج الاختبارات',
            style: TextStyle(color: Colors.white),
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         // _logout();
          //       },
          //       icon: const Icon(
          //         Icons.more_vert_outlined,
          //         color: Colors.white,
          //       ))
          // ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            tabs: const [
              Tab(
                text: 'النماذج',
              ),
              Tab(text: 'التحكم'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            Home(),
            HomeConntrol(),
          ],
        ),
      ),
    );
  }
}

class ModelsTab extends StatelessWidget {
  const ModelsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('شاشة النماذج'),
    );
  }
}
