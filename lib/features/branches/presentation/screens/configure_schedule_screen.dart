import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ConfigureScheduleScreen extends StatefulWidget {
  const ConfigureScheduleScreen({super.key});

  @override
  State<ConfigureScheduleScreen> createState() =>
      _ConfigureScheduleScreenState();
}

class _ConfigureScheduleScreenState extends State<ConfigureScheduleScreen> {
  final List<String> _days = const [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  final Set<String> _selectedDays = {'Lunes', 'Martes'};
  final String _startTime = '09:00';
  final String _endTime = '21:00';

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
          'Configure el horario',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Señale los días disponibles',
                      style: TextStyle(
                        color: Color(0xFF051858),
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Days grid
                    Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: _days.map((day) {
                        final isSelected = _selectedDays.contains(day);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedDays.remove(day);
                              } else {
                                _selectedDays.add(day);
                              }
                            });
                          },
                          child: Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0EA5E9)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0EA5E9)
                                    : const Color(0xFF0A2B7A),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF0A2B7A),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Señale la hora, según el día seleccionado',
                      style: TextStyle(
                        color: Color(0xFF051858),
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Time fields
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            label: 'Inicio de hora',
                            value: _startTime,
                            onTap: () {
                              // TODO: Implementar time picker
                            },
                          ),
                        ),
                        const SizedBox(width: 19),
                        Expanded(
                          child: _buildTimeField(
                            label: 'Fin de hora',
                            value: _endTime,
                            onTap: () {
                              // TODO: Implementar time picker
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 77,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF0A2B7A),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 38,
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF00114A),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
