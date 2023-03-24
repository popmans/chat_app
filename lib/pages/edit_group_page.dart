import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage(
      {this.groupId,
      this.groupName,
      this.password,
      this.memberList,
      this.isExistMessage,
      this.whoList,
      Key? key})
      : super(key: key);
  final String? groupId;
  final String? groupName;
  final int? password;
  final List<String>? memberList;
  final bool? isExistMessage;
  final List<String>? whoList;

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController memberNameController = TextEditingController();
  String? password;
  late List<String> _memberList;
  List<String> deleteMemberList = [];
  List<String> addMemberList = [];

  @override
  void initState() {
    super.initState();
    if (widget.password == null) {
      _memberList = [];
    } else {
      groupNameController.text = widget.groupName!;
      password = widget.password!.toString();
      _memberList = widget.memberList!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('グループ作成・修正'),
          leading: BackButton(onPressed: () async {
            List<String>? newMemberList;
            if (password != null) {
              if (groupNameController.text == '') {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return AlertDialog(
                      content: Text("グループ名が未入力です。"),
                      actions: [
                        OutlinedButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              } else if (_memberList.isEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return AlertDialog(
                      content: Text("メンバーがいません。\nメンバーを追加してください。"),
                      actions: [
                        OutlinedButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              } else {
                newMemberList = [for (var member in _memberList) member];
                await RoomFirestore.updateRoom(
                    widget.groupId!, groupNameController.text, _memberList);
                List<String> preMemberList = createPreMemberList(
                    _memberList, addMemberList, deleteMemberList);
                if (!listEquals(preMemberList, newMemberList)) {
                  await RoomFirestore.sendMessage(
                      roomId: widget.groupId!,
                      notice:
                          noticeTextForChange(preMemberList, newMemberList));
                }
                Navigator.pop(context, newMemberList);
              }
            } else {
              Navigator.pop(context);
            }
          })),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  width: size.width * 0.9,
                  child: TextFormField(
                    maxLength: 15,
                    controller: groupNameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                          width: 2.0,
                        ),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.purple,
                      ),
                      labelText: 'グループ名',
                      floatingLabelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextFormField(
                      maxLength: 10,
                      controller: memberNameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.purple,
                            width: 2.0,
                          ),
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.purple,
                        ),
                        labelText: 'メンバー名',
                        floatingLabelStyle: const TextStyle(fontSize: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.purple,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // メンバー反映処理
                        _memberList.add(memberNameController.text);
                        addMemberList.add(memberNameController.text);
                        memberNameController.text = '';
                        setState(() {});
                      },
                      child: const Text('追加',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.password != null,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('パスワード：$password', style: TextStyle(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text('参加メンバー', style: TextStyle(fontSize: 16)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _memberList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Text(_memberList[index],
                                  style: TextStyle(fontSize: 20)),
                              InkWell(
                                  onTap: () {
                                    if (!widget.whoList!
                                        .contains(_memberList[index])) {
                                      deleteMemberList.add(_memberList[index]);
                                      _memberList.removeAt(index);
                                      setState(() {});
                                    } else if (_memberList.length == 1) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) {
                                          return AlertDialog(
                                            content: Text(
                                                "メンバーがいません。\nメンバーを追加してください。"),
                                            actions: [
                                              OutlinedButton(
                                                child: Text("OK"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: Text("削除できません"),
                                            content: Text(
                                                "${_memberList[index]}には、支払い履歴があります。\nグループから削除したい場合は、${_memberList[index]}が支払ったメッセージをすべて削除してください"),
                                            actions: [
                                              OutlinedButton(
                                                child: Text("OK"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Icon(Icons.delete, size: 18))
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: password == null,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    // ルーム作成処理
                    String myUid = SharedPrefs.fetchUid()!;
                    try {
                      String? groupId = await RoomFirestore.createRoom(
                          groupNameController.text,
                          [myUid],
                          myUid,
                          'テストマン',
                          'image_path',
                          _memberList);
                      await RoomFirestore.sendMessage(
                          notice: noticeTextForCreate(_memberList),
                          roomId: groupId!);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('グループを作成',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> createPreMemberList(List<String> memberList,
      List<String> addMemberList, List<String> deleteMemberList) {
    List<String> preMemberList = memberList;
    for (var member in addMemberList) {
      if (memberList.contains(member)) {
        memberList.remove(member);
      }
    }
    print(memberList);
    for (var member in deleteMemberList) {
      if (!memberList.contains(member)) {
        memberList.add(member);
      }
    }
    print(memberList);
    return memberList;
  }

  String noticeTextForCreate(List<String> members) {
    String text =
        members.map<String>((String value) => value.toString()).join(',') +
            'がグループに参加しました。';
    return text;
  }

  String noticeTextForChange(List<String> preMembers, List<String> newMembers) {
    List<String> leaveMembers = [];
    for (var member in preMembers) {
      if (!newMembers.contains(member)) {
        leaveMembers.add(member);
      }
    }
    List<String> joinMembers = [];
    for (var member in newMembers) {
      if (!preMembers.contains(member)) {
        joinMembers.add(member);
      }
    }
    if (leaveMembers.isNotEmpty && joinMembers.isEmpty) {
      String leaveText = leaveMembers
              .map<String>((String value) => value.toString())
              .join(',') +
          'がグループから退出しました。';
      return leaveText;
    } else if (joinMembers.isNotEmpty && leaveMembers.isEmpty) {
      String joinText = joinMembers
              .map<String>((String value) => value.toString())
              .join(',') +
          'がグループに参加しました。';
      return joinText;
    } else {
      String leaveText = leaveMembers
              .map<String>((String value) => value.toString())
              .join(',') +
          'がグループから退出しました。';
      String joinText = joinMembers
              .map<String>((String value) => value.toString())
              .join(',') +
          'がグループに参加しました。';
      return '$leaveText\n$joinText';
    }
  }
}
