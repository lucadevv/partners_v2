import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'document_scan_state.dart';
part 'document_scan_effect.dart';

/// Cubit para manejar el escaneo de documento de identidad
class DocumentScanCubit extends Cubit<DocumentScanState> {
  DocumentScanCubit() : super(const DocumentScanState());

  /// Captura la imagen del documento
  Future<void> captureDocument() async {
    emit(state.copyWith(status: DocumentScanStatus.capturing));

    try {
      // TODO: Integrar con cámara o selección de imagen
      await Future.delayed(const Duration(seconds: 2)); // Mock

      emit(state.copyWith(
        status: DocumentScanStatus.captured,
        imagePath: '/mock/path/document.jpg',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DocumentScanStatus.failure,
        errorMessage: 'Error al capturar documento',
      ));
    }
  }

  /// Valida el documento capturado
  Future<void> validateDocument() async {
    emit(state.copyWith(status: DocumentScanStatus.validating));

    try {
      // TODO: Llamar al use case para validar documento
      await Future.delayed(const Duration(seconds: 2)); // Mock

      emit(state.copyWith(
        status: DocumentScanStatus.validated,
        effect: const DocumentValidatedEffect(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DocumentScanStatus.failure,
        errorMessage: 'Error al validar documento',
      ));
    }
  }

  /// Reintentar captura
  void retryCapture() {
    emit(state.copyWith(
      status: DocumentScanStatus.initial,
      imagePath: null,
      errorMessage: null,
    ));
  }

  /// Navegar a siguiente pantalla
  void navigateToNext() {
    emit(state.copyWith(
      effect: const NavigateToBusinessValidationEffect(),
    ));
  }

  /// Limpia el effect después de procesarlo
  void clearEffect() {
    emit(state.copyWith(effect: null));
  }

  /// Reset del estado
  void reset() {
    emit(const DocumentScanState());
  }
}
