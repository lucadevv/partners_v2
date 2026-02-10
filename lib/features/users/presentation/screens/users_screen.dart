import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2B69),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2B69),
        title: const Text(
          'Users',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Users Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
