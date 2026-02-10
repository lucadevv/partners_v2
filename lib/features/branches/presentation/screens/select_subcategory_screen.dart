import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SelectSubCategoryScreen extends StatelessWidget {
  const SelectSubCategoryScreen({super.key});

  final List<String> _subCategories = const [
    'Cevichería',
    'Pollería',
    'Juguería',
    'Comida rápida',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2B69),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Color(0xFFD3F0FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0F2B69),
              size: 20,
            ),
          ),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Elija o busque la subcategoría',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w700,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 32),
            onPressed: () => context.router.pop(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 131,
              height: 5,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _subCategories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildSubCategoryItem(_subCategories[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryItem(String subCategory) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 30),
        Text(
          subCategory,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
      ],
    );
  }
}
