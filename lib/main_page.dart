import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tinder_swap_image/controller.dart';

class TinderCard extends StatefulWidget {
  const TinderCard({super.key, required this.urlImage, required this.isFront});

  final String urlImage;
  final bool isFront;

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: widget.isFront ? buildFrontCard() : buildCard());

  Widget buildFrontCard() {
    final controller = Get.put(PagePictureController());
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constrains) {
          return Obx(() {
            print(widget.urlImage);

            final milliseconds = controller.isDragging.value ? 0 : 400;
            final angle = controller.angle * pi / 180;

            final center = constrains.smallest.center(Offset.zero);

            final rotateMatrix =
                Matrix4.identity()
                  ..translate(center.dx, center.dy)
                  ..rotateZ(angle)
                  ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform:
                  rotateMatrix..translate(
                    controller.position.value.dx,
                    controller.position.value.dy,
                  ),
              child: buildCard(),
            );
          });
        },
      ),
      onPanStart: (details) => controller.startPosition(details),
      onPanUpdate: (details) => controller.updatePosition(details),
      onPanEnd: (details) => controller.endPosition(),
    );
  }

  buildCard() => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.urlImage),
          fit: BoxFit.cover,
          alignment: Alignment(-0.3, 0),
        ),
      ),
    ),
  );
}
