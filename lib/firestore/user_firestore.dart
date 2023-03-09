import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<String?> createUser() async{
   try{
    final newDoc = await _userCollection.add({
    'name'  :'名無し' ,
     'image_path':'https://assets.st-note.com/production/uploads/images/58075596/profile_7d12166cbb91dd3ff25bbed3898bdd76.png?width=2000&height=2000&fit=bounds&format=jpg&quality=85 '
     });
    print('アカウント作成完了');
    return newDoc.id;

   }catch(e) {
     print('アカウント作成失敗=====$e');
     return null;
   }
  }
  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async{
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs;
    } catch(e){
      print('ユーザ情報の取得失敗　==== $e');
      return null;
    }
  }
  }
