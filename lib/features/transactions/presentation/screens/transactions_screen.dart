import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/routes/app_routes.gr.dart';

@RoutePage()
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  final List<Map<String, String>> _transactions = const [
    {
      'name': 'Karylin Moscol',
      'date': '25 Jul 2025 - 16:54',
      'points': '5 puntos',
    },
    {
      'name': 'Alan Paerson',
      'date': '25 Jul 2025 - 16:54',
      'points': '5 puntos',
    },
    {
      'name': 'Mariano Suquillan..',
      'date': '26 Jul 2025 - 09:30',
      'points': '3 puntos',
    },
    {'name': 'Grace Lee', 'date': '26 Jul 2025 - 09:30', 'points': '3 puntos'},
    {
      'name': 'Jasper Fenn',
      'date': '26 Jul 2025 - 09:12',
      'points': '4 puntos',
    },
    {
      'name': 'Isolde Tran',
      'date': '27 Jul 2025 - 11:30',
      'points': '-3 puntos',
    },
    {'name': 'Ravi Mehta', 'date': '28 Jul 2025 - 14:45', 'points': '5 puntos'},
    {
      'name': 'Elena Rodriguez',
      'date': '29 Jul 2025 - 08:20',
      'points': '-4 puntos',
    },
    {
      'name': 'Marcus Lang',
      'date': '30 Jul 2025 - 10:05',
      'points': '-2 puntos',
    },
    {
      'name': 'Aisha Patel',
      'date': '31 Jul 2025 - 15:00',
      'points': '-5 puntos',
    },
    {'name': 'Theo Chen', 'date': '01 Mar 2025 - 17:30', 'points': '-3 puntos'},
    {
      'name': 'Nia Johnson',
      'date': '02 Ene 2025 - 12:15',
      'points': '4 puntos',
    },
    {
      'name': "Liam O'Reilly",
      'date': '03 Abri 2025 - 19:45',
      'points': '-10 puntos',
    },
    {'name': 'Sofia Kim', 'date': '04 Ago 2025 - 13:10', 'points': '5 puntos'},
    {'name': 'Victor Hu', 'date': '05 Jun 2025 - 16:00', 'points': '4 puntos'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0A2B7A)),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Transacciones',
          style: TextStyle(
            color: Color(0xFF0A2B7A),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF0A2B7A)),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _transactions.length - 1 ? 10 : 0,
            ),
            child: _buildTransactionItem(
              context,
              _transactions[index]['name']!,
              _transactions[index]['date']!,
              _transactions[index]['points']!,
              const Color(0XFFf4f4f7),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String name,
    String date,
    String points,
    Color backgroundColor,
  ) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.visibility_outlined, size: 30),
            color: const Color(0xFF051858),
            onPressed: () {
              context.router.push(
                TransactionDetailRoute(
                  transactionName: name,
                  transactionDate: date,
                  transactionPoints: points,
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            points,
            style: const TextStyle(
              color: Color(0xFF051858),
              fontSize: 23,
              fontWeight: FontWeight.w600,
              fontFamily: 'Figtree',
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF051858),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Figtree',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
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
                const Expanded(
                  child: Text(
                    'Filtrar por',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
                const SizedBox(width: 35),
              ],
            ),
            const SizedBox(height: 30),
            _buildFilterOption('Solo hoy', true),
            const SizedBox(height: 20),
            _buildFilterOption('Últimos 07 días', false),
            const SizedBox(height: 20),
            _buildFilterOption('Últimos 15 días', false),
            const SizedBox(height: 20),
            _buildFilterOption('Últimos 30 días', false),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFF051858) : Colors.transparent,
            border: Border.all(
              color: isSelected ? const Color(0xFF051858) : Colors.black,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
      ],
    );
  }
}
