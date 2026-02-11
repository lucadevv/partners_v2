import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:partners/core/extension/extension.dart';

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
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001045),
              Color(0xFF0A2B7A),
              Color(0xFF4D3589),
            ],
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
              40.spaceh,
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
              10.spaceh,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Puede que la acción no sea inmediata y se deba esperar unos minutos para que esto se actualice en el servidor.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.52),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                    letterSpacing: -0.45,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              30.spaceh,
              // Monto emitido card (diseño: fill #d3f0fe, texto #0a2b7a)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColor.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monto emitido: $transactionPoints',
                          style: TextStyle(
                            color: context.appColor.primary,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Figtree',
                            letterSpacing: -0.69,
                          ),
                        ),
                        4.spaceh,
                        Text(
                          'Estado del pago: Realizado con éxito',
                          style: TextStyle(
                            color: context.appColor.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Figtree',
                            letterSpacing: -0.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              16.spaceh,
              // Número de operación card (borde blanco)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'N°. de operación: 1108',
                          style: TextStyle(
                            color: context.appColor.onPrimary,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Figtree',
                            letterSpacing: -0.69,
                          ),
                        ),
                        4.spaceh,
                        Text(
                          'Comercio: $transactionName\nFecha y hora: $transactionDate',
                          style: TextStyle(
                            color: context.appColor.onPrimary,
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
                ),
              ),
              20.spaceh,
              // Beneficiario card
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beneficiario de Puntos Smart',
                          style: TextStyle(
                            color: context.appColor.onPrimary,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Figtree',
                            letterSpacing: -0.69,
                          ),
                        ),
                        4.spaceh,
                        Text(
                          'Usuario(a): $transactionName\nTrabajador emisor: Mariano Suquillanda Ramirez',
                          style: TextStyle(
                            color: context.appColor.onPrimary,
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
                ),
              ),
              40.spaceh,
              // Botón Aceptar (diseño: fill #66cfff, texto #051858)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.appColor.secondary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.router.pop(),
                      borderRadius: BorderRadius.circular(50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_right_alt_outlined,
                            color: context.appColor.primary,
                            size: 22,
                          ),
                          20.spacew,
                          Text(
                            'Aceptar',
                            style: TextStyle(
                              color: context.appColor.primary,
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
              ),
              40.spaceh,
            ],
          ),
        ),
      ),
    );
  }
}
