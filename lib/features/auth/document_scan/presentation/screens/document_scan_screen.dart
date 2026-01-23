import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partners/features/auth/document_scan/presentation/screens/document_success_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document_scan_cubit.dart';
import 'package:partners/features/auth/document_scan/presentation/services/realtime_ocr_service.dart';
import 'package:partners/features/auth/document_scan/presentation/widgets/document_frame_widget.dart';
import 'package:partners/features/auth/document_scan/presentation/widgets/detected_text_widget.dart';
import 'package:partners/features/auth/document_scan/presentation/widgets/scan_message_widget.dart';

@RoutePage()
class DocumentScanScreen extends StatefulWidget {
  const DocumentScanScreen({super.key});

  @override
  State<DocumentScanScreen> createState() => _DocumentScanScreenState();
}

class _DocumentScanScreenState extends State<DocumentScanScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _loadingController;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  final RealtimeOcrService _realtimeOcr = RealtimeOcrService();
  late final DocumentScanCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cubit = DocumentScanCubit();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loadingController.dispose();
    _realtimeOcr.dispose();
    _cameraController?.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
      _realtimeOcr.stop();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Solicitar permisos
      final status = await _requestCameraPermission();
      if (!status.isGranted) return;

      // Obtener cámaras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          setState(() => _isCameraInitialized = false);
        }
        return;
      }

      // Seleccionar cámara trasera
      final selectedCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      // Inicializar cámara
      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted && _cameraController!.value.isInitialized) {
        setState(() => _isCameraInitialized = true);

        Future.microtask(() {
          if (mounted) {
            _cubit.cameraInitialized();

            // Iniciar análisis en tiempo real
            _realtimeOcr.start(
              cameraController: _cameraController!,
              cubit: _cubit,
            );
          }
        });
      }
    } on CameraException catch (e) {
      debugPrint('CameraException: ${e.code} - ${e.description}');
      if (mounted) {
        setState(() => _isCameraInitialized = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.description ?? e.code}')),
        );
      }
    } catch (e) {
      debugPrint('Error al inicializar cámara: $e');
      if (mounted) {
        setState(() => _isCameraInitialized = false);
      }
    }
  }

  Future<PermissionStatus> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      if (mounted) {
        final shouldOpen = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permiso de cámara requerido'),
            content: const Text(
              'Se necesita permiso de cámara para escanear documentos.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Abrir configuración'),
              ),
            ],
          ),
        );

        if (shouldOpen == true) {
          await openAppSettings();
        }
      }
      return status;
    }

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (mounted) {
      setState(() => _isCameraPermissionGranted = status.isGranted);
    }

    return status;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: MultiBlocListener(
          listeners: [
            BlocListener<DocumentScanCubit, DocumentScanState>(
              listener: (context, state) {
                if (state.effect is DocumentValidatedEffect) {
                  _cubit.clearEffect();
                  _realtimeOcr.stop();
                  // Usar el orquestador para manejar la navegación
                  context
                      .read<OrquestorAuthCubit>()
                      .navigateToDocumentSuccess();
                }

                if (state.status == DocumentScanStatus.captured) {
                  _realtimeOcr.stop();
                }

                if (state.status == DocumentScanStatus.failure &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                }
              },
            ),
            BlocListener<OrquestorAuthCubit, OrquestorAuthState>(
              listener: (context, state) {
                if (state.effect is NavigateToDocumentSuccessEffect) {
                  context.read<OrquestorAuthCubit>().clearEffect();
                  if (mounted) _navigateToSuccessScreen(context);
                }
              },
            ),
          ],
          child: BlocBuilder<DocumentScanCubit, DocumentScanState>(
            builder: (context, state) {
              return SizedBox.expand(
                child: Stack(
                  children: [
                    // Vista previa de la cámara (fondo)
                    _buildCameraPreview(),
                    // Overlay con controles (arriba) - siempre visible
                    _buildOverlay(state),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_isCameraInitialized &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      return SizedBox.expand(child: CameraPreview(_cameraController!));
    }

    return SizedBox.expand(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              Text(
                _isCameraPermissionGranted
                    ? (_cameraController != null
                          ? 'Configurando cámara...'
                          : 'Inicializando cámara...')
                    : 'Solicitando permisos...',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(DocumentScanState state) {
    final isCameraReady =
        _isCameraInitialized &&
        _cameraController != null &&
        _cameraController!.value.isInitialized;

    return SafeArea(
      child: Column(
        children: [
          // Botón cerrar
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildCloseButton(),
          ),
          // Contenido central
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DocumentFrameWidget(
                    state: state,
                    loadingController: _loadingController,
                  ),
                  const SizedBox(height: 24),
                  ScanMessageWidget(state: state, isCameraReady: isCameraReady),
                  if (state.textoDetectado != null &&
                      state.textoDetectado!.isNotEmpty &&
                      (state.status == DocumentScanStatus.processing ||
                          state.status == DocumentScanStatus.captured ||
                          state.status == DocumentScanStatus.failure))
                    DetectedTextWidget(state: state),
                ],
              ),
            ),
          ),
          // Botones en la parte inferior
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Botón de captura
                if (isCameraReady &&
                    state.status != DocumentScanStatus.processing &&
                    state.status != DocumentScanStatus.validating)
                  _buildCaptureButton(context, state),
                // Espaciado
                if (isCameraReady &&
                    state.status != DocumentScanStatus.processing &&
                    state.status != DocumentScanStatus.validating)
                  const SizedBox(height: 12),
                // Botón de galería - SIEMPRE VISIBLE
                _buildSelectImageButton(context, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => context.router.maybePop(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.5),
          ),
          child: const Icon(Icons.close, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCaptureButton(BuildContext context, DocumentScanState state) {
    final isProcessing =
        state.status == DocumentScanStatus.processing ||
        state.status == DocumentScanStatus.validating;

    return ElevatedButton(
      onPressed: isProcessing
          ? null
          : state.status == DocumentScanStatus.captured && state.ocrData != null
          ? () => _cubit.validateDocument()
          : () => _captureImage(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF66CFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 18),
        minimumSize: const Size(double.infinity, 56),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Icon(
            state.status == DocumentScanStatus.captured
                ? Icons.check_circle
                : Icons.camera_alt,
            color: const Color(0xFF051858),
            size: 20,
          ),
          Text(
            state.status == DocumentScanStatus.captured
                ? 'Validar Documento'
                : 'Capturar',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF051858),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cámara no inicializada')));
      return;
    }

    try {
      _realtimeOcr.stop(); // Detener análisis automático
      final image = await _cameraController!.takePicture();
      await _cubit.processDocumentImage(image.path);
    } catch (e) {
      debugPrint('Error al capturar: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Widget _buildSelectImageButton(
    BuildContext context,
    DocumentScanState state,
  ) {
    final isProcessing =
        state.status == DocumentScanStatus.processing ||
        state.status == DocumentScanStatus.validating;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF66CFFF), width: 2),
      ),
      child: OutlinedButton(
        onPressed: isProcessing
            ? null
            : () {
                _selectImageFromGallery(context);
              },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF66CFFF), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          minimumSize: const Size(double.infinity, 56),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_library, color: Color(0xFF66CFFF), size: 20),
            const SizedBox(width: 12),
            const Text(
              'Seleccionar de Galería',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF66CFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImageFromGallery(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        // Detener análisis en tiempo real
        _realtimeOcr.stop();

        // Procesar la imagen con OCR
        await _cubit.processDocumentImage(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _navigateToSuccessScreen(BuildContext context) async {
    final state = _cubit.state;
    final ocrData = state.ocrData;

    if (ocrData == null) {
      return;
    }

    // Navegar usando Navigator directamente para poder pasar el cubit
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _cubit,
          child: const DocumentSuccessScreen(),
        ),
      ),
    );

    if (result == true && mounted) {
      context.router.pop(true);
    }
  }
}
