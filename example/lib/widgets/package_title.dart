import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final bool isSmall;

  const PageTitle({
    Key? key,
    required this.title,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: isSmall ? const EdgeInsets.all(4) : const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Color(0xFFDDDDDD),
        ),
      )),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isSmall ? 14 : 24,
        ),
      ),
    );
  }
}
