// --- FACTORY (Patrón CREACIONAL) ---
// Sigue el mismo patrón que RucConfigFactory, DocConfigFactory

import 'package:partners/core/utils/utils.dart';
import 'package:partners/features/branches/domain/domain.dart';

class BranchConfigFactory {
  /// Obtiene la configuración del formulario de creación de sucursal
  static BranchFormConfig getConfig() {
    return BranchFormConfig(
      nameField: BranchFieldDefinition(
        label: 'Nombre de la sucursal',
        placeholder: 'Ingresa el nombre',
        keyboardType: KeyboardType.text,
        maxLength: 100,
      ),
      phoneField: BranchFieldDefinition(
        label: 'Teléfono',
        placeholder: 'Ingresa el teléfono',
        keyboardType: KeyboardType.phone,
        maxLength: 9,
      ),
      addressField: BranchFieldDefinition(
        label: 'Dirección',
        placeholder: 'Ingresa la dirección',
        keyboardType: KeyboardType.text,
        maxLength: 200,
      ),
    );
  }

  /// Obtiene la estrategia de validación para el nombre
  static BranchValidatorStrategy getNameValidator() {
    return BranchNameValidator();
  }

  /// Obtiene la estrategia de validación para el teléfono
  static BranchValidatorStrategy getPhoneValidator() {
    return BranchPhoneValidator();
  }

  /// Obtiene la estrategia de validación para la dirección
  static BranchValidatorStrategy getAddressValidator() {
    return BranchAddressValidator();
  }
}
