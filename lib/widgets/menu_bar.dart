import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  const CustomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(45)),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xFFEFEEFF), //Colors.transparent Прозрачный цвет внизу
              ],
              stops: [
                0.1,
                0.5
              ]),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: BasicStyle.firstMenuRow
              .map((data) => ButtonOfMenu(dataOfButton: data))
              .toList(),
        ),
      ),
    );
  }
}

class DataOfButton {
  final String pathToIcon;
  final bool isSelected;

  DataOfButton({required this.pathToIcon, required this.isSelected});
}

class ButtonOfMenu extends StatelessWidget {
  final DataOfButton dataOfButton;
  Color buttonColor = Colors.transparent;

  ButtonOfMenu({
    required this.dataOfButton,
  }) {
    buttonColor = (dataOfButton.isSelected
        ? Colors.deepPurple
        : Colors.grey.shade50.withOpacity(0.8));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF9EA3F7),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ]),
      child: IconButton(
        // color: Colors.white,
        onPressed: () {},
        icon: Image.asset(dataOfButton.pathToIcon),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
        ),
      ),
    );
  }
}

class BasicStyle {
  static List<DataOfButton> get firstMenuRow => [
    DataOfButton(
        pathToIcon: 'assets/images/menuBarIcon/Chats.png',
        isSelected: false),
    DataOfButton(
        pathToIcon: 'assets/images/menuBarIcon/Main.png',
        isSelected: false),
    DataOfButton(
        pathToIcon: 'assets/images/menuBarIcon/News.png',
        isSelected: false),
    DataOfButton(
        pathToIcon: 'assets/images/menuBarIcon/Statictic.png',
        isSelected: false),
  ];
}