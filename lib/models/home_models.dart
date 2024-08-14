import 'package:flutter/material.dart';
import 'package:models_tests_1/models/models_list.dart';

class HomeModels extends StatefulWidget {
  const HomeModels(
      {super.key, required this.modelsList, required this.article});
  final List<Map<String, dynamic>> modelsList;
  final List<String> article;

  @override
  State<HomeModels> createState() => _HomeModelsState();
}

class _HomeModelsState extends State<HomeModels> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 198, 223, 220),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            "المواد ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            // height: 800,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.article.length,
              itemBuilder: (context, index) {
                final modelName = widget.article[index];
                final itemColor = Colors.primaries[index %
                    Colors.primaries
                        .length]; // اختيار لون العنصر بناءً على الفهرس
                final itemNumber = index + 1;

                List<Map<String, dynamic>> option1List = [];
                for (var element in widget.modelsList) {
                  if (element['article'] == modelName) {
                    option1List.add(element);
                  }
                }

                return Container(
                  margin: const EdgeInsets.all(8.0), // هامش بين العناصر
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 138, 195, 189), // لون العنصر مع انعكاس الشفافية
                    borderRadius:
                        BorderRadius.circular(8.0), // إضافة حواف مستديرة للعنصر
                    border: Border.all(
                        color: itemColor, width: 0.6), // إضافة إطار للعنصر
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModelList(
                                  modelsList: option1List,
                                  name: modelName,
                                )),
                      );
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
          ),
        ),
      ),
    );
  }
}
