import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';
import 'package:partners/features/branches/domain/use_case/create_branch_usecase.dart';
import 'package:partners/features/branches/presentation/cubit/create_branch_state.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';

/// Cubit para crear sucursal. Solo hace fold del Either; la validación de formulario
/// está en el Notifier y la de dominio en el UseCase.
class CreateBranchCubit extends Cubit<CreateBranchState> with BaseCubitMixin {
  CreateBranchCubit({required CreateBranchUseCase createBranchUseCase})
      : _createBranchUseCase = createBranchUseCase,
        super(const CreateBranchState());

  final CreateBranchUseCase _createBranchUseCase;

  Future<void> createBranch(CreateBranchFormNotifier formNotifier) async {
    if (state.status == CreateBranchStatus.loading) return;

    formNotifier.validateAll();
    if (!formNotifier.isFormComplete) {
      if (!formNotifier.hasValidImage) {
        emit(state.copyWith(
          status: CreateBranchStatus.failure,
          errorMessage: 'Debe seleccionar una imagen de banner',
        ));
      }
      return;
    }

    final subcategory = formNotifier.selectedSubcategoryEntity;
    if (subcategory == null) {
      emit(state.copyWith(
        status: CreateBranchStatus.failure,
        errorMessage: 'Debe seleccionar una subcategoría',
      ));
      return;
    }

    final lat = formNotifier.latitude;
    final lng = formNotifier.longitude;
    if (lat == null || lng == null) {
      emit(state.copyWith(
        status: CreateBranchStatus.failure,
        errorMessage: 'Debe seleccionar ubicación en el mapa',
      ));
      return;
    }

    final days = formNotifier.scheduleDays;
    final startTime = formNotifier.scheduleStartTime ?? '';
    final endTime = formNotifier.scheduleEndTime ?? '';
    final monday = days.contains(CreateBranchScreenStrings.scheduleModalDays[0]);
    final tuesday = days.contains(CreateBranchScreenStrings.scheduleModalDays[1]);
    final wednesday = days.contains(CreateBranchScreenStrings.scheduleModalDays[2]);
    final thursday = days.contains(CreateBranchScreenStrings.scheduleModalDays[3]);
    final friday = days.contains(CreateBranchScreenStrings.scheduleModalDays[4]);
    final saturday = days.contains(CreateBranchScreenStrings.scheduleModalDays[5]);
    final sunday = days.contains(CreateBranchScreenStrings.scheduleModalDays[6]);

    final params = CreateBranchParams(
      subcategoryId: subcategory.id,
      name: formNotifier.nameController.text.trim(),
      address: formNotifier.addressController.text.trim(),
      latitude: lat,
      longitude: lng,
      phoneContacts: formNotifier.phoneController.text.trim(),
      logoPath: formNotifier.imagePath,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
      startTime: startTime,
      endTime: endTime,
    );

    // Debug: ver exactamente qué data se enviará al backend antes de llamar al use case
    if (kDebugMode) {
      debugPrint('CreateBranch payload (antes de llamar al use case):');
      debugPrint('  subcategory_id: ${params.subcategoryId}');
      debugPrint('  name: ${params.name}');
      debugPrint('  address: ${params.address}');
      debugPrint('  latitude: ${params.latitude}');
      debugPrint('  longitude: ${params.longitude}');
      debugPrint('  phone_contacts: ${params.phoneContacts}');
      debugPrint('  logo: ${params.logoPath ?? "(vacío)"}');
      debugPrint('  monday: ${params.monday}, tuesday: ${params.tuesday}, wednesday: ${params.wednesday}, thursday: ${params.thursday}, friday: ${params.friday}, saturday: ${params.saturday}, sunday: ${params.sunday}');
      debugPrint('  start_time: ${params.startTime}, end_time: ${params.endTime}');
    }

    emit(state.copyWith(status: CreateBranchStatus.loading, clearErrorMessage: true));

    final result = await _createBranchUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: CreateBranchStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (message) {
        emit(state.copyWith(
          status: CreateBranchStatus.success,
          successMessage: message,
        ));
      },
    );
  }

  /// Reinicia el estado del cubit a initial (tras éxito y limpiar formulario).
  void reset() {
    emit(const CreateBranchState());
  }
}
