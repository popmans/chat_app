import 'package:chat_app/firestore/user_firestore.dart';
import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//ここは個人トークルームなので、「warikan_app」には、必要のないdart.fileかもしれない
//flutterlub_チャットアプリ作成_「アカウント作成時に他のユーザとのトークルームを作成

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _roomCollection = _firebaseFirestoreInstance.collection('room');

  static Future<void> createRoom(String myUid) async {
    try {
      final docs = await UserFirestore.fetchUsers();
      if (docs == null) return;
      docs.forEach((doc) async {
        if (doc.id == myUid) return;
        await _roomCollection.add({
          'joined_user_ids': [doc.id, myUid],
          'created_time': Timestamp.now()
        });
      });
    } catch (e) {
      print('ルームの作成失敗===== $e');
    }
  }

  static Future<void> fetchJoinedRooms() async {
    try {
      String myUid = SharedPrefs.fetchUid()!;
      //print(myUid);
      final snapshot = await _roomCollection
          .where('joined_user_ids ', arrayContains: myUid)
          .get();
      List<TalkRoom> talkRooms = [];
      for (var doc in snapshot.docs) {
        List<dynamic> userIds = doc.data()['joined_user_ids'];
        //print(userIds);
        late String talkUserUid;
        for (var id in userIds) {
          if (id == myUid) continue;
          talkUserUid = id;
        }
        //print(talkUserUid);
        User? talkUser = await UserFirestore.fetchProfile(talkUserUid);
        //print(talkUser);
        if (talkUser == null) return;
        final talkRoom = TalkRoom(
            roomId: doc.id,
            talkUser: talkUser,
            lastMessage: doc.data()['last_message']);
        talkRooms.add(talkRoom);
      }
      print(talkRooms.length);
    } catch (e) {
      print('参加しているルームの取得失敗=====$e');
    }
  }
}
