import 'package:get_it/get_it.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/core/services/ocr/ocr_service.dart';
import 'package:partners/core/services/ocr/realtime_ocr_service.dart';
import 'package:partners/features/auth/document_scan/data/datasource/document_scan_datasource.dart';
import 'package:partners/features/auth/document_scan/data/datasource/ntw__document_dasource_impl.dart';
import 'package:partners/features/auth/document_scan/data/repository/document_scan_repository_impl.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/ocr_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/upload_identity_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/watch_document_realt_time_usecase.dart';
import 'package:partners/main.dart';

class DocumentInjection {
  final GetIt _getIt;

  DocumentInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Document Scan Injection
    if (!_getIt.isRegistered<DocumentScanDatasource>()) {
      _getIt.registerLazySingleton<DocumentScanDatasource>(
        () => NtwDocumentDasourceImpl(
          services: getIt<ApiServices>(),
          ocrService: getIt<OcrService>(),
          realtimeOcrService: getIt<RealtimeOcrService>(),
        ),
      );
    }

    if (!_getIt.isRegistered<DocumentScanRepository>()) {
      _getIt.registerLazySingleton<DocumentScanRepository>(
        () => DocumentScanRepositoryImpl(
          datasource: _getIt<DocumentScanDatasource>(),
        ),
      );
    }

    if (!_getIt.isRegistered<OcrUsecase>()) {
      _getIt.registerLazySingleton<OcrUsecase>(
        () => OcrUsecase(repository: _getIt<DocumentScanRepository>()),
      );
    }

    if (!_getIt.isRegistered<WatchDocumentRealtTimeUsecase>()) {
      _getIt.registerLazySingleton<WatchDocumentRealtTimeUsecase>(
        () => WatchDocumentRealtTimeUsecase(
          repository: _getIt<DocumentScanRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<UploadIdentityUsecase>()) {
      _getIt.registerLazySingleton<UploadIdentityUsecase>(
        () => UploadIdentityUsecase(
          repository: _getIt<DocumentScanRepository>(),
        ),
      );
    }
  }
}
