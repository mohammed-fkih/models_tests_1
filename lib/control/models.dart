import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models_tests_1/dataBase/firebase_DataBase.dart';
// ignore: depend_on_referenced_packages
class TestFormPage extends StatefulWidget {
  const TestFormPage({super.key, required this.article, required this.option});
  final String option;
  final String article;
  @override
  // ignore: library_private_types_in_public_api
  _TestFormPageState createState() => _TestFormPageState();
}

class _TestFormPageState extends State<TestFormPage> {
  bool _isSaving = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _paragraphController = TextEditingController();
  final List<String> _answers = [];
  int? _correctAnswerIndex;
  final List<Map<String, dynamic>> _questions = [];
  String? imagePath = "";
  String? imagePath1 = "";
    String? imagePath2 = "";
  // ignore: non_constant_identifier_names
  String? ImageUrl = "";
    // ignore: non_constant_identifier_names
    String? ImageUrl2 = "";
  
  // ignore: non_constant_identifier_names
  String? ImageUrl1 = "";
  String? pargraph;
  bool isImage = false;

  void _addAnswer() async {
    if (_answerController.text != "" && _answerController.text.isNotEmpty) {
      _answers.add(_answerController.text);
      _answerController.clear();
    } else if (ImageUrl1 != "") {
      _answers.add(ImageUrl1!);
      ImageUrl1 = "";
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن أن تكون الاجابة فارغة'),
          duration: Duration(seconds: 3), // تحديد المدة الزمنية
        ),
      );
    }
    setState(() {});
  }

  bool isLink(String text) {
    // Check if the text is a Firebase storage image URL
    if (text.startsWith('http')) {
      return true;
    }

    // Regex to match a link
    final regex = RegExp(
        r'((http|https)://)*(www\.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%"._\\+~#?&//=]*)');

    // Check if the text matches the regex
    return regex.hasMatch(text);
  }

  void _saveQuestion() {
    setState(() {
      if (_questionController.text.isEmpty ||
          _answers.isEmpty ||
          _correctAnswerIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى ملء جميع الحقول المطلوبة'),
          ),
        );
        return;
      }
      Map<String, dynamic> question = {
        'question': _questionController.text,
        'answers': List<String>.from(_answers),
        'correctAnswerIndex': _correctAnswerIndex,
        'imageUrl': ImageUrl,
      };
      _questions.add(question);
      _questionController.clear();
      _answerController.clear();
      _answers.clear();
      _correctAnswerIndex = null;
      imagePath = "";
      ImageUrl = "";
      setState(() {});
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      // ignore: unnecessary_null_comparison
      if (ImageUrl != "" && ImageUrl! != null) {
        FireBase().deleteFile(ImageUrl!);
      }
    });
  }

  void _saveModel() async {
    if (_modelNameController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول المطلوبة'),
        ),
      );
      _isSaving = false;
      return;
    }

    Map<String, dynamic> model = {
      'option': widget.option,
      'article': widget.article,
      'modelName': _modelNameController.text,
      'duration': _durationController.text,
      'questions': _questions,
      'imageurl2':ImageUrl2,
      'pargraph': pargraph,
      'createdAt': DateTime.now()
    };

    DocumentReference docRef = await _firestore.collection('models').add(model);

    for (int i = 0; i < _questions.length; i++) {
      Map<String, dynamic> question = _questions[i];
      List<String> answers = question['answers'];
      int correctAnswerIndex = question['correctAnswerIndex'];
      DocumentReference questionRef =
          await docRef.collection('questions').add(question);

      for (int j = 0; j < answers.length; j++) {
        Map<String, dynamic> answer = {
          'answer': answers[j],
          'isCorrect': (j == correctAnswerIndex),
        };
        await questionRef.update({
          'answers': FieldValue.arrayUnion([answer])
        });
      }
    }

    setState(() {
      _modelNameController.clear();
      _durationController.clear();
      _questions.clear();
      _isSaving = false;
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ النموذج بنجاح'),
      ),
    );
  }

  Future<String?> getImagePath() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      
      return pickedImage.path;
    } else {
      return null;
    }
  }

  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      // ignore: deprecated_member_use
      child:WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Text(
                    'مغادرة النموذج',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text(
                      ' يترتب على مغادرتك الاختبار حذف جميع البيانات التي ادخلتها قم بحفظ النموذج لتجنب فقدان البيانات '),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('مغادرة النموذج'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      
    child:   Scaffold(
        appBar: AppBar(
          title: const Text('إضافة نموذج اختبار'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 2 / 3.3,
                      child: TextField(
                        decoration:
                            const InputDecoration(labelText: 'اسم النموذج'),
                        controller: _modelNameController,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 1 / 4,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'مدة حل النموذج'),
                        controller: _durationController,
                      ),
                    )
                  ],
                ),
                if (imagePath2 != null &&
                            imagePath2!.isNotEmpty &&
                            imagePath2 != "") ...[
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: Image.file(
                              File(imagePath2!),
                              fit: BoxFit.cover,
                            ),
                          )
                        ] else ...[
                          Container(),
                        ],
                
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return addPrograph();
                            });
                      },
                      child: const Text("إظافة قطعة نصية")),
                      ElevatedButton(
  onPressed: () async {
    imagePath2 = await getImagePath();
    setState(() {
      print("------------------------------------$imagePath2");
    });

    if (imagePath2 != null && imagePath2 != "") {
      ImageUrl2 = await FireBase().uploadFile(File(imagePath2!));
    }

    setState(() {

    });
  },
  child: const Text("اضافة صورة في راس النموذج"),
)
                ]),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
         
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 7 / 10,
                              child: TextField(
                                decoration:
                                    const InputDecoration(labelText: 'السؤال'),
                                controller: _questionController,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 10,
                              child: IconButton(
                                onPressed: () async {
                                  imagePath = await getImagePath();
                                  if (imagePath != null &&
                                      imagePath!.isNotEmpty &&
                                      imagePath != "") {
                                    isImage = true;
                                    ImageUrl = await FireBase()
                                        .uploadFile(File(imagePath!));
                                  }
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.add_photo_alternate_sharp,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (imagePath != null &&
                            imagePath!.isNotEmpty &&
                            imagePath != "") ...[
                          Image.file(
                            File(imagePath!),
                          )
                        ] else ...[
                          Container(),
                        ],
                        const SizedBox(height: 20),
                        const Text('الإجابات:'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _answers.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(1),
                              child: Row(
                                children: [
                                  Radio(
                                    value: index,
                                    groupValue: _correctAnswerIndex,
                                    onChanged: (value) {
                                      setState(() {
                                        _correctAnswerIndex = value;
                                      });
                                    },
                                  ),
                                  Flexible(
                                      child: isLink(_answers[index]) == false
                                          ? Text(_answers[index])
                                          : SizedBox(
                                              height: 60,
                                              width: 220,
                                              child: Image.network(
                                                _answers[index],
                                                fit: BoxFit.contain,
                                              ),
                                            )),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 2,
                              child: TextField(
                                decoration: const InputDecoration(
                                    labelText: 'إضافة إجابة'),
                                controller: _answerController,
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  imagePath1 = await getImagePath();
                                  if (imagePath1 != null &&
                                      imagePath1!.isNotEmpty &&
                                      imagePath1 != "") {
                                    ImageUrl1 = await FireBase()
                                        .uploadFile(File(imagePath1!));
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_photo_alternate_rounded,
                                  color: Colors.blue,
                                )),
                            ElevatedButton(
                              onPressed: () {
                                _addAnswer();
                                setState(() {});
                              },
                              child: const Text('إضافة'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _saveQuestion();
                              },
                              child: const Text('حفظ السؤال'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                const Text('الأسئلة المضافة:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(_questions[index]['question']),
                        leading: Text(
                          (index + 1).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteQuestion(index),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              setState(() {
                                _isSaving = true;
                              });
                              _saveModel();
                            },
                      child: _isSaving
                          ? const CircularProgressIndicator()
                          : const Text('حفظ النموذج'),
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

  Widget addPrograph() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: AlertDialog(
          content: TextFormField(
              controller: _paragraphController,
              maxLines: 15,
              decoration: const InputDecoration(
                label: Text("ادخل القطعة النصية"),
              )),
          title: const Text("القطعة النصية"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // ignore: unnecessary_null_comparison
                      if (_paragraphController.text != null &&
                          _paragraphController.text != "") {
                        pargraph = _paragraphController.text;
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('يجب أن لا يكون الحقل فارغ'),
                          ),
                        );
                      }
                    },
                    child: const Text("حفظ")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("إلغاء"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
