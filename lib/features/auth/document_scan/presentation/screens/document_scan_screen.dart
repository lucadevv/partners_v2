import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document/document_scan_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:partners/main.dart'; // Asumiendo que getIt está aquí
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
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

  // ELIMINADO: RealtimeOcrService (Ahora está dentro del Cubit)

  late final DocumentScanCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Instanciamos el Cubit desde el Service Locator (getIt)
    // Asegúrate de que DocumentScanCubit esté registrado en main.dart
    _cubit = context.read<DocumentScanCubit>();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // IMPORTANTE: Detener el monitoreo ANTES de desechar el controller
    _cubit.stopRealtimeMonitoring();
    _loadingController.dispose();
    _cameraController?.dispose();
    // NO cerramos el cubit aquí porque puede ser reutilizado por el BlocProvider
    // El cubit se cerrará automáticamente cuando el BlocProvider se desmonte
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // IMPORTANTE: Detener el monitoreo ANTES de desechar el controller
      _cubit.stopRealtimeMonitoring();
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final status = await _requestCameraPermission();
      if (!status.isGranted) return;

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          setState(() => _isCameraInitialized = false);
        }
        return;
      }

      final selectedCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

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
            // Iniciamos el monitoreo usando el Cubit
            _cubit.startRealtimeMonitoring(_cameraController!);
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
      child: BlocListener<DocumentScanCubit, DocumentScanState>(
        listener: (context, state) {
          // Cuando el documento esté completo, navegar a la pantalla de éxito
          if (state.status == DocumentScanStatus.captured &&
              state.ocrResult != null) {
            // Detener el loading controller
            _loadingController.stop();

            // Navegar a la pantalla de éxito después de un breve delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.router.push(const DocumentSuccessRoute());
              }
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocBuilder<DocumentScanCubit, DocumentScanState>(
            builder: (context, state) {
              return SizedBox.expand(
                child: Stack(
                  children: [_buildCameraPreview(), _buildOverlay(state)],
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
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildCloseButton(),
          ),
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
                  // Usamos 'state.realtimeText' según tu Cubit y Estado definidos
                  // Mostrar el texto detectado cuando hay texto y la cámara está lista
                  if (state.realtimeText != null &&
                      state.realtimeText!.isNotEmpty &&
                      (state.status == DocumentScanStatus.cameraReady ||
                          state.status == DocumentScanStatus.processing ||
                          state.status == DocumentScanStatus.captured ||
                          state.status == DocumentScanStatus.failure))
                    DetectedTextWidget(state: state),
                ],
              ),
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
        onTap: () => context.router.pop(),
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
}
