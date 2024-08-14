// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:models_tests_1/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateACcount extends StatefulWidget {
  const CreateACcount({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateACcount> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGrade = 'الصف الثالث الثانوي';
  String _nameErrorText = '';
  String _phoneErrorText = '';
  late final String name;
  late final String phone;
  Future<void> _checkUserExists() async {
    name = _nameController.text;
    phone = _phoneController.text;

    if (name.isEmpty) {
      setState(() {
        _nameErrorText = 'يرجى إدخال اسم الطالب.';
      });
      return;
    }

    if (phone.isEmpty) {
      setState(() {
        _phoneErrorText = 'ادخل كلمة مرور مكونة من 4 أرقام او اكثر.';
      });
    } else {
      if (_validatePhoneNumber(phone)) {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('name', isEqualTo: name)
            .where('phone', isEqualTo: phone)
            .get();
        if (querySnapshot.size > 0) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('تنبيه'),
                content: const Text('يوجد حساب بنفس البيانات المدخلة.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('موافق'),
                  ),
                ],
              );
            },
          );
        } else {
          // try {
          //   await _auth.createUserWithEmailAndPassword(
          //     email: '${_nameController.text.trim()}@gmail.com',
          //     password: _phoneController.text,
          //   );
          //   // Registration successful, navigate to the next screen
          // } catch (e) {
          //   // ignore: use_build_context_synchronously
          //   ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text("يوجد خطأ في تسجيل حسابك")));
          // }

          await FirebaseFirestore.instance.collection('Users').add({
            'name': name,
            'phone': phone,
            'grade': _selectedGrade,
          });

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyTabPage()),
          );
        }
      } else {
        setState(() {
          _phoneErrorText = 'يرجى إدخال كلمة مرور مكونة من 4 أرقام او اكثر.';
        });
      }
    }
  }

  Future<void> _checkUserLogin() async {
    name = _nameController.text;
    phone = _phoneController.text;
    if (name.isEmpty) {
      setState(() {
        _nameErrorText = 'يرجى إدخال اسم الطالب.';
      });
      return;
    }

    if (phone.isEmpty) {
      setState(() {
        _phoneErrorText = 'يرجى إدخال كلمة المرور.';
      });
    } else {
      if (_validatePhoneNumber(phone)) {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('name', isEqualTo: name)
            .where('phone', isEqualTo: phone)
            .get();

        if (querySnapshot.size > 0) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyTabPage()),
          );
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: const Text('تنبيه'),
                    content: const Text('لا يوجد حساب مطابق.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('موافق'),
                      ),
                    ],
                  ));
            },
          );
        }
      } else {
        setState(() {
          _phoneErrorText = ' يرجى إدخال كلمة مرور مكونة من 4 أرقام او اكثر.';
        });
      }
    }
  }

  bool _validatePhoneNumber(String phone) {
    RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(phone) && phone.length >= 4;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('نماذج الاختبارات'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/exap2.png'),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الطالب ',
                        errorText: _nameErrorText,
                      ),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: ' كلمة المرور',
                        errorText: _phoneErrorText,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('أختار المستوى :'),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 'الصف التاسع',
                              groupValue: _selectedGrade,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGrade = value!;
                                });
                              },
                            ),
                            const Text('الصف التاسع'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 'الصف الثالث الثانوي',
                              groupValue: _selectedGrade,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGrade = value!;
                                });
                              },
                            ),
                            const Text('الصف الثالث الثانوي'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 'مقبل على الجامعة',
                              groupValue: _selectedGrade,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGrade = value!;
                                });
                              },
                            ),
                            const Text('مقبل على الجامعة'),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _checkUserExists();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn', true);
                            prefs.setString(
                              'name',
                              name,
                            );
                            prefs.setString('phone', phone);
                          },
                          child: const Text('طالب جديد'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _checkUserLogin();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn', true);
                            prefs.setString(
                              'name',
                              name,
                            );
                            prefs.setString('phone', phone);
                          },
                          child: const Text('تسجيل الدخول'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
