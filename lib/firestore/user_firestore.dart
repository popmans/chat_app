import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<String?> insertNewAccont() async {
    try {
      final newDoc = await _userCollection.add({
        'name': '名無し',
        'image_path':
            'https://assets.st-note.com/production/uploads/images/58075596/profile_7d12166cbb91dd3ff25bbed3898bdd76.png?width=2000&height=2000&fit=bounds&format=jpg&quality=85 '
      });
      print('アカウント作成完了');
      return newDoc.id;
    } catch (e) {
      print('アカウント作成失敗===$e');
      return null;
    }
  }

  static Future<void> createUser() async {
    final myUid = await UserFirestore.insertNewAccont();
    if (myUid != null) {
      await RoomFirestore.createRoom(myUid);
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

  static Future<User?> fetchMyProfile() async {
    try {
      String uid = SharedPrefs.fetchUid()!;
      final myProfile = await _userCollection.doc(uid).get();
      User user = User(
          name: myProfile.data()!['name'],
          imagePath: myProfile.data()!['image_path'],
          uid: uid);
      return user;
    } catch (e) {
      print('自分のユーザ情報の取得失敗-----$e');
      return null;
    }
  }
}
