import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/firestore/user_firestore.dart';
import 'package:chat_app/pages/drawer_page.dart';
import 'package:chat_app/pages/edit_group_page.dart';
import 'package:chat_app/pages/talk_room_page.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/talk_room.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!SharedPrefs.fetchDoneOpen()) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            TextEditingController userNameController = TextEditingController();
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text("ユーザー名を入力してください"),
              content: TextField(
                controller: userNameController,
                enabled: true,
                // 入力数
                maxLength: 10,
                style: TextStyle(color: Colors.black),
                obscureText: false,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'ユーザー名を入力してください',
                  labelText: 'ユーザー名',
                ),
              ),
              actions: [
                OutlinedButton(
                  child: Text("決定"),
                  onPressed: () async {
                    if (userNameController.text != '') {
                      String? uid = SharedPrefs.fetchUid();
                      if (uid != null) {
                        await UserFirestore.updateUserName(
                            uid, userNameController.text);
                      }
                      SharedPrefs.setDoneOpen();
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('チャットアプリ'),
          actions: [
            IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 25),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                }),
          ],
        ),
        endDrawer: const DefaultDrawer(),
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
                                          child: Container(
                                            height: 70,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: Colors.purple[50],
                                                  child: Text(
                                                    talkRooms[index].groupName,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) {
                                                  TextEditingController
                                                      groupNameController =
                                                      TextEditingController();
                                                  TextEditingController
                                                      passwordNameController =
                                                      TextEditingController();

                                                  return AlertDialog(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    title: Text(
                                                        "グループ名とパスワードを入力してください"),
                                                    content: SizedBox(
                                                      height: 200,
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            controller:
                                                                groupNameController,
                                                            enabled: true,
                                                            // 入力数
                                                            maxLength: 15,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            obscureText: false,
                                                            maxLines: 1,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'グループ名を入力してください',
                                                              labelText:
                                                                  'グループ名',
                                                            ),
                                                          ),
                                                          TextField(
                                                            controller:
                                                                passwordNameController,
                                                            enabled: true,
                                                            // 入力数
                                                            maxLength: 10,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            obscureText: false,
                                                            maxLines: 1,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'パスワードを入力してください',
                                                              labelText:
                                                                  'パスワード',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      OutlinedButton(
                                                        child: Text("キャンセル"),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                      OutlinedButton(
                                                        child: Text("決定"),
                                                        onPressed: () async {
                                                          String? uid =
                                                              SharedPrefs
                                                                  .fetchUid();
                                                          await RoomFirestore
                                                              .checkJoinedRooms(
                                                                  uid!,
                                                                  groupNameController
                                                                      .text,
                                                                  int.parse(
                                                                      passwordNameController
                                                                          .text));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
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
            }));
  }
}
