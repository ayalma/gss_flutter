import 'package:flutter/material.dart';

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

/// A My that has a My geometry based on the values stored in a
/// [MyOverlapAbsorberHandle].
///
/// The [MyOverlapAbsorber] must be an earlier descendant of a common
/// ancestor [Viewport], so that it will always be laid out before the
/// [MyOverlapInjector] during a particular frame.
///
/// See also:
///
///  * [NestedScrollView], which uses a [MyOverlapAbsorber] to align its
///    children, and which shows sample usage for this class.
class MyOverlapInjector extends SingleChildRenderObjectWidget {
  /// Creates a My that is as tall as the value of the given [handle]'s
  /// layout extent.
  ///
  /// The [handle] must not be null.
  const MyOverlapInjector({
    Key key,
    @required this.handle,
    Widget child,
  })  : assert(handle != null),
        super(key: key, child: child);

  /// The handle to the [MyOverlapAbsorber] that is feeding this injector.
  ///
  /// This should be a handle owned by a [MyOverlapAbsorber] and a
  /// [NestedScrollViewViewport].
  final SliverOverlapAbsorberHandle handle;

  @override
  RenderMyOverlapInjector createRenderObject(BuildContext context) {
    return RenderMyOverlapInjector(
      handle: handle,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderMyOverlapInjector renderObject) {
    renderObject..handle = handle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<SliverOverlapAbsorberHandle>('handle', handle));
  }
}

/// A My that has a My geometry based on the values stored in a
/// [MyOverlapAbsorberHandle].
///
/// The [RenderMyOverlapAbsorber] must be an earlier descendant of a common
/// ancestor [RenderViewport] (probably a [RenderNestedScrollViewViewport]), so
/// that it will always be laid out before the [RenderMyOverlapInjector]
/// during a particular frame.
class RenderMyOverlapInjector extends RenderBox {
  /// Creates a My that is as tall as the value of the given [handle]'s extent.
  ///
  /// The [handle] must not be null.
  RenderMyOverlapInjector({
    @required SliverOverlapAbsorberHandle handle,
  })  : assert(handle != null),
        _handle = handle;

  double _currentLayoutExtent;
  double _currentMaxExtent;

  /// The object that specifies how wide to make the gap injected by this render
  /// object.
  ///
  /// This should be a handle owned by a [RenderMyOverlapAbsorber] and a
  /// [RenderNestedScrollViewViewport].
  SliverOverlapAbsorberHandle get handle => _handle;
  SliverOverlapAbsorberHandle _handle;

  set handle(SliverOverlapAbsorberHandle value) {
    assert(value != null);
    if (handle == value) return;
    if (attached) {
      handle.removeListener(markNeedsLayout);
    }
    _handle = value;
    if (attached) {
      handle.addListener(markNeedsLayout);
      if (handle.layoutExtent != _currentLayoutExtent ||
          handle.scrollExtent != _currentMaxExtent) markNeedsLayout();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    handle.addListener(markNeedsLayout);
    if (handle.layoutExtent != _currentLayoutExtent ||
        handle.scrollExtent != _currentMaxExtent) markNeedsLayout();
  }

  @override
  void detach() {
    handle.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void performLayout() {
    _currentLayoutExtent = handle.layoutExtent;
    _currentMaxExtent = handle.layoutExtent;

      size = Size(constraints.biggest.width, _currentLayoutExtent);
  }

  /* @override
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      if (debugPaintSizeEnabled) {
        final Paint paint = Paint()
          ..color = const Color(0xFFCC9933)
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke;
        Offset start, end, delta;
        switch (constraints.axis) {
          case Axis.vertical:
            final double x = offset.dx + constraints.crossAxisExtent / 2.0;
            start = Offset(x, offset.dy);
            end = Offset(x, offset.dy + geometry.paintExtent);
            delta = Offset(constraints.crossAxisExtent / 5.0, 0.0);
            break;
          case Axis.horizontal:
            final double y = offset.dy + constraints.crossAxisExtent / 2.0;
            start = Offset(offset.dx, y);
            end = Offset(offset.dy + geometry.paintExtent, y);
            delta = Offset(0.0, constraints.crossAxisExtent / 5.0);
            break;
        }
        for (int index = -2; index <= 2; index += 1) {
          paintZigZag(context.canvas, paint, start - delta * index.toDouble(), end - delta * index.toDouble(), 10, 10.0);
        }
      }
      return true;
    }());
  }*/

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<SliverOverlapAbsorberHandle>('handle', handle));
  }
}
