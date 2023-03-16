import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/pages/edit_group_page.dart';
import 'package:chat_app/pages/setting_profile_page.dart';
import 'package:chat_app/pages/talk_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/talk_room.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('チャットアプリ'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingProfilePage()));
                },
                icon: const Icon(Icons.settings)),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: RoomFirestore.joinedRoomSnapshot,
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasData) {
                return FutureBuilder<List<TalkRoom>?>(
                    future:
                        RoomFirestore.fetchJoinedRooms(streamSnapshot.data!),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (futureSnapshot.hasData) {
                          List<TalkRoom> talkRooms = futureSnapshot.data!;
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 200.0),
                                child: ListView.builder(
                                    itemCount: talkRooms.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TalkRoomPage(
                                                          talkRooms[index])));
                                        },
                                        child: SizedBox(
                                          height: 70,
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    talkRooms[index].groupName,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 200,
                                    color: Colors.purple[50],
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // ルーム作成処理
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditGroupPage()),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                  bottom: 10.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              height: 145,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/create_image.png',
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    const Text('作成',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // ルーム参加処理
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 25.0,
                                                  bottom: 10.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              height: 145,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Image.asset(
                                                      'assets/images/join_image.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  const Text('参加',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: Text('トークルームの取得に失敗しました'));
                        }
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
        /*
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
            Container(
              height: 70,
              width: 360,
              decoration: BoxDecoration(
                  color: Colors.white, border: Border.all(width: 1)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4),
                child: Text(
                  '新規グループ作成',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
                height: 70,
                width: 360,
                decoration: BoxDecoration(
                    color: Colors.white, border: Border.all(width: 1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 15),
                      child: RichText(
                        text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: 'グループID',
                                  style: TextStyle(color: Colors.red)),
                              TextSpan(text: '入力')
                            ]),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft),
          ])),
      */
        /*
      body: StreamBuilder<QuerySnapshot>(
          stream: RoomFirestore.joinedRoomSnapshot,
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasData) {
              return FutureBuilder<List<TalkRoom>?>(
                  future: RoomFirestore.fetchJoinedRooms(streamSnapshot.data!),
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (futureSnapshot.hasData) {
                        List<TalkRoom> talkRooms = futureSnapshot.data!;
                        return ListView.builder(
                            itemCount: talkRooms.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TalkRoomPage(talkRooms[index])));
                                },
                                child: SizedBox(
                                  height: 70,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: talkRooms[index]
                                                      .talkUser
                                                      .imagePath ==
                                                  null
                                              ? null
                                              : NetworkImage(talkRooms[index]
                                                  .talkUser
                                                  .imagePath!),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            talkRooms[index].talkUser.name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            talkRooms[index].lastMessage ?? '',
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(child: Text('トークルームの取得に失敗しました'));
                      }
                    }
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
       */
        );
  }
}
