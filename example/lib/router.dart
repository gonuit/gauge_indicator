import 'package:example/pages/examples_gallery_page.dart';
import 'package:example/pages/radial_gauge_example_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> _fadeThroughPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeIn = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      );
      final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
          reverseCurve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );
      return FadeTransition(
        opacity: fadeOut,
        child: FadeTransition(
          opacity: fadeIn,
          child: child,
        ),
      );
    },
  );
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _fadeThroughPage(
        key: state.pageKey,
        child: const RadialGaugeExamplePage(),
      ),
    ),
    ShellRoute(
      pageBuilder: (context, state, child) => _fadeThroughPage(
        key: const ValueKey('examples-shell'),
        child: ExamplesGalleryShell(
          currentSlug: state.pathParameters['slug'],
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: '/examples',
          redirect: (context, state) => '/examples/${examples.first.path}',
        ),
        GoRoute(
          path: '/examples/:slug',
          pageBuilder: (context, state) {
            final slug = state.pathParameters['slug'];
            final entry = examples.firstWhere(
              (e) => e.path == slug,
              orElse: () => examples.first,
            );
            return _fadeThroughPage(
              key: ValueKey('example-${entry.path}'),
              child: Center(child: entry.builder(context)),
            );
          },
        ),
      ],
    ),
  ],
);
