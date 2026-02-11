import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddWorkersScreen extends StatelessWidget {
  const AddWorkersScreen({super.key});

  final List<Map<String, String>> _workers = const [
    {
      'name': 'Amderson Moscol',
      'role': 'Administrador',
      'isSelected': 'true',
    },
    {
      'name': 'Karelim del Narnia',
      'role': 'Trabajador',
      'isSelected': 'false',
    },
    {
      'name': 'Ayar de La Cruz',
      'role': 'Administrador',
      'isSelected': 'false',
    },
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
          'Agregue a sus trabajadores',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w700,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
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
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 20),
                  // Create new worker button
                  Container(
                    height: 77,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3F0FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // TODO: Implementar crear nuevo trabajador
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Color(0xFF00114A),
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Crear nuevo trabajador',
                              style: TextStyle(
                                color: Color(0xFF00114A),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Workers list
                  ..._workers.map((worker) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildWorkerItem(worker),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerItem(Map<String, String> worker) {
    final isSelected = worker['isSelected'] == 'true';
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0x0D242760),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 23),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0EA5E9)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(5),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker['name']!,
                  style: const TextStyle(
                    color: Color(0xFF051858),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Figtree',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  worker['role']!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'Agregar',
              style: TextStyle(
                color: Color(0xFF051858),
                fontSize: 23,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
