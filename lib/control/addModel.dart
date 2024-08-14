// ignore: file_names
import 'package:flutter/material.dart';
import 'package:models_tests_1/control/models.dart';

class TestForm extends StatefulWidget {
  const TestForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedOption;
  String? _selectedmember;
  // String? _selectedD;

  final List<String> _options = [
    'الصف التاسع',
    'الصف الثالث الثانوي',
    'قبول جامعي'
  ];
  final List<String> _ninth = [
    'القرأن',
    'التربية الاسلامية',
    "اللغة العربية",
    "اللغة الانجليزية",
    "العلوم",
    "الرياضيات",
    "الاجتماعيات"
  ];
  final List<String> _secondThired = [
    'القرأن',
    'التربية الاسلامية',
    "اللغة العربية",
    "اللغة الانجليزية",
    "التكامل والتفاضل",
    "الجبر والهندسة",
    "الأحياء ",
    'الفيزياء',
    "الكيمياء"
  ];
  final List<String> _university = [
    "جامعة إب",
    "جامعة صنعاء",
    "جامعة ذمار",
    "جامعة الحديدة",
    "جامعة حضرموت",
    "جامعة عدن",
    "جامعة تعز"
  ];
  //List<String> _faculty = ["الطب ", "طب أسنان","الصيدلة","المختبرات","الهندسة المدنية","هندسة الاتصالات","تقنية المعلومات","إدارة أعمال","محاسبة",];
  List<String> _select = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة نموذج اختبار'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('اختر أحد الخيارات :'),
                  listChick(_options),
                  const SizedBox(height: 16.0),
                  const Text(' إختر أحد الخيارات:'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _select.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 35,
                        child: RadioListTile(
                          title: Text(_select[index]),
                          value: _select[index],
                          groupValue: _selectedmember,
                          onChanged: (value) {
                            setState(() {
                              _selectedmember = value;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestFormPage(
                                        option: _selectedOption!,
                                        article: _selectedmember!,
                                      )),
                            );
                          }
                        },
                        child: const Text('إضافة النموذج'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listChick(List member) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: member.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 40,
          child: RadioListTile(
            title: Text(_options[index]),
            value: member[index],
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
                if (_selectedOption == 'الصف التاسع') {
                  _select = _ninth;
                } else if (_selectedOption == 'الصف الثالث الثانوي') {
                  _select = _secondThired;
                } else {
                  _select = _university;
                }
              });
            },
          ),
        );
      },
    );
  }
}
