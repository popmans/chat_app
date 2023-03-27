import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/firestore/user_firestore.dart';
import 'package:chat_app/pages/top_page.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //WidgetsFlutterBinding.ensureInitialized() が必要なシーンは、
  // 大抵の場合は不要ですが、一言で言うとrunApp()を呼び出す前にFlutter Engineの機能を利用したい場合にコールします。
  // Flutter Engineの機能とは、前述のプラットフォーム (Android, iOSなど) の画面の向きの設定やロケールなどです。利用しているプラグインによっては、runApp()の前になんらか動作しているとこの設定が事前に必要になります。
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //firebase_options.dartのDefaultFirebaseOptions.currentPlatformを呼び出していることがわかります。
  //firebase_options.dartがCLIツールを使った環境構築のキモ
  await SharedPrefs.setPrefsInstance();
  //SharedPreferencesとは情報をAndroidデバイス内に保存する仕組み
//
  String? uid = SharedPrefs.fetchUid();
  if (uid == null) await UserFirestore.createUser();
  //前提
  // Sharedpreferencesを使って値が保存されているかどうかの分岐を作りましたが、
  // nullの値が返ってくるのにもかかわらず、
  // null分岐のほうに流れてくれません。
  //
  // nullじゃなかったらnullじゃない場合の変数を用いてfirebaseから値を持ってきたいのですが
  // nullなのにnullじゃないほうに流れてエラーになります。
  //
  // 実現したいこと
  // nullの場合は、if(sharedprefs == null)以下に、
  // nullじゃない場合はif(sharedprefs != null)以下に流れてほしい。
  runApp(const MyApp());
}
//"main から始まって、runApp を呼んだところから Widget が必要になるんだね"

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//StatelessWidgetでは build メソッドが定義されていますが、中身がありません。Flutter のフレームワークとして、各 Widget の build メソッドを順次呼び出しますよ、というのが決まっているので、各 Widget はそれに備えて build メソッドをオーバーライドして実装しておく、というものです。
  //main()関数があって、MyAppをスクリーンに表示するように書かれています。
  // MyAppはクラスで名前は何でもいいです。
  //
  // MyApp は StatelessWidget を継承しています。
  // ウィジェットは画面の一要素、それのステートレスなものです。
  // つまり 「変更が起きない要素」 のようなものだと思ってください。
  // その中でウィジェットのビルドが行われています。
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //MaterialApp の中で debugShowCheckedModeBanner を false にする。
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const TopPage(),
    );
  }
}
//次は @override ですね。これはそのままオーバーライドです。これもオブジェクト指向あるあるですね。親のクラスにあるメソッドに対してオーバーライドを定義してあげると、親のクラスのメソッドが呼び出されそうなタイミングで代わりにこちらが呼び出されます。
//
