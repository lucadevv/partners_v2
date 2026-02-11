// --- FACTORY (Patrón CREACIONAL) ---
// Sigue el mismo patrón que RucConfigFactory, DocConfigFactory

import 'package:partners/core/utils/utils.dart';
import 'package:partners/features/issue_points/domain/domain.dart';

class IssuePointsConfigFactory {
  /// Obtiene la configuración del formulario de emisión de puntos
  static IssuePointsFormConfig getConfig() {
    return IssuePointsFormConfig(
      voucherAmountField: IssuePointsFieldDefinition(
        label: 'Monto total del voucher',
        placeholder: '0',
        keyboardType: KeyboardType.number,
        maxLength: 10,
      ),
      pointsField: IssuePointsFieldDefinition(
        label: 'Puntos a emitir',
        placeholder: '0',
        keyboardType: KeyboardType.number,
        maxLength: 10,
        readOnly: true, // Se calcula automáticamente
      ),
      descriptionField: IssuePointsFieldDefinition(
        label: 'Descripción',
        placeholder: 'Agrega un comentario',
        keyboardType: KeyboardType.text,
        maxLength: 500,
      ),
      userNameField: IssuePointsFieldDefinition(
        label: 'Nombre del usuario',
        placeholder: '',
        keyboardType: KeyboardType.text,
        readOnly: true, // No editable
      ),
    );
  }

  /// Obtiene la estrategia de validación para el monto del voucher
  static IssuePointsValidatorStrategy getVoucherAmountValidator() {
    return VoucherAmountValidator();
  }

  /// Obtiene la estrategia de validación para los puntos
  static IssuePointsValidatorStrategy getPointsValidator() {
    return PointsValidator();
  }

  /// Obtiene la estrategia de validación para la descripción
  static IssuePointsValidatorStrategy getDescriptionValidator() {
    return DescriptionValidator();
  }
}
