---
name: partners-qr
description: >
  QR code patterns for Partners app - QR generation, scanning, ML Kit text recognition.
  Trigger: Adding QR generation or scanning features, ML Kit integration.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [qr]
  auto_invoke:
    - "Adding QR generation or scanning"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## QR System Overview

Partners app implements QR code generation for transactions and ML Kit-based scanning for document recognition.

## Core Components

### QR Generation
- Transaction QR codes for point issuance
- Customer QR codes for identity verification
- Branch QR codes for location check-in

### QR Scanning
- Camera-based QR code scanning
- ML Kit text recognition for documents
- OCR for receipt/invoice processing

## Domain Entities

### QR Code Entity
```dart
class QRCode extends Entity {
  final String code;
  final QRType type;
  final String? relatedId;
  final Map<String, dynamic> data;
  final DateTime? expiresAt;
  final int? scanLimit;
  final int currentScans;
  final bool isActive;
  final String? createdBy;
  final Map<String, dynamic>? metadata;
  
  const QRCode({
    required String id,
    required this.code,
    required this.type,
    this.relatedId,
    required this.data,
    this.expiresAt,
    this.scanLimit,
    this.currentScans = 0,
    this.isActive = true,
    this.createdBy,
    this.metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isScanLimitReached => scanLimit != null && currentScans >= scanLimit!;
  bool get isScannable => isActive && !isExpired && !isScanLimitReached;
  
  String get typeDisplay {
    switch (type) {
      case QRType.transaction:
        return 'Transacción';
      case QRType.customer:
        return 'Cliente';
      case QRType.branch:
        return 'Sucursal';
      case QRType.product:
        return 'Producto';
      case QRType.promotion:
        return 'Promoción';
    }
  }
  
  double get scanProgress {
    if (scanLimit == null) return 0.0;
    return currentScans / scanLimit!;
  }
}
```

### Scan Result Entity
```dart
class ScanResult extends Entity {
  final String scannedCode;
  final QRType? codeType;
  final QRCode? qrCode;
  final String? recognizedText;
  final List<TextBlock>? textBlocks;
  final ScanStatus status;
  final String? errorMessage;
  final Map<String, dynamic>? scanData;
  final DateTime scannedAt;
  
  const ScanResult({
    required String id,
    required this.scannedCode,
    this.codeType,
    this.qrCode,
    this.recognizedText,
    this.textBlocks,
    required this.status,
    this.errorMessage,
    this.scanData,
    required this.scannedAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: scannedAt, updatedAt: updatedAt);
  
  // Business logic
  bool get isSuccessful => status == ScanStatus.success;
  bool get isQRCode => qrCode != null;
  bool get isTextRecognition => recognizedText != null && recognizedText!.isNotEmpty;
  bool get hasError => status == ScanStatus.error;
}
```

## Use Cases

### Generate QR Use Case
```dart
class GenerateQRUseCase implements UseCase<QRCode, GenerateQRParams> {
  final QRRepository _qrRepository;
  final AuthManager _authManager;
  
  GenerateQRUseCase(this._qrRepository, this._authManager);
  
  @override
  Future<Either<QRFailure, QRCode>> call(GenerateQRParams params) async {
    // Check permissions
    final currentUser = await _authManager.getCurrentUser();
    if (currentUser == null || !_canGenerateQR(currentUser.role, params.type)) {
      return Left(QRFailure.insufficientPermissions);
    }
    
    // Validate parameters
    final validationError = _validateQRParams(params);
    if (validationError != null) {
      return Left(QRFailure.invalidData(validationError));
    }
    
    try {
      // Generate QR data
      final qrData = _buildQRData(params);
      
      // Generate QR code
      final qrCode = QRCode(
        id: _generateQRId(),
        code: _generateQRString(qrData),
        type: params.type,
        relatedId: params.relatedId,
        data: qrData,
        expiresAt: params.expiresAt,
        scanLimit: params.scanLimit,
        isActive: true,
        createdBy: currentUser.id,
        metadata: params.metadata,
        createdAt: DateTime.now(),
      );
      
      final createdQR = await _qrRepository.createQRCode(qrCode);
      
      return Right(createdQR);
    } catch (e) {
      return Left(QRFailure.custom('Failed to generate QR: $e'));
    }
  }
  
  Map<String, dynamic> _buildQRData(GenerateQRParams params) {
    switch (params.type) {
      case QRType.transaction:
        return {
          'type': 'transaction',
          'transactionId': params.relatedId,
          'amount': params.data['amount'],
          'description': params.data['description'],
          'generatedAt': DateTime.now().toIso8601String(),
        };
        
      case QRType.customer:
        return {
          'type': 'customer',
          'customerId': params.relatedId,
          'name': params.data['name'],
          'email': params.data['email'],
          'verifiedAt': null,
        };
        
      case QRType.branch:
        return {
          'type': 'branch',
          'branchId': params.relatedId,
          'name': params.data['name'],
          'address': params.data['address'],
          'coordinates': {
            'latitude': params.data['latitude'],
            'longitude': params.data['longitude'],
          },
        };
        
      default:
        return params.data;
    }
  }
  
  String _generateQRString(Map<String, dynamic> data) {
    return base64.encode(utf8.encode(json.encode(data)));
  }
  
  String? _validateQRParams(GenerateQRParams params) {
    if (params.type == null) return 'El tipo de QR es requerido';
    if (params.data.isEmpty) return 'Los datos del QR son requeridos';
    
    switch (params.type) {
      case QRType.transaction:
        if (params.relatedId == null) return 'El ID de transacción es requerido';
        if (params.data['amount'] == null) return 'El monto es requerido';
        break;
        
      case QRType.customer:
        if (params.relatedId == null) return 'El ID de cliente es requerido';
        if (params.data['name'] == null) return 'El nombre es requerido';
        break;
        
      case QRType.branch:
        if (params.relatedId == null) return 'El ID de sucursal es requerido';
        if (params.data['latitude'] == null || params.data['longitude'] == null) {
          return 'Las coordenadas son requeridas';
        }
        break;
    }
    
    return null;
  }
  
  bool _canGenerateQR(UserRole role, QRType qrType) {
    switch (qrType) {
      case QRType.transaction:
      case QRType.customer:
        return role == UserRole.admin || role == UserRole.manager || role == UserRole.worker;
      case QRType.branch:
        return role == UserRole.admin || role == UserRole.manager;
      default:
        return role == UserRole.admin;
    }
  }
}
```

### Scan QR Use Case
```dart
class ScanQRUseCase implements UseCase<ScanResult, ScanQRParams> {
  final QRRepository _qrRepository;
  final CameraService _cameraService;
  final MLKitService _mlKitService;
  final AuthManager _authManager;
  
  ScanQRUseCase(
    this._qrRepository,
    this._cameraService,
    this._mlKitService,
    this._authManager,
  );
  
  @override
  Future<Either<QRFailure, ScanResult>> call(ScanQRParams params) async {
    // Check permissions
    final currentUser = await _authManager.getCurrentUser();
    if (currentUser == null) {
      return Left(QRFailure.authenticationRequired);
    }
    
    try {
      // Initialize camera
      await _cameraService.initialize();
      
      // Process image based on scan mode
      late ScanResult result;
      
      if (params.useMLKit) {
        result = await _scanWithMLKit(params.imagePath);
      } else {
        result = await _scanQRCode(params.imagePath);
      }
      
      // Save scan result
      await _qrRepository.saveScanResult(result);
      
      return Right(result);
    } on CameraException catch (e) {
      return Left(QRFailure.cameraError(e.message));
    } on MLKitException catch (e) {
      return Left(QRFailure.mlKitError(e.message));
    } catch (e) {
      return Left(QRFailure.custom('Failed to scan: $e'));
    }
  }
  
  Future<ScanResult> _scanWithMLKit(String imagePath) async {
    // ML Kit text recognition
    final recognizedText = await _mlKitService.recognizeText(imagePath);
    final textBlocks = await _mlKitService.extractTextBlocks(imagePath);
    
    // Try to find QR pattern in recognized text
    final qrMatch = _findQRPattern(recognizedText);
    if (qrMatch != null) {
      return await _processQRCode(qrMatch);
    }
    
    // Return text recognition result
    return ScanResult(
      id: _generateScanResultId(),
      scannedCode: recognizedText,
      recognizedText: recognizedText,
      textBlocks: textBlocks,
      status: ScanStatus.success,
      scannedAt: DateTime.now(),
    );
  }
  
  Future<ScanResult> _scanQRCode(String imagePath) async {
    final scannedCode = await _cameraService.scanQRCode(imagePath);
    
    if (scannedCode.isEmpty) {
      return ScanResult(
        id: _generateScanResultId(),
        scannedCode: '',
        status: ScanStatus.noQRFound,
        errorMessage: 'No QR code found in image',
        scannedAt: DateTime.now(),
      );
    }
    
    return await _processQRCode(scannedCode);
  }
  
  Future<ScanResult> _processQRCode(String scannedCode) async {
    // Try to decode QR data
    try {
      final decodedData = json.decode(utf8.decode(base64.decode(scannedCode)));
      
      // Validate QR structure
      if (!_isValidQRData(decodedData)) {
        return ScanResult(
          id: _generateScanResultId(),
          scannedCode: scannedCode,
          status: ScanStatus.invalidQR,
          errorMessage: 'Invalid QR code format',
          scannedAt: DateTime.now(),
        );
      }
      
      // Find QR in database
      final qrCode = await _qrRepository.getQRByCode(scannedCode);
      if (qrCode == null) {
        return ScanResult(
          id: _generateScanResultId(),
          scannedCode: scannedCode,
          status: ScanStatus.qrNotFound,
          errorMessage: 'QR code not found in system',
          scannedAt: DateTime.now(),
        );
      }
      
      // Check if QR is valid
      if (!qrCode.isScannable) {
        String errorMessage = 'QR code is not valid';
        if (qrCode.isExpired) errorMessage = 'QR code has expired';
        if (qrCode.isScanLimitReached) errorMessage = 'QR code scan limit reached';
        
        return ScanResult(
          id: _generateScanResultId(),
          scannedCode: scannedCode,
          qrCode: qrCode,
          status: ScanStatus.invalidQR,
          errorMessage: errorMessage,
          scannedAt: DateTime.now(),
        );
      }
      
      // Update QR scan count
      await _qrRepository.incrementScanCount(qrCode.id);
      
      return ScanResult(
        id: _generateScanResultId(),
        scannedCode: scannedCode,
        qrCode: qrCode,
        codeType: qrCode.type,
        scanData: decodedData,
        status: ScanStatus.success,
        scannedAt: DateTime.now(),
      );
      
    } catch (e) {
      return ScanResult(
        id: _generateScanResultId(),
        scannedCode: scannedCode,
        status: ScanStatus.error,
        errorMessage: 'Failed to process QR code: $e',
        scannedAt: DateTime.now(),
      );
    }
  }
  
  String? _findQRPattern(String text) {
    // Look for base64 encoded JSON pattern
    final qrPattern = RegExp(r'[A-Za-z0-9+/=]{20,}');
    final match = qrPattern.firstMatch(text);
    return match?.group(0);
  }
  
  bool _isValidQRData(dynamic data) {
    if (data is! Map) return false;
    
    final qrMap = data as Map<String, dynamic>;
    return qrMap.containsKey('type') && 
           qrMap['type'] is String &&
           ['transaction', 'customer', 'branch', 'product', 'promotion'].contains(qrMap['type']);
  }
}
```

## Repository Patterns

### QR Repository Interface
```dart
abstract class QRRepository {
  Future<Either<QRFailure, QRCode>> createQRCode(QRCode qrCode);
  Future<Either<QRFailure, QRCode?>> getQRByCode(String code);
  Future<Either<QRFailure, List<QRCode>>> getQRCodes({
    String? relatedId,
    QRType? type,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int page = 1,
    int limit = 20,
  });
  
  Future<Either<QRFailure, void>> updateQRCode(QRCode qrCode);
  Future<Either<QRFailure, void>> deactivateQRCode(String qrCodeId);
  Future<Either<QRFailure, void>> incrementScanCount(String qrCodeId);
  Future<Either<QRFailure, void>> saveScanResult(ScanResult scanResult);
  Future<Either<QRFailure, List<ScanResult>>> getScanHistory({
    String? qrCodeId,
    DateTime? scannedAfter,
    DateTime? scannedBefore,
    int page = 1,
    int limit = 20,
  });
}
```

## UI Patterns

### QR Scanner Widget
```dart
class QRScannerWidget extends StatefulWidget {
  final Function(ScanResult) onScanResult;
  final bool useMLKit;
  final String? title;
  final String? subtitle;
  
  const QRScannerWidget({
    Key? key,
    required this.onScanResult,
    this.useMLKit = false,
    this.title,
    this.subtitle,
  }) : super(key: key);
  
  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  CameraController? _cameraController;
  bool _isScanning = false;
  bool _isProcessing = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      
      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      setState(() => _errorMessage = 'Failed to initialize camera: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return ErrorStateWidget(
        message: _errorMessage!,
        onRetry: _initializeCamera,
      );
    }
    
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return LoadingWidget(message: 'Initializing camera...');
    }
    
    return Stack(
      children: [
        CameraPreview(_cameraController!),
        _buildOverlay(),
        _buildControls(),
      ],
    );
  }
  
  Widget _buildOverlay() {
    return CustomPaint(
      size: Size.infinite,
      painter: QRScannerPainter(),
    );
  }
  
  Widget _buildControls() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
          ],
          if (widget.subtitle != null) ...[
            Text(
              widget.subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                text: widget.useMLKit ? 'Escanear Documento' : 'Escanear QR',
                onPressed: _isProcessing ? null : _scan,
                isLoading: _isProcessing,
              ),
              CustomButton(
                text: 'Galería',
                onPressed: _isProcessing ? null : _pickFromGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Future<void> _scan() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    try {
      final image = await _cameraController!.takePicture();
      final scanResult = await GetIt.instance<ScanQRUseCase>()(
        ScanQRParams(
          imagePath: image.path,
          useMLKit: widget.useMLKit,
        ),
      );
      
      scanResult.fold(
        (error) => setState(() => _errorMessage = error.message),
        (result) {
          widget.onScanResult(result);
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      setState(() => _errorMessage = 'Scan failed: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }
  
  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => _isProcessing = true);
      
      try {
        final scanResult = await GetIt.instance<ScanQRUseCase>()(
          ScanQRParams(
            imagePath: image.path,
            useMLKit: widget.useMLKit,
          ),
        );
        
        scanResult.fold(
          (error) => setState(() => _errorMessage = error.message),
          (result) {
            widget.onScanResult(result);
            Navigator.of(context).pop();
          },
        );
      } catch (e) {
        setState(() => _errorMessage = 'Scan failed: $e');
      } finally {
        setState(() => _isProcessing = false);
      }
    }
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
```

### QR Generator Widget
```dart
class QRGeneratorWidget extends StatefulWidget {
  final QRType type;
  final Map<String, dynamic> data;
  final String? relatedId;
  final Function(QRCode) onQRGenerated;
  
  const QRGeneratorWidget({
    Key? key,
    required this.type,
    required this.data,
    this.relatedId,
    required this.onQRGenerated,
  }) : super(key: key);
  
  @override
  _QRGeneratorWidgetState createState() => _QRGeneratorWidgetState();
}

class _QRGeneratorWidgetState extends State<QRGeneratorWidget> {
  bool _isGenerating = false;
  String? _errorMessage;
  QRCode? _generatedQR;
  
  Future<void> _generateQR() async {
    if (_isGenerating) return;
    
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });
    
    try {
      final result = await GetIt.instance<GenerateQRUseCase>()(
        GenerateQRParams(
          type: widget.type,
          data: widget.data,
          relatedId: widget.relatedId,
          scanLimit: 1,
        ),
      );
      
      result.fold(
        (error) => setState(() => _errorMessage = error.message),
        (qrCode) {
          setState(() {
            _generatedQR = qrCode;
            _isGenerating = false;
          });
          widget.onQRGenerated(qrCode);
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate QR: $e';
        _isGenerating = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_errorMessage != null) ...[
          Text(
            _errorMessage!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: 16),
        ],
        
        if (_generatedQR != null) ...[
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'QR Code Generated',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                QrImageView(
                  data: _generatedQR!.code,
                  version: QrVersions.auto,
                  size: 200.0,
                  embeddedImageStyle: QrEmbeddedImageStyle(),
                  embeddedImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(height: 16),
                Text(
                  'Type: ${_generatedQR!.typeDisplay}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (_generatedQR!.expiresAt != null) ...[
                  Text(
                    'Expires: ${_generatedQR!.expiresAt}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          CustomButton(
            text: 'Generate QR Code',
            onPressed: _isGenerating ? null : _generateQR,
            isLoading: _isGenerating,
          ),
        ],
      ],
    );
  }
}
```

## ML Kit Integration

### Text Recognition Service
```dart
class MLKitServiceImpl implements MLKitService {
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  
  @override
  Future<String> recognizeText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw MLKitException('Failed to recognize text: $e');
    }
  }
  
  @override
  Future<List<TextBlock>> extractTextBlocks(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      return recognizedText.blocks.map((block) {
        return TextBlock(
          text: block.text,
          boundingBox: block.boundingBox,
          confidence: block.confidence,
          language: block.recognizedLanguages.first,
        );
      }).toList();
    } catch (e) {
      throw MLKitException('Failed to extract text blocks: $e');
    }
  }
  
  @override
  void dispose() {
    _textRecognizer.close();
  }
}
```

## Related Skills

- `partners` - Project overview and navigation
- `partners-domain` - QR domain entities and use cases
- `partners-data` - QR data sources and models
- `partners-ui` - QR UI patterns
- `partners-testing` - QR testing
- `partners-auth` - Document validation integration
- `state-management` - QR BLoC/Cubit patterns