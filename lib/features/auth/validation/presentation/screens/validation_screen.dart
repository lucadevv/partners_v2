import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document/document_scan_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_header_widget.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';
import 'package:partners/features/auth/validation/presentation/cubit/validation_cubit.dart';
import 'package:partners/features/auth/validation/presentation/notifier/validation_form_notifier.dart';
import 'package:partners/features/auth/validation/presentation/widgets/validation_step_widget.dart';

@RoutePage()
class ValidationScreen extends StatefulWidget {
  final RucType rucType;

  const ValidationScreen({super.key, required this.rucType});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen>
    with AutoRouteAware {
  late ValidationFormNotifier _notifier;
  AutoRouteObserver? _observer;
  @override
  void initState() {
    super.initState();
    final observers = RouterScope.of(context).navigatorObservers;
    _observer = observers.whereType<AutoRouteObserver>().firstOrNull;
    _observer?.subscribe(this, context.routeData);
    _notifier = ValidationFormNotifier();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RegisterCubit>().reset();
        context.read<ValidationCubit>().loadValidationSteps(
          rucType: widget.rucType,
        );
      }
    });
  }

  @override
  void didPopNext() {
    context.read<ValidationCubit>().loadValidationSteps(
      rucType: widget.rucType,
    );
    context.read<DocumentScanCubit>().reset();
    super.didPopNext();
  }

  @override
  void dispose() {
    _notifier.dispose();
    _observer?.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterHeaderWidget(),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _notifier,
          builder: (context, _) {
            return _buildStepsView();
          },
        ),
      ),
    );
  }

  Widget _buildStepsView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Text(
            'Validemos tu cuenta en pocos pasos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF051858),
            ),
          ),

          BlocConsumer<ValidationCubit, ValidationState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Column(
                spacing: 16,
                children: state.validationItems.map((item) {
                  return ValidationStepWidget(
                    text: item.label,
                    onTap: () => showBottomSheet(item),
                    state: item.state,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void showBottomSheet(ItemValidation item) async {
    final router = context.router;

    if (item is IdentityItemValidation) {
      router.push(DocumentScanRoute(rucType: widget.rucType));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.appColor.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.router.pop(false),
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF051858),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF051858),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                24.spaceh,
                item.buildWidget(),
              ],
            ),
          ),
        ),
      ),
    ).then((value) {
      if (mounted) {
        if (value == false) return;
        context.read<ValidationCubit>().loadValidationSteps(
          rucType: widget.rucType,
        );
      }
    });
  }
}
