enum RucType { ruc10, ruc15, ruc20 }

enum DocumentType { dni, ce }

enum SocietyType { sac, sa, saa, srl }

enum ItemValidationState { initial, pending, completed }

/// Tipo de teclado para inputs (Domain Layer)
/// Se convierte a TextInputType solo en Presentation
enum KeyboardType {
  text,
  number,
  phone,
  email,
  visiblePassword,
  name,
}
