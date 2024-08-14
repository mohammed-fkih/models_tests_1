import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FireBase {
  Future<QuerySnapshot<Map<String, dynamic>>> fetchDataFromFirebase(
      String collectionName) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(collectionName);
      return await collection.get();
    } catch (e) {
      print('An error occurred while fetching data from Firebase: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchDataFromFirebase11(
      String collection) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection(collection).get();

    // Convert the QuerySnapshot to a Map<String, dynamic>
    return snapshot.docs.first.data();
  }

  Future<void> addDataToFirebase(
      String collectionName, Map<String, dynamic> data) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(collectionName);
      await collection.add(data);
    } catch (e) {
      print('An error occurred while adding data to Firebase: $e');
    }
  }

  Future<void> updateDataInFirebase(String collectionName, String documentId,
      Map<String, dynamic> newData) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(collectionName);
      await collection.doc(documentId).update(newData);
    } catch (e) {
      print('An error occurred while updating data in Firebase: $e');
    }
  }

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>?> fetchDataFromFirebase_DoucmentID(
      String collectionName, String documentId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        // Document does not exist
        return null;
      }
    } catch (error) {
      // Error occurred while fetching data
      print('Error fetching data from Firebase: $error');
      return null;
    }
  }

  Future<void> updateDataInFirebase_listOfMap(String collectionName,
      String documentId, List<Map<String, dynamic>> newData) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(collectionName);
      await collection.doc(documentId).update(newData as Map<Object, Object?>);
    } catch (e) {
      print('An error occurred while updating data in Firebase: $e');
    }
  }

  Future<void> deleteDataFromFirebase(
      String collectionName, String documentId) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(collectionName);
      await collection.doc(documentId).delete();
    } catch (e) {
      print('An error occurred while deleting data from Firebase: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllDataFromFirebase(
      String collectionName) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(collectionName);
      QuerySnapshot<Map<String, dynamic>> snapshot = await collection.get();
      List<Map<String, dynamic>> dataMap = [];

      for (var doc in snapshot.docs) {
        dataMap.add(doc.data());
      }

      return dataMap;
    } catch (e) {
      print('An error occurred while fetching all data from Firebase: $e');
      return [];
    }
  }

  Future<String> uploadFile(File path) async {
    try {
      File file = path;
      String fileName = file.path.split('/').last;

      Reference storageReference =
          FirebaseStorage.instance.ref().child('files/$fileName');

      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
       print("تم  رفع الصورة --------------------------------------------");
      return downloadUrl;
      
    } catch (e) {
      print("خطأ في رفع الصورة --------------------------------------------");
      return "";
    }
  }

  Future<String> updateFile1(File path, String oldFileUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(oldFileUrl).delete();
      String newFileUrl = await uploadFile(path);
      return newFileUrl;
    } catch (e) {
      print('An error occurred while updating file in Firebase: $e');
      rethrow;
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(fileUrl).delete();
    } catch (e) {
      print('An error occurred while deleting file from Firebase: $e');
      rethrow;
    }
  }

  Future<void> addDataToFirebase_Id(
      String Collection, Map<String, dynamic> data) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection(Collection);
      DocumentReference<Map<String, dynamic>> documentReference =
          await collection.add(data);
      String documentId = documentReference.id;
      data['gID'] = documentId;

      await documentReference.update(data);
    } catch (e) {
      print('حدث خطأ أثناء إضافة البيانات إلى Firebase: $e');
      rethrow;
    }
  }

  Future<void> addDataToDocument(String collectionName, String documentId,
      Map<String, dynamic> data) async {
    try {
      // الوصول إلى مرجع لمجموعة الوثائق في Firebase
      final CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);

      // إضافة البيانات إلى المستند المحدد بواسطة معرّفه
      await collection.doc(documentId).set(data);
      print('تمت إضافة البيانات بنجاح');
    } catch (error) {
      // يمكنك إدراج معالجة الأخطاء هنا
      print('حدث خطأ أثناء إضافة البيانات: $error');
    }
  }

  Future<String> uploadVideoToFirebase(File videoFile) async {
    try {
      // إنشاء مرجع لمخزن Firebase
      final FirebaseStorage storage = FirebaseStorage.instance;

      // تعيين اسم الملف في Firebase Storage
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // إنشاء مسار مستودع Firebase لتخزين الملفات
      final Reference reference = storage.ref().child('videos/$fileName');

      // تحميل الملف إلى Firebase Storage
      final UploadTask uploadTask = reference.putFile(videoFile);

      // انتظر اكتمال عملية التحميل
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      // الحصول على URL الخاص بالملف المحمل
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // إرجاع الرابط (URL)
      return downloadUrl;
    } catch (error) {
      // يمكنك إدراج معالجة الأخطاء هنا
      print('حدث خطأ أثناء تحميل الملف: $error');
      return "";
    }
  }

  Future<String> updateFile(String path, String oldFileUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(oldFileUrl).delete();
      String newFileUrl = await uploadFile(path as File);
      return newFileUrl;
    } catch (e) {
      print('An error occurred while updating file in Firebase: $e');
      rethrow;
    }
  }
}
