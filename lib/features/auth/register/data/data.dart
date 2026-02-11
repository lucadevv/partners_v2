// Barrel: data layer of auth/register feature.
export 'datasource/register_datasource.dart';
export 'datasource/ntw/ntw_register_datasource_impl.dart';
export 'mappers/document_mapper.dart';
export 'mappers/register_mapper.dart';
export 'mappers/start_register_mapper.dart';
export 'mappers/strategies/ce_strategy.dart';
export 'mappers/strategies/dni_strategy.dart';
export 'mappers/strategies/document_type_strategy.dart';
// Ocultar Data en uno para evitar conflicto: ambas models definen class Data.
export 'models/document_res_model.dart';
export 'models/register_ruc_res_model.dart' hide Data;
export 'models/start_register_res_model.dart';
export 'repository/register_repository_impl.dart';
