import 'package:flutter/material.dart';

class RegisterTitleWidget extends StatelessWidget {
  const RegisterTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Regístrese y obtenga el Plan Oro",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 23,
          color: const Color(0xFF00114A),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
