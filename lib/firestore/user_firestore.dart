import 'package:chat_app/model/user.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<String?> insertNewAccount() async {
    try {
      final newDoc =
          await _userCollection.add({'joined_groups': [], 'name': ''});
      print('アカウント作成完了');
      return newDoc.id;
    } catch (e) {
      print('アカウント作成失敗===$e');
      return null;
    }
  }

  static Future<void> createUser() async {
    final myUid = await UserFirestore.insertNewAccount();
    if (myUid != null) {
      // await RoomFirestore.createRoom(myUid);
      await SharedPrefs.setUid(myUid);
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs;
    } catch (e) {
      print('ユーザ情報の取得失敗　==== $e');
      return null;
    }
  }

  static Future<User?> fetchProfile(String uid) async {
    try {
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(name: snapshot.data()!['name'], uid: uid);
      return user;
    } catch (e) {
      print('自分のユーザ情報の取得失敗-----$e');
      return null;
    }
  }

  static Future<void> updateUserName(String uid, String name) async {
    try {
      await _userCollection.doc(uid).update({'name': name});
    } catch (e) {
      print('自分のユーザ情報の取得失敗-----$e');
      return null;
    }
  }
}
