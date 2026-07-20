import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollableFadeColumn extends StatelessWidget {
  const ScrollableFadeColumn({
    super.key,
    required this.height,
    required this.itemBuilder,
    required this.itemCount,
    this.emptyWidget,
  });

  final double height;
  final int? itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, 0.075, 0.925, 1.0],
        ).createShader(bounds);
      },
      child: Column(
        children: [
          itemCount == 0
              ? emptyWidget
                        ?.animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms)
                        .moveY(begin: -5, end: 0) ??
                    SizedBox()
              : SizedBox(),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 0, maxHeight: height),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              physics: BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
