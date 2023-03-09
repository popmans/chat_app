import 'dart:developer';

import 'package:chat_app/model/user.dart';
import 'package:chat_app/pages/setting_profile_page.dart';
import 'package:chat_app/pages/talk_room_page.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<User> userList = [
    User(name:'田中',uid: 'abc',imagePath:'https://assets.st-note.com/production/uploads/images/58075596/profile_7d12166cbb91dd3ff25bbed3898bdd76.png?width=2000&height=2000&fit=bounds&format=jpg&quality=85',
        lastMessage:'こんにちは'),
    User(name:'佐藤',uid: 'def',
        lastMessage:'ありがとう'),
    User(name:'佐藤',uid: 'def',
        lastMessage:'ありがとう'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('チャットアプリ'),

      actions: [
        IconButton(
            onPressed: () {
             Navigator.push(context, MaterialPageRoute(
                 builder: (context)=>const SettingProfilePage()));
             },
            icon: const Icon(Icons.settings))
      ],
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder:(context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(
                  builder: (context)=>TalkRoomPage(userList[index].name)
              ));
            },
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: userList[index].imagePath==null
                        ?null
                        :NetworkImage(userList[index].imagePath!),),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userList[index].name,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    Text(userList[index].lastMessage,style: const TextStyle(color: Colors.grey),),

                  ],
                )
                ],
              ),
            ),
          );
        }),
    );
  }
}
