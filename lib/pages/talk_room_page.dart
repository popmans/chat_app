import 'dart:async';

import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

import '../model/message.dart';

class TalkRoomPage extends StatefulWidget {
  final TalkRoom talkRoom;
  const TalkRoomPage(this.talkRoom, {Key? key}) : super(key: key);

  @override
  _TalkRoomPageState createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  bool isOpenKeyboard = false;
  late String isSelectedPerson;
  final TextEditingController whereController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  var focusNode = FocusNode();
  List<QueryDocumentSnapshot<Object?>>? calculationDocs;
  var controller = StreamController<List<QueryDocumentSnapshot<Object?>>>();

  @override
  void initState() {
    super.initState();
    isSelectedPerson = widget.talkRoom.members.first;
    controller.stream.listen((data) {
      calculationDocs = data;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                List<Map<String, double>> warikan = [];
                // 精算ロジック
                if (calculationDocs != null) {
                  List<Map<String, double>> output = [];
                  List<String> members = widget.talkRoom.members;
                  for (var member in members) {
                    Map<String, double> map = {};
                    for (String other in members) {
                      if (other != member) {
                        map[other] = 0;
                      }
                    }
                    output.add(map);
                  }
                  for (var doc in calculationDocs!) {
                    final Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    String who = data['who'];
                    int money = data['how_much'];
                    List targets =
                        data['targets'].cast<String>() as List<String>;
                    double split = money / targets.length;
                    for (String target in targets) {
                      if (target != who) {
                        final index = members.indexOf(target);
                        output[index][who] = output[index][who]! + split;
                      }
                    }
                  }
                  for (var member in members) {
                    final index = members.indexOf(member);
                    Map<String, double> map = {};
                    for (String other in members) {
                      if (other != member) {
                        final otherIndex = members.indexOf(other);
                        double i =
                            output[index][other]! - output[otherIndex][member]!;
                        if (i < 0) {
                          i = 0;
                        }
                        if (i < 0) {
                          i = 0;
                        }
                        map[other] = double.parse(i.toStringAsFixed(1));
                      }
                    }
                    warikan.add(map);
                  }
                }
                // 結果のダイアログを表示する
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Colors.purple,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text("計算結果",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.white)),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.6),
                                  child: Scrollbar(
                                    child: SingleChildScrollView(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              widget.talkRoom.members.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                Text(
                                                    widget.talkRoom
                                                        .members[index],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30)),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1),
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: widget.talkRoom
                                                              .members.length +
                                                          1,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int i) {
                                                        double allMoney = 0;
                                                        if (index != i) {
                                                          if (i !=
                                                              widget
                                                                  .talkRoom
                                                                  .members
                                                                  .length) {
                                                            allMoney += warikan[
                                                                    index][
                                                                widget.talkRoom
                                                                        .members[
                                                                    i]]!;
                                                            return Text(
                                                                '${widget.talkRoom.members[i]}に、¥${warikan[index][widget.talkRoom.members[i]]}円払う',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20));
                                                          } else {
                                                            return Text(
                                                                '合計、¥$allMoney円の支払い',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        20));
                                                          }
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.add_chart_outlined))
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream:
                  RoomFirestore.fetchMessageSnapahot(widget.talkRoom.roomId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: ListView.builder(
                        physics: const RangeMaintainingScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          controller.sink.add(snapshot.data!.docs);
                          final doc = snapshot.data!.docs[index];
                          final Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          final Message message = Message(
                              message:
                                  '${data['who']}が、${data['where']}で${data['how_much']}円払った',
                              isMe: SharedPrefs.fetchUid() == data['sender_Id'],
                              sendTime: data['send_time']);
                          return Padding(
                            padding: EdgeInsets.only(
                                top: 10.0,
                                left: 10,
                                right: 10,
                                bottom: index == 0 ? 10 : 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textDirection: message.isMe
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              children: [
                                Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    decoration: BoxDecoration(
                                      color: message.isMe
                                          ? Colors.green
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: Text(message.message)),
                                Text(intl.DateFormat('y:HH:mm')
                                    .format(message.sendTime.toDate()))
                              ],
                            ),
                          );
                        }),
                  );
                } else {
                  return const Center(
                    child: Text('メッセージがありません'),
                  );
                }
              }),
          !isOpenKeyboard
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        color: Colors.white,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.32,
                                  right:
                                      MediaQuery.of(context).size.width * 0.32,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: const Text('金額を入力',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            onPressed: () async {
                              setState(() {
                                isOpenKeyboard = true;
                              });
                              // なんかわからんけど待たなきゃいけない
                              await Future.delayed(
                                  const Duration(milliseconds: 10));
                              FocusScope.of(context).requestFocus(focusNode);
                            })),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.white,
                      height: 195,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: DropdownButton(
                                  items: [
                                    for (int index = 0;
                                        index < widget.talkRoom.members.length;
                                        index++)
                                      DropdownMenuItem(
                                        value: widget.talkRoom.members[index],
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          alignment: Alignment.center,
                                          child: Text(
                                              widget.talkRoom.members[index]),
                                        ),
                                      ),
                                  ],
                                  onChanged: (String? value) {
                                    setState(() {
                                      isSelectedPerson = value!;
                                    });
                                  },
                                  value: isSelectedPerson,
                                ),
                              ),
                              const Text('が、'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isOpenKeyboard = false;
                                    isSelectedPerson =
                                        widget.talkRoom.members.first;
                                    whereController.text = '';
                                    moneyController.text = '';
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: whereController,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                        hintText: '商品または店',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              const Text('で、'),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: moneyController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                        hintText: '金額',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              const Text('払った。'),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    await RoomFirestore.sendMessage(
                                        who: isSelectedPerson,
                                        where: whereController.text,
                                        howMuch:
                                            int.parse(moneyController.text),
                                        targets: widget.talkRoom.members,
                                        roomId: widget.talkRoom.roomId);
                                    setState(() {
                                      isOpenKeyboard = false;
                                      isSelectedPerson =
                                          widget.talkRoom.members.first;
                                      whereController.text = '';
                                      moneyController.text = '';
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                  icon: const Icon(Icons.send))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
