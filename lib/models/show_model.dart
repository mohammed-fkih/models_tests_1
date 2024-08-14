import 'package:flutter/material.dart';

class ShowModel extends StatefulWidget {
  final Map<String, dynamic> model;
  // ignore: use_super_parameters
  const ShowModel({Key? key, required this.model}) : super(key: key);

  @override
  State<ShowModel> createState() => _ModelDetailsPageState();
}

class _ModelDetailsPageState extends State<ShowModel> {
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
        appBar: AppBar(
          title: Text(
            widget.model['modelName'] ?? '',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
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
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child:  Image.network(widget.model['imageurl2'] ?? '',fit: BoxFit.contain,),),
                    
                  ],
                if (widget.model['pargraph'] != null) ...[
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Text(widget.model['pargraph'] ?? ''),
                  ),
                ],
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

                    return Container(
                      margin: const EdgeInsets.all(1), // هامش بين العناصر
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 0.5),
                        borderRadius: BorderRadius.circular(
                            10.0), // إضافة حواف مستديرة للعنصر
                      ),
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question['question'] ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (question['imageUrl'] != "" &&
                                question['imageUrl'] != null) ...[
                              Image.network(
                                question['imageUrl'],
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
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
                            // ignore: avoid_unnecessary_containers
                            Container(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: List<Widget>.generate(answers.length,
                                    (index) {
                                  // ignore: avoid_unnecessary_containers
                                  return Container(
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
                                            child: isLink(answers[index])
                                                ? SizedBox(
                                                    height: 60,
                                                    width: 220,
                                                    child: Image.network(
                                                      answers[index],
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
                                                  )
                                                : Text(answers[index])),
                                      ],
                                    ),
                                  );
                                }),
                              ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
