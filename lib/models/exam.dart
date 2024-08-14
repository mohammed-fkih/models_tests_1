import 'package:flutter/material.dart';
import 'package:models_tests_1/dataBase/firebase_DataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exam extends StatefulWidget {
  final Map<String, dynamic> model;

  const Exam({super.key, required this.model});

  @override
  State<Exam> createState() => _ModelDetailsPageState();
}

class _ModelDetailsPageState extends State<Exam> {
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

  bool isShowResult = false;
  int minutes = 0;
  List<int> selectedAnswers = [];
  late int remainingMinutes;
  @override
  void initState() {
    _questions.addAll(widget.model);
    selectedAnswers =
        List<int>.filled(_questions['questions']?.length ?? 0, -1);
    minutes = int.parse(widget.model['duration']);
    remainingMinutes = minutes;
    startTimer();
    super.initState();
  }

  void startTimer() {
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          remainingMinutes--;
          if (remainingMinutes > 0) {
            if (mounted) {
              setState(() {
                startTimer();
              });
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: const Text('نتيجتك'),
                    content: Column(children: [
                      Text(
                          'حصلت على ${calculateScore()} من ${_questions['questions']?.length ?? 0}'),
                      Text(
                          "${(calculateScore() / _questions['questions']?.length) * 100}  %"),
                      Text(
                          "الوقت المستغرق في حل الاختبار : ${int.parse(widget.model['duration']) - remainingMinutes}")
                    ]),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: const Text('معرفة الأجابات الخاطئة'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: const Text('إعادة حل الاختبار مرة أخرى'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: const Text('حسنا'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        });
      }
    });
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    if (mounted) {
      setState(() {
        selectedAnswers[questionIndex] = answerIndex;
      });
    }
  }

  List errorAnswar = [];
  List correctAnswer = [];
  int calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions['questions']?.length; i++) {
      Map<String, dynamic>? question =
          _questions['questions'][i] as Map<String, dynamic>?;

      if (question == null) {
        continue;
      }

      int correctAnswerIndex = question['correctAnswerIndex'] ?? -1;
      correctAnswer.add(correctAnswerIndex);
      if (selectedAnswers[i] == correctAnswerIndex) {
        score++;
      } else {
        errorAnswar.add(i);
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          if (isShowResult) {
            return true;
          }
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Text(
                    'مغادرة الاختبار',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text(
                      ' يترتب على مغادرتك الاختبار حذف جميع الاجابات التي أجبتها '),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('مغادرة الإختبار'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(children: [
              Expanded(
                flex: 5,
                child: Text(
                  widget.model['modelName'] ?? '',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(children: [
                    const Icon(
                      Icons.timer_sharp,
                      color: Colors.white,
                    ),
                    Text(
                      "$remainingMinutes دقيقة",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )
                  ]))
            ]),
            backgroundColor: Colors.teal,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   if (widget.model['imageurl2'] != null) ...[
                    Container(margin: const EdgeInsets.symmetric(vertical: 6),
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: 
                         Image.network(widget.model['imageurl2'] ?? '',fit: BoxFit.cover,),),
                    
                  ],
                  if (widget.model['pargraph'] != null) ...[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(widget.model['pargraph'] ?? ''),
                    ),
                  ],
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions['questions']?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic>? question = _questions['questions']
                          [index] as Map<String, dynamic>?;

                      if (question == null) {
                        return const SizedBox();
                      }

                      List<String> answers =
                          List<String>.from(question['answers'] ?? []);
                      // ignore: unused_local_variable
                      int correctAnswerIndex =
                          question['correctAnswerIndex'] ?? -1;

                      return Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal, width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          tileColor: errorAnswar.contains(index)
                              ? Colors.red[200]
                              : Colors.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question['question'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              if (question['imageUrl'] != "" &&
                                  question['imageUrl'] != null) ...[
                                Image.network(
                                  question['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      child: const Center(
                                        child:
                                            Text("إتصل بالانترنت لتظهر الصورة"),
                                      ), // لون الخلفية البديلة
                                    );
                                  },
                                ),
                              ]
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                children: List<Widget>.generate(answers.length,
                                    (answerIndex) {
                                  return Container(
                                    margin: const EdgeInsets.all(1),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: answerIndex,
                                          groupValue: selectedAnswers[index],
                                          onChanged: isShowResult
                                              ? null
                                              : (value) {
                                                  selectAnswer(
                                                      index, value ?? -1);
                                                },
                                        ),
                                        Flexible(
                                          child: isLink(answers[answerIndex]) ==
                                                  false
                                              ? Text(
                                                  answers[answerIndex],
                                                  style: TextStyle(
                                                    color: errorAnswar
                                                            .contains(index)
                                                        ? correctAnswer[
                                                                    index] ==
                                                                answerIndex
                                                            ? Colors.green
                                                            : Colors.black
                                                        : Colors.black,
                                                  ),
                                                )
                                              : Container(
                                                  height: 60,
                                                  width: 230,
                                                  color: errorAnswar
                                                          .contains(index)
                                                      ? correctAnswer[index] ==
                                                              answerIndex
                                                          ? Colors.green
                                                          : Colors.red
                                                      : const Color.fromARGB(
                                                          255, 226, 218, 239),
                                                  child: Image.network(
                                                    answers[answerIndex],
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Container(
                                                        color: Colors.grey,
                                                        child: const Center(
                                                          child: Text(
                                                              "إتصل بالانترنت لتظهر الصورة"),
                                                        ), // لون الخلفية البديلة
                                                      );
                                                    },
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          leading: Text(
                            (index + 1).toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  title: const Text('نتيجتك'),
                                  content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'إجاباتك الصحيحة هي  ${calculateScore()} من ${_questions['questions']?.length ?? 0}',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                            " النسبة المئوية : ${(calculateScore() / _questions['questions']?.length) * 100}  %",
                                            style:
                                                const TextStyle(fontSize: 18)),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                            "الوقت المستغرق في الحل  : ${int.parse(widget.model['duration']) - remainingMinutes} دقيقة",
                                            style:
                                                const TextStyle(fontSize: 17)),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Divider(),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ]),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await FireBase()
                                            .addDataToFirebase('results', {
                                          'modelname': _questions['modelName'],
                                          'avrage': (calculateScore() /
                                                  _questions['questions']
                                                      ?.length) *
                                              100,
                                          'correctAnswar':
                                              '${calculateScore()} من ${_questions['questions']?.length ?? 0}',
                                          'time': int.parse(
                                                  widget.model['duration']) -
                                              remainingMinutes,
                                          "userName": prefs.getString('name'),
                                          "userPhone": prefs.getString('phone'),
                                          "createdAt": DateTime.now()
                                        });
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        if (mounted) {
                                          setState(() {
                                            isShowResult = true;
                                          });
                                        }
                                      },
                                      child: const Text('حفظ النتيجة'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            isShowResult = true;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('إعادة حل الاختبار'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        'تم حل النموذج إظهر النتيجة',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
