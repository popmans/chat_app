import 'package:flutter/material.dart';
import 'package:intl/intl.dart'as intl;

import '../model/message.dart';
class TalkRoomPage extends StatefulWidget {
  final String name;
  const TalkRoomPage(this.name,{Key? key}) : super(key: key);

  @override
  _TalkRoomPageState createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  List<Message> messageList=[
    Message(message: 'あいう', isMe: true, sendTime:DateTime(2022,1,1,12,0)),
    Message(message: 'かきく', isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
        isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あいう', isMe: true, sendTime:DateTime(2022,1,1,12,0)),
    Message(message: 'かきく', isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
        isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あいう', isMe: true, sendTime:DateTime(2022,1,1,12,0)),
    Message(message: 'かきく', isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
        isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あいう', isMe: true, sendTime:DateTime(2022,1,1,12,0)),
    Message(message: 'かきく', isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
        isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あいう', isMe: true, sendTime:DateTime(2022,1,1,12,0)),
    Message(message: 'かきく', isMe: false, sendTime:DateTime(2022,1,1,13,12)),
    Message(message: 'あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
        isMe: false, sendTime:DateTime(2022,1,1,13,12))


  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar:AppBar(
        title: Text(widget.name),
      ) ,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: ListView.builder(
              physics: const RangeMaintainingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
                itemCount: messageList.length,
                    itemBuilder:(context,index){
              return Padding(
                padding:  EdgeInsets.only(top:10.0, left: 10, right: 10, bottom: index == 0 ? 10: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textDirection: messageList[index].isMe ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Container(

                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6),
                      decoration: BoxDecoration(
                        color:messageList[index].isMe ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                      child:Text(messageList[index].message)
                    ),
                    Text(intl.DateFormat('HH:mm').format(messageList[index].sendTime))
                  ],
                ),
              );
            }),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: Row(
                  children: [
                    const Expanded(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                       decoration: InputDecoration(
                         contentPadding:  EdgeInsets.only(left:10),
                         border: OutlineInputBorder()
                       ),
                      ),
                    )),
                    IconButton(onPressed:(){

                    }
                        , icon:const Icon(Icons.send))
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
