import 'package:chat_app/firestore/room_firestore.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage(
      {this.groupName, this.password, this.memberList, Key? key})
      : super(key: key);
  final String? groupName;
  final String? password;
  final List<String>? memberList;

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController memberNameController = TextEditingController();
  late String password;
  late List<String> memberList;

  @override
  void initState() {
    super.initState();
    if (widget.password == null) {
      password = '123456';
      memberList = [];
    } else {
      password = widget.password!;
      memberList = widget.memberList!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('グループ作成・修正')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  width: size.width * 0.9,
                  child: TextFormField(
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
                        memberList.add(memberNameController.text);
                        memberNameController.text = '';
                        setState(() {});
                      },
                      child: const Text('決定',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text('パスワード：${password}', style: TextStyle(fontSize: 16)),
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: memberList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(memberList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
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
                    await RoomFirestore.createRoom(groupNameController.text,
                        [myUid], myUid, 'テストマン', 'image_path', memberList);
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('決定',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
