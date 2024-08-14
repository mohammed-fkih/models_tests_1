import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models_tests_1/dataBase/firebase_DataBase.dart';

// ignore: must_be_immutable
class EditQuestion extends StatefulWidget {
  const EditQuestion(
      {super.key,
      required this.index,
      required this.modelId,
      required this.questions,
      required this.context,
      required this.type});
  final int index;
  final String modelId;
  final int type;
  final Map<String, dynamic> questions;
  final BuildContext context;
  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  List<String> _answers = [];
  int? _correctAnswerIndex;
  Map<String, dynamic> _questions = {};
  Map<String, dynamic>? question;
  String? imagePath = "";
  String? imageUrl = "";
  String? imagePath1 = "";
  String? imageUrl1 = "";
   String? imagePath2 = "";
  String? imageUrl2 = "";

  @override
  void initState() {
    setData();
    super.initState();
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

  setData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('models')
        .doc(widget.modelId)
        .get();

    if (snapshot.exists) {
      _questions = (snapshot.data() as Map<String, dynamic>);
    }

    if (widget.type == 0) {
      question = _questions['questions'][widget.index] as Map<String, dynamic>?;
      _questionController.text = question!['question'];
      _answers = List<String>.from(question!['answers']);
      _correctAnswerIndex = question!['correctAnswerIndex'];
    } else {
      question = _questions['questions'][widget.index] as Map<String, dynamic>?;
      _questionController.text = "";
      _answers = [];

      _correctAnswerIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('تعديل السؤال'),
        content: SizedBox(
          width: MediaQuery.of(context)
              .size
              .width, // Set a specific width // Set a specific height
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'السؤال'),
                            controller: _questionController,
                            onChanged: (value) {
                              _questionController.text = value;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () async {
                              imagePath = await getImagePath();
                              if (imagePath != null &&
                                  imagePath!.isNotEmpty &&
                                  imagePath != "") {
                                imageUrl = await FireBase()
                                    .uploadFile(File(imagePath!));
                              }
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
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _answers.clear();
                          });
                        },
                        child: const Text("حذف جميع الإجابات")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'إضافة إجابة'),
                            controller: _answerController,
                            onChanged: (value) {
                              setState(() {
                                _answerController.text = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: () async {
                                imagePath1 = await getImagePath();
                                if (imagePath1 != null &&
                                    imagePath1!.isNotEmpty &&
                                    imagePath1 != "") {
                                  imageUrl1 = await FireBase()
                                      .uploadFile(File(imagePath1!));
                                }
                              },
                              icon: const Icon(
                                Icons.add_photo_alternate_rounded,
                                color: Colors.blue,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _addAnswer();
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          widget.type == 0
              ? ElevatedButton(
                  onPressed: () async {
                    await _updateQuestion();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text('تعديل'),
                )
              : ElevatedButton(
                  onPressed: () async {
                    await _addQuestion();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Text('إظافة سؤال '),
                ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  _updateQuestion() async {
    question!['question'] = _questionController.text;
    question!['answers'] = _answers;
    question!['correctAnswerIndex'] = _correctAnswerIndex;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      question!['imageUrl'] = imageUrl;
    }

    _questions['questions'][widget.index] = question;
    await FirebaseFirestore.instance
        .collection('models')
        .doc(widget.modelId)
        .set(_questions);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تعديل السؤال بنجاح'),
      ),
    );
    setState(() {});
  }

  _addQuestion() async {
    // ignore: unnecessary_null_comparison
    if (_questions != null) {
      Map<String, dynamic> newQuestion = {
        'question': _questionController.text,
        'answers': _answers,
        'correctAnswerIndex': _correctAnswerIndex,
      };

      if (imageUrl != null && imageUrl!.isNotEmpty) {
        newQuestion['imageUrl'] = imageUrl;
      }

      if (_questions['questions'] != null) {
        _questions['questions'].add(newQuestion);

        await FirebaseFirestore.instance
            .collection('models')
            .doc(widget.modelId)
            .set(_questions);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت إضافة السؤال بنجاح'),
          ),
        );

        setState(() {});
      }
    }
  }

  void _addAnswer() async {
    if (_answerController.text != "" && _answerController.text.isNotEmpty) {
      _answers.add(_answerController.text);
      _answerController.clear();
    } else if (imageUrl1 != "") {
      _answers.add(imageUrl1!);
      imageUrl1 = "";
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

  Future<String?> getImagePath() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    }

    return null;
  }
}
