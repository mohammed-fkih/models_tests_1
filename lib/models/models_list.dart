import 'package:flutter/material.dart';
import 'package:models_tests_1/models/exam.dart';
import 'package:models_tests_1/models/show_model.dart';

class ModelList extends StatefulWidget {
  const ModelList({super.key, required this.modelsList, required this.name});
  final List<Map<String, dynamic>> modelsList;
  final String name;

  @override
  State<ModelList> createState() => _HomeModelsState();
}

class _HomeModelsState extends State<ModelList> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 198, 223, 220),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(widget.name, style: const TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: widget.modelsList.isNotEmpty
              ? SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.modelsList.length,
                    itemBuilder: (context, index) {
                      final modelName = widget.modelsList[index]['modelName'];
                      final itemColor = Colors.primaries[index %
                          Colors.primaries
                              .length]; // اختيار لون العنصر بناءً على الفهرس
                      final itemNumber = index + 1; // تعيين رقم العنصر

                      return Container(
                        margin: const EdgeInsets.all(8.0), // هامش بين العناصر
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 138, 195,
                              189), // لون العنصر مع انعكاس الشفافية
                          borderRadius: BorderRadius.circular(
                              8.0), // إضافة حواف مستديرة للعنصر
                          border: Border.all(
                              color: itemColor,
                              width: 0.6), // إضافة إطار للعنصر
                        ),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      title: const Text("خيارات عرض النموذج"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const Text(
                                              "قم بإختيار أحد الخيارات التالية مع العلم أن الخيار الأول هو الأنسب إذا كنت مقبل على الإختبارات",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Exam(
                                                              model: widget
                                                                      .modelsList[
                                                                  index],
                                                            )),
                                                  );
                                                },
                                                child: const Text(
                                                  "عرض النموذج بدون الحل(محاكاة الاختبار)",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ShowModel(
                                                              model: widget
                                                                      .modelsList[
                                                                  index],
                                                            )),
                                                  );
                                                },
                                                child: const Text(
                                                  "عرض النموذج مع الحل",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "إلغاء",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          // ignore: unnecessary_null_comparison
                          title: modelName != null
                              ? Text(
                                  ' $modelName',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              : null,
                          leading: Text(
                            '$itemNumber',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("لا يوجد نماذج لهذه المادة حاليا !!!!!"),
                ),
        ),
      ),
    );
  }
}
