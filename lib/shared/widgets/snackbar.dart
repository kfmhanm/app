import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/extensions/all_extensions.dart';

import '../../core/services/alerts.dart';

class SnackDesgin extends StatelessWidget {
  const SnackDesgin({
    super.key,
    required this.text,
    this.state = SnackState.success,
  });

  final String text;
  final SnackState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          state == SnackState.success
              ? Lottie.asset(
                  "assets/json/success.json",
                  width: 30,
                  height: 30,
                )
              : Lottie.asset(
                  "assets/json/error.json",
                  width: 30,
                  height: 30,
                ),
          10.width,
          text
              .text(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                fontSize: 14,
              )
              .expand(),
        ],
      ).setContainerToView(
        color: state == SnackState.success
            ? context.colorScheme.primary
            : context.colorScheme.error,
        margin: 20,
        radius: 8,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
