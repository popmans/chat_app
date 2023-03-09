import 'package:chat_app/firestore/user_firestore.dart';
import 'package:chat_app/model/talk_room.dart';
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

  static Future<void> fetchJoinedRoom() async {
    try{
      String myUid = SharedPrefs.fetchUid()!;
      final snapshot = await _roomCollection.where('joined_user_ids ',arrayContains: myUid ).get();
      List<TalkRoom> talkRooms=[];
      for(var doc in snapshot. docs){
        final talkRoom = TalkRoom(roomId: doc.id, talkUser: talkUser)
      }
    }catch(e){
      
    }
  }
}
