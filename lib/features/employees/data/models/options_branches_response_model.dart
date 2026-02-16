import 'package:partners/features/employees/data/models/branch_option_model.dart';

/// Respuesta GET /options/branches (data[]).
class OptionsBranchesResponseModel {
  final List<BranchOptionModel> data;

  const OptionsBranchesResponseModel({required this.data});

  factory OptionsBranchesResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>?;
    final data = dataList != null
        ? dataList
            .map((e) => BranchOptionModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <BranchOptionModel>[];
    return OptionsBranchesResponseModel(data: data);
  }
}
