import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';

@RoutePage()
class TransactionDetailScreen extends StatelessWidget {
  final String transactionName;
  final String transactionDate;
  final String transactionPoints;

  const TransactionDetailScreen({
    super.key,
    required this.transactionName,
    required this.transactionDate,
    required this.transactionPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF001045), Color(0xFF0A2B7A), Color(0xFF4D3589)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              kToolbarHeight.spaceh,
              // Title
              const Text(
                'Puntos emitidos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Figtree',
                ),
                textAlign: TextAlign.center,
              ),
              16.spaceh,
              // Check badge icon
              SvgPicture.asset('assets/svg/check.svg'),
              const SizedBox(height: 40),
              // Status text
              const Text(
                'Transferencia exitosa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Figtree',
                  letterSpacing: -0.69,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Date text
              Text(
                transactionDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Figtree',
                  letterSpacing: -0.54,
                ),
                textAlign: TextAlign.center,
              ),
              20.spaceh,
              // Details text
              Text(
                "Detalles",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Figtree',
                  letterSpacing: -0.69,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Puede que la acción no sea inmediata y se deba esperar unos minutos para que esto se actualice en el servidor.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                    letterSpacing: -0.45,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Monto emitido card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3F0FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto emitido: $transactionPoints',
                      style: const TextStyle(
                        color: Color(0xFF0A2B7A),
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                        letterSpacing: -0.69,
                      ),
                    ),
                    4.spaceh,
                    const Text(
                      'Estado del pago: Realizado con éxito',
                      style: TextStyle(
                        color: Color(0xFF0A2B7A),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                        letterSpacing: -0.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Número de operación card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'N°. de operación: 1108',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                        letterSpacing: -0.69,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comercio: $transactionName\nFecha y hora: $transactionDate',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                        letterSpacing: -0.45,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Beneficiario card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Beneficiario de Puntos Smart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                        letterSpacing: -0.69,
                      ),
                    ),
                    4.spaceh,
                    Text(
                      'Usuario(a): $transactionName\nTrabajador emisor: Mariano Suquillanda Ramirez',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Figtree',
                        letterSpacing: -0.45,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Accept button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF66CFFF),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.router.pop(),
                    borderRadius: BorderRadius.circular(50),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Color(0xFF051858),
                          size: 22,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Aceptar',
                          style: TextStyle(
                            color: Color(0xFF051858),
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
