import 'dart:math';

import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//ここは個人トークルームなので、「warikan_app」には、必要のないdart.fileかもしれない
//flutterlub_チャットアプリ作成_「アカウント作成時に他のユーザとのトークルームを作成

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _roomCollection = _firebaseFirestoreInstance.collection('room');
  static final joinedRoomSnapshot = _roomCollection
      .where('joined_user_ids', arrayContains: SharedPrefs.fetchUid())
      .snapshots();

  static Future<String?> createRoom(
      String roomName,
      List<String> joinedUserIds,
      String myUid,
      String userName,
      String imagePath,
      List<String> memberNames) async {
    try {
      List<Map<String, String>> joinedUsers = [
        {'uid': myUid, 'name': userName, 'image_path': imagePath}
      ];
      int randomN = Random().nextInt(999999 - 100000) + 100000;
      final newDoc = await _roomCollection.add({
        'joined_user_ids': joinedUserIds,
        'joined_users': joinedUsers,
        'members': memberNames,
        'created_time': Timestamp.now(),
        'room_name': roomName,
        'password': randomN,
      });
      return newDoc.id;
    } catch (e) {
      print('ルームの作成失敗===== $e');
      return null;
    }
  }

  static Future<List<TalkRoom>?> fetchJoinedRooms(
      QuerySnapshot snapshot) async {
    try {
      List<TalkRoom> talkRooms = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final talkRoom = TalkRoom(
            roomId: doc.id,
            joinedUsers: data['joined_users'].cast<Map<String, String>>()
                as List<Map<String, String>>,
            members: data['members'].cast<String>() as List<String>,
            groupName: data['room_name'],
            password: data['password']);
        talkRooms.add(talkRoom);
      }
      print(talkRooms.length);
      return talkRooms;
    } catch (e) {
      print('参加しているルームの取得失敗=====$e');
      return null;
    }
  }

  static Future<void> checkJoinedRooms(
      String myUid, String groupName, int password) async {
    try {
      final document = await _roomCollection
          .where('room_name', isEqualTo: groupName)
          .where('password', isEqualTo: password)
          .get();
      print(document.docs.length);
      List<String> list =
          document.docs.first['joined_user_ids'].cast<String>() as List<String>;
      list.add(myUid);
      await _roomCollection
          .doc(document.docs.first.id)
          .update({'joined_user_ids': list});
    } catch (e) {
      print('$e');
    }
  }

  static Stream<QuerySnapshot> fetchMessageSnapahot(String roomId) {
    return _roomCollection
        .doc(roomId)
        .collection('message')
        .orderBy('send_time', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage({
    required String roomId,
    required String who,
    required String where,
    required int howMuch,
    required List<String> targets,
  }) async {
    try {
      final messageCollection =
          _roomCollection.doc(roomId).collection('message');
      await messageCollection.add({
        'who': who,
        'where': where,
        'how_much': howMuch,
        'targets': targets,
        'sender_Id': SharedPrefs.fetchUid(),
        'send_time': Timestamp.now()
      });

      await _roomCollection
          .doc(roomId)
          .update({'last_message': '$whoが$whereで$howMuch払った。'});
    } catch (e) {
      print('メッセージの送信失敗=====$e');
    }
  }
}
