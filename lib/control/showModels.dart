// ignore: file_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models_tests_1/dataBase/firebase_DataBase.dart';
import 'package:models_tests_1/control/editModel.dart';

class ModelsListPage extends StatefulWidget {
  // ignore: use_super_parameters
  const ModelsListPage({Key? key}) : super(key: key);

  @override
  State<ModelsListPage> createState() => _ModelsListPageState();
}

class _ModelsListPageState extends State<ModelsListPage> {
  int cont = 1;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة النماذج'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('models').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('حدث خطأ في الحصول على البيانات!');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Text('لا توجد بيانات.');
            }

            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic>? model =
                      document.data() as Map<String, dynamic>?;

                  if (model == null) {
                    return const SizedBox();
                  }
                  return ListTile(
                    title: Text(model['modelName'] ?? ''),
                    leading: Text(
                      (cont++).toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (contex) {
                              String modelName = model['modelName'];
                              String time = model['duration'];
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                    title: const Text("تعديل اسم النموذج "),
                                    content: SizedBox(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            initialValue: modelName,
                                            decoration: const InputDecoration(
                                              label: Text("اسم النموذج"),
                                            ),
                                            onChanged: (value) {
                                              modelName = value;
                                            },
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              label: Text("مدة حل النموذج"),
                                            ),
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            initialValue: time,
                                            onChanged: (value) {
                                              time = value;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () async {
                                            await FireBase()
                                                .updateDataInFirebase(
                                                    'models', document.id, {
                                              'modelName': modelName,
                                              'duration': time,
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: const Text("حفظ")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("الغاء"))
                                    ]),
                              );
                            });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModelDetailsPage(
                              model: model, modelId: document.id),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ModelDetailsPage extends StatefulWidget {
  final Map<String, dynamic> model;
  final String modelId;

  // ignore: use_super_parameters
  const ModelDetailsPage({Key? key, required this.model, required this.modelId})
      : super(key: key);

  @override
  State<ModelDetailsPage> createState() => _ModelDetailsPageState();
}

class _ModelDetailsPageState extends State<ModelDetailsPage> {
  final TextEditingController _answerController = TextEditingController();
  final List<String> _answers = [];
  final Map<String, dynamic> _questions = {};
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

  String? imagePath = "";
  // ignore: non_constant_identifier_names
  String? ImageUrl = "";
  String? pargraph = '';
  String? imagePath1= "";
  String? ImageUrl1 = "";


  // ignore: unused_element
  void _addAnswer() {
    setState(() {
      if (_answerController.text != "" && _answerController.text.isNotEmpty) {
        _answers.add(_answerController.text);
        _answerController.clear();
      }
    });
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

  @override
  void initState() {
    _questions.addAll(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return EditQuestion(
                    index: 0,
                    type: 1,
                    modelId: widget.modelId,
                    questions: widget.model,
                    context: context,
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(widget.model['modelName'] ?? ''),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(children: [
                    if(widget.model['imageurl2']!="")...[
                      Image.network(widget.model['imageurl2'])
                    ],
                    IconButton(onPressed: ()async{
                      imagePath1=await getImagePath();
                      if(imagePath1!=""){
                          ImageUrl1 = await FireBase().uploadFile(File(imagePath1!));
                      }
                      FireBase().updateDataInFirebase('models', widget.modelId, {
                        'imageurl2':ImageUrl1,
                      });
                    }, icon: const Icon(Icons.edit)),
                    
                    Text(widget.model['pargraph'] ?? ''),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return addPrograph();
                              });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ))
                  ]),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _questions['questions']?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic>? question =
                        _questions['questions'][index] as Map<String, dynamic>?;

                    if (question == null) {
                      return const SizedBox();
                    }

                    List<String> answers =
                        List<String>.from(question['answers'] ?? []);
                    int correctAnswerIndex =
                        question['correctAnswerIndex'] ?? -1;

                    return ListTile(
                      tileColor: const Color.fromARGB(255, 226, 218, 239),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['question'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (question['imageUrl'] != "" &&
                              question['imageUrl'] != null) ...[
                            Image.network(
                              question['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ]
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ignore: avoid_unnecessary_containers
                          Container(
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: List<Widget>.generate(answers.length,
                                  (index) {
                                // ignore: avoid_unnecessary_containers
                                return Container(
                                  child: Container(
                                    margin: const EdgeInsets.all(1),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: index,
                                          groupValue: correctAnswerIndex,
                                          onChanged: (value) {},
                                        ),
                                        Flexible(
                                          child: isLink(answers[index]) == true
                                              ? SizedBox(
                                                  height: 60,
                                                  width: 220,
                                                  child: Image.network(
                                                    answers[index],
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                              : Text(answers[index]),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return EditQuestion(
                                            type: 0,
                                            index: index,
                                            modelId: widget.modelId,
                                            questions: widget.model,
                                            context: context,
                                          );
                                        });
                                  });
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _deleteQuestion(context, index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      leading: Text(
                        (index + 1).toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('حذف النموذج'),
                      onPressed: () {
                        _deleteModel(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteQuestion(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف السؤال'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا السؤال؟'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('لا'),
            ),
            ElevatedButton(
              onPressed: () {
                _removeQuestion(index);
                Navigator.of(context).pop();
              },
              child: const Text('نعم'),
            ),
          ],
        );
      },
    );
  }

  void _deleteModel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف النموذج'),
          content: const Text('هل أنت متأكد أنك تريد حذف هذا النموذج؟'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('لا'),
            ),
            ElevatedButton(
              onPressed: () {
                _removeModel();
                Navigator.of(context).pop();
              },
              child: const Text('نعم'),
            ),
          ],
        );
      },
    );
  }

  void _removeQuestion(int index) {
    setState(() {
      widget.model['questions'].removeAt(index);

      FirebaseFirestore.instance
          .collection('models')
          .doc(widget.modelId)
          .set(_questions);
    });
  }

  void _removeModel() async {
    await FireBase().deleteDataFromFirebase('models', widget.modelId);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Widget addPrograph() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: AlertDialog(
          content: TextFormField(
              initialValue: widget.model['pargraph'],
              onChanged: (value) {
                pargraph = value;
              },
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
                      if (pargraph != "") {
                        FireBase().updateDataInFirebase(
                            'models', widget.modelId, {'pargraph': pargraph});
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
