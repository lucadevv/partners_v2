---
name: partners-performance
description: >
  Performance optimization patterns for Partners app - Container vs DecoratedBox, lazy loading, memory management.
  Trigger: Performance optimization, memory issues, rendering problems.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.0"
  scope: [performance]
  auto_invoke:
    - "Performance optimization"
    - "Container vs DecoratedBox"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Performance Overview

Performance is critical for user experience. This skill focuses on rendering optimization and memory management.

## Container vs DecoratedBox Rule

**CRITICAL: Use DecoratedBox when only decoration is needed**

### When to Use Each

```dart
// ❌ WRONG - Container only for decoration (less efficient)
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: childWidget,
)

// ✅ CORRECT - DecoratedBox for only decoration (more efficient)
DecoratedBox(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: childWidget,
)

// ✅ CORRECT - Container when you need padding + decoration
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: childWidget,
)

// ✅ CORRECT - Container when you need constraints + decoration
Container(
  width: double.infinity,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: childWidget,
)
```

### Performance Impact Analysis
```dart
// Performance comparison widget
class PerformanceComparison extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWithContainer(),  // Slower - unnecessary widget tree
        _buildWithDecoratedBox(),  // Faster - direct decoration
      ],
    );
  }
  
  Widget _buildWithContainer() {
    return Container(  // 1 extra widget in tree
      decoration: BoxDecoration(color: Colors.blue),
      child: Text('Container'),
    );
  }
  
  Widget _buildWithDecoratedBox() {
    return DecoratedBox(  // Direct decoration, no extra widget
      decoration: BoxDecoration(color: Colors.blue),
      child: Text('DecoratedBox'),
    );
  }
}
```

## List Optimization Patterns

### ListView.builder for Large Lists
```dart
// ❌ WRONG - ListView with all items (memory intensive)
ListView(
  children: items.map((item) => ListTile(title: Text(item.name))).toList(),
)

// ✅ CORRECT - ListView.builder (lazy loading)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ListTile(
      key: ValueKey(item.id),  // Important for performance
      title: Text(item.name),
    );
  },
)

// ✅ EVEN BETER - ListView.builder with const widgets
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return _ListItemWidget(  // Separate const widget when possible
      key: ValueKey(item.id),
      item: item,
    );
  },
)
```

### Optimized List Item Widget
```dart
class _ListItemWidget extends StatelessWidget {
  final ItemEntity item;
  
  const _ListItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(  // Use DecoratedBox for only decoration
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(  // Use TextTheme instead of TextStyle
              item.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 4),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Memory Management Patterns

### Dispose Controllers and Resources
```dart
class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _nameFocus;
  late FocusNode _emailFocus;
  StreamSubscription<AuthState>? _authSubscription;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    
    // Subscribe to BLoC/Cubit streams
    _authSubscription = context.read<AuthCubit>().stream.listen((state) {
      // Handle state changes
    });
  }
  
  @override
  void dispose() {
    // IMPORTANT: Dispose all resources
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _authSubscription?.cancel();
    
    super.dispose();
  }
}
```

### AutomaticKeepAliveClientMixin
```dart
class PersistentListItem extends StatefulWidget {
  final ItemEntity item;
  
  const PersistentListItem({Key? key, required this.item}) : super(key: key);
  
  @override
  _PersistentListItemState createState() => _PersistentListItemState();
}

class _PersistentListItemState extends State<PersistentListItem>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;  // Keep widget alive
  
  @override
  Widget build(BuildContext context) {
    super.build(context);  // Required by mixin
    
    return ListTile(
      title: Text(widget.item.name),
      subtitle: Text(widget.item.description),
    );
  }
}
```

## Rendering Performance

### Const Constructors
```dart
// ❌ WRONG - Non-const widgets in static contexts
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Title'),  // Could be const
        Icon(Icons.add),  // Could be const
        SizedBox(height: 16),  // Could be const
      ],
    );
  }
}

// ✅ CORRECT - Const widgets when possible
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Title'),  // Const
        Icon(Icons.add),  // Const
        SizedBox(height: 16),  // Const
      ],
    );
  }
}
```

### RepaintBoundary
```dart
class AnimatedCounter extends StatelessWidget {
  final int count;
  
  const AnimatedCounter({Key? key, required this.count}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(  // Isolate repaints
      child: Column(
        children: [
          Text('Count: $count'),
          AnimatedSwitcher(  // Only this part animates
            duration: Duration(milliseconds: 300),
            child: Text(
              '$count',
              key: ValueKey(count),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Custom Painter Optimization
```dart
class OptimizedChartPainter extends CustomPainter {
  final List<DataPoint> data;
  
  OptimizedChartPainter(this.data);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    // Optimize path drawing
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (point.value * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(OptimizedChartPainter oldDelegate) {
    // Only repaint if data actually changed
    if (data.length != oldDelegate.data.length) return true;
    
    for (int i = 0; i < data.length; i++) {
      if (data[i] != oldDelegate.data[i]) return true;
    }
    
    return false;
  }
}
```

## Image Optimization

### Cached Network Images
```dart
// ❌ WRONG - NetworkImage without caching
Image.network(
  'https://example.com/image.jpg',
  width: 100,
  height: 100,
)

// ✅ CORRECT - CachedNetworkImage with optimization
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 100,
  height: 100,
  placeholder: (context, url) => Container(
    width: 100,
    height: 100,
    color: Colors.grey[300],
    child: CircularProgressIndicator(),
  ),
  errorWidget: (context, url, error) => Container(
    width: 100,
    height: 100,
    color: Colors.grey[300],
    child: Icon(Icons.error),
  ),
  memCacheWidth: 200,  // Cache larger size
  memCacheHeight: 200,
  cacheKey: 'profile_${userId}',  // Custom cache key
)
```

### Image Memory Management
```dart
class OptimizedImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  
  const OptimizedImageGallery({Key? key, required this.imageUrls}) : super(key: key);
  
  @override
  _OptimizedImageGalleryState createState() => _OptimizedImageGalleryState();
}

class _OptimizedImageGalleryState extends State<OptimizedImageGallery> {
  final Map<String, ImageProvider> _imageCache = {};
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        final url = widget.imageUrls[index];
        
        return CachedNetworkImage(
          imageUrl: url,
          memCacheWidth: 300,
          memCacheHeight: 300,
          fit: BoxFit.cover,
        );
      },
    );
  }
  
  @override
  void dispose() {
    _imageCache.clear();
    super.dispose();
  }
}
```

## BLoC/Cubit Performance

### Efficient State Updates
```dart
class PerformanceCubit extends Cubit<PerformanceState> {
  PerformanceCubit() : super(PerformanceState.initial());
  
  // ❌ WRONG - Multiple emits in rapid succession
  void inefficientUpdate(String text) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(text: text));
    emit(state.copyWith(isLoading: false));
  }
  
  // ✅ CORRECT - Single batched emit
  void efficientUpdate(String text) {
    emit(state.copyWith(
      isLoading: false,
      text: text,
    ));
  }
  
  // ✅ EVEN BETTER - Debounced updates
  Timer? _debounceTimer;
  
  void debouncedUpdate(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      emit(state.copyWith(text: text));
    });
  }
  
  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
```

## Performance Monitoring

### Performance Overlay
```dart
class PerformanceOverlay extends StatelessWidget {
  final Widget child;
  final bool enabled;
  
  const PerformanceOverlay({
    Key? key,
    required this.child,
    this.enabled = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    
    return PerformanceOverlay.all(
      enabled: true,
      child: child,
    );
  }
}

// Usage in development
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: kDebugMode
          ? PerformanceOverlay(enabled: true, child: HomeScreen())
          : HomeScreen(),
    );
  }
}
```

### Performance Profiling
```dart
class PerformanceProfiler {
  static void profileBuild(VoidCallback buildFunction) {
    final stopwatch = Stopwatch()..start();
    
    buildFunction();
    
    stopwatch.stop();
    if (stopwatch.elapsedMilliseconds > 16) {  // 60 FPS = 16.67ms
      print('Build took ${stopwatch.elapsedMilliseconds}ms (>16ms)');
    }
  }
  
  static Widget profileWidget(Widget Function() builder) {
    return Builder(
      builder: (context) {
        PerformanceProfiler.profileBuild(() {
          return builder();
        });
        return Container();  // This line won't be reached
      },
    );
  }
}
```

## Performance Testing

### Widget Performance Tests
```dart
void main() {
  group('Performance Tests', () {
    testWidgets('Large list should build within 16ms', (WidgetTester tester) async {
      // Arrange
      final items = List.generate(1000, (index) => ItemEntity(
        id: index.toString(),
        name: 'Item $index',
      ));
      
      // Act & Measure
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(items[index].name));
              },
            ),
          ),
        ),
      );
      
      stopwatch.stop();
      
      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(100));  // Initial build can be slower
    });
    
    testWidgets('Scroll performance should be smooth', (WidgetTester tester) async {
      // Arrange
      final items = List.generate(1000, (index) => ItemEntity(
        id: index.toString(),
        name: 'Item $index',
      ));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(items[index].name));
              },
            ),
          ),
        ),
      );
      
      // Act & Measure
      final stopwatch = Stopwatch()..start();
      
      // Scroll through the entire list
      await tester.fling(
        find.byType(ListView),
        Offset(0, -1000),
        10000,
      );
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}
```

## Opacidad y transparencia (referencia: .cursor/rules/flutter_ui_pencil.mdc y arquiecture.mdc)

- **Nunca** usar `withOpacity()` (deprecated). Usar `Color.withValues(alpha: x)` con x entre 0.0 y 1.0.
- Evitar el widget **Opacity** cuando sea posible (costoso: saveLayer). Para transparencia usar color con `withValues(alpha: x)`. Para fade-in de imágenes usar `FadeInImage`; en animaciones usar `AnimatedOpacity` si hace falta.

## Related Skills

- `partners` - Project overview and navigation
- `partners-ui` - Widget performance patterns
- `partners-testing` - Performance testing
- `flutter-3` - General Flutter performance
- `state-management` - BLoC/Cubit performance