import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserProfile extends StatelessWidget {
  List<MenuRowData> firstMenuRow = [
    MenuRowData(Icons.favorite, 'favorites'),
    MenuRowData(Icons.call, 'calls'),
    MenuRowData(Icons.computer, 'device'),
    MenuRowData(Icons.folder, 'folders with files'),
  ];
  List<MenuRowData> secondMenuRow = [
    MenuRowData(Icons.notifications, 'notifications'),
    MenuRowData(Icons.privacy_tip, 'private'),
    MenuRowData(Icons.date_range, 'date and memory'),
    MenuRowData(Icons.brush, 'design'),
    MenuRowData(Icons.language, 'language'),
  ];
  UserProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _UserInfo(),
            SizedBox(height: 30,),
            _MenuWidget(menuRow: firstMenuRow),
            SizedBox(height: 30,),
            _MenuWidget(menuRow: secondMenuRow),
          ],
        ),
      ),
    );
  }
}

class MenuRowData{
  final IconData icon;
  final String text;

  MenuRowData(this.icon, this.text);
}

class _MenuWidget extends StatelessWidget {
  final List<MenuRowData> menuRow;
  const _MenuWidget({
    super.key,
    required this.menuRow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: menuRow.map((data) => _MenuWidgetRow(data: data)).toList(),
      ),
    );
  }
}

class _MenuWidgetRow extends StatelessWidget {
  final MenuRowData data;

  const _MenuWidgetRow({super.key,
    required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(data.icon),
          const SizedBox(width: 15),
          Expanded(child: Text(data.text)),
          const SizedBox(width: 15,),
          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}


class _UserInfo extends StatelessWidget {
  const _UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: const Column(
        children: [
          SizedBox(height: 30,),
          _AvatarWidget(),
          _UserName(),
          SizedBox(height: 10,),
          Text('89802417433'),
          SizedBox(height: 10,),
          Text('@margaritkin_s'),
        ],
      ),
    );
  }
}


class _UserName extends StatelessWidget {
  const _UserName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Margarittta',
      style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w600,
      ),
    );
  }
}


class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 100,
        child: Placeholder());
  }
}