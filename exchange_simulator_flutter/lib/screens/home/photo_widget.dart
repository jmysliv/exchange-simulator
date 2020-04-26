import 'package:flutter/material.dart';
import 'dart:math' as math;

class OvalPhoto extends StatelessWidget {
  OvalPhoto(this.maxRadius,  this.photoPath, this.onTap) : clipRectSize = 2.0 * (maxRadius / math.sqrt2);

  final double maxRadius;
  final clipRectSize;
  final VoidCallback onTap;
  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: Material(
              color: Theme.of(context).primaryColor.withOpacity(0.25),
              child: InkWell(
                onTap: onTap,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints size) {
                    return Image.asset(
                      photoPath,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}