import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document/document_scan_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:partners/features/auth/document_scan/presentation/widgets/document_frame_widget.dart';
import 'package:partners/features/auth/document_scan/presentation/widgets/scan_message_widget.dart';

@RoutePage()
class DocumentScanScreen extends StatefulWidget {
  final RucType rucType;

  const DocumentScanScreen({super.key, required this.rucType});

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
  bool _isFlashEnabled = false;
  bool _hasRealtimeMonitoringStarted = false;

  late final DocumentScanCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cubit = context.read<DocumentScanCubit>();

    _cubit.initializeRucType(widget.rucType);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _cubit.stopRealtimeMonitoring();
    _loadingController.dispose();
    _cameraController?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
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

        // Esperar a que la cámara enfoque antes de iniciar el monitoreo
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted &&
              _cameraController != null &&
              _cameraController!.value.isInitialized) {
            // Intentar enfocar automáticamente
            _cameraController!.setFocusMode(FocusMode.auto);
            _cameraController!.setExposureMode(ExposureMode.auto);

            // Iniciar monitoreo después de un breve delay para permitir el enfoque
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted &&
                  _cameraController != null &&
                  _cameraController!.value.isInitialized) {
                _cubit.startRealtimeMonitoring(_cameraController!);
                _hasRealtimeMonitoringStarted = true;
              }
            });
          }
        });
      }
    } on CameraException catch (e) {
      if (mounted) {
        setState(() => _isCameraInitialized = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.description ?? e.code}')),
        );
      }
    } catch (e) {
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

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final newFlashMode = _isFlashEnabled ? FlashMode.off : FlashMode.torch;

      await _cameraController!.setFlashMode(newFlashMode);

      if (mounted) {
        setState(() {
          _isFlashEnabled = !_isFlashEnabled;
        });
      }
    } catch (e) {
      // Si hay error, simplemente no cambiamos el estado
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo cambiar el flash: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<DocumentScanCubit, DocumentScanState>(
        listener: (context, state) {
          final router = context.router;

          // Cuando el estado vuelve a initial después de un error, reiniciar el monitoreo
          // Solo si el monitoreo ya se había iniciado antes (para evitar reinicios múltiples)
          if (state.status == DocumentScanStatus.initial &&
              state.errorMessage == null &&
              _cameraController != null &&
              _cameraController!.value.isInitialized &&
              _isCameraInitialized &&
              _hasRealtimeMonitoringStarted) {
            // Esperar un momento para que la UI se actualice
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted &&
                  _cameraController != null &&
                  _cameraController!.value.isInitialized &&
                  state.status == DocumentScanStatus.initial) {
                // Re-enfocar antes de reiniciar
                _cameraController!.setFocusMode(FocusMode.auto);
                _cameraController!.setExposureMode(ExposureMode.auto);
                // Reiniciar monitoreo en tiempo real
                _cubit.startRealtimeMonitoring(_cameraController!);
              }
            });
          }

          if (state.status == DocumentScanStatus.captured &&
              state.ocrResult != null) {
            _loadingController.stop();
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                router.pop();
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
      child: Stack(
        children: [
          Column(
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
                      ScanMessageWidget(
                        state: state,
                        isCameraReady: isCameraReady,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Botón de flash en la esquina superior derecha
          Positioned(top: 24, right: 24, child: _buildFlashButton()),
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

  Widget _buildFlashButton() {
    final isCameraReady =
        _isCameraInitialized &&
        _cameraController != null &&
        _cameraController!.value.isInitialized;

    if (!isCameraReady) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _toggleFlash,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
        ),
        child: Icon(
          _isFlashEnabled ? Icons.flash_on : Icons.flash_off,
          size: 24,
          color: _isFlashEnabled ? Colors.yellow : Colors.white,
        ),
      ),
    );
  }
}
