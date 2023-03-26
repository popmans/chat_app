import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        // 角丸のためにラップ
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header(context),
              const SizedBox(height: 20),
              customTile('利用規約',
                  url:
                      'https://popmans.github.io/Privacy_Policy_Warikan-Chat/terms_of_service'),
              customTile('プライバシーポリシー',
                  url:
                      'https://popmans.github.io/Privacy_Policy_Warikan-Chat/privacy_policy'),
              customTile('ライセンス', context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: DrawerHeader(
        decoration: BoxDecoration(color: Colors.purple),
        child: Text(
          '',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget customTile(String title, {String? url, BuildContext? context}) {
    return InkWell(
      onTap: () {
        if (url != null) {
          launchUrl(Uri.parse(url));
        } else {
          Navigator.push(
            context!,
            MaterialPageRoute(builder: (context) => const LicensePage()),
          );
        }
      },
      child: SizedBox(
        height: 60,
        child: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline)),
      ),
    );
  }
}
