import 'package:example/widgets/package_title.dart';
import 'package:flutter/material.dart';

/// Header row used at the top of a showcase sidebar.
class SidebarHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final bool isSmall;

  const SidebarHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageTitle(title: title, isSmall: isSmall),
        if (leading != null)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: leading,
              ),
            ),
          ),
        if (trailing != null)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: trailing,
              ),
            ),
          ),
      ],
    );
  }
}

/// 350px left-aligned panel with a header and an expanded content area.
class ShowcaseSidebar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Widget child;

  const ShowcaseSidebar({
    super.key,
    required this.title,
    required this.child,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFDDDDDD))),
      ),
      width: 380,
      child: Column(
        children: [
          SidebarHeader(title: title, leading: leading, trailing: trailing),
          Expanded(child: child),
        ],
      ),
    );
  }
}
