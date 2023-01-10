import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Color(0xFFDDDDDD),
        ),
      )),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}
