import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

enum CardStatus { like, dislike, superLike }

class PagePictureController extends GetxController {
  static PagePictureController get instance => Get.find();

  var urlImages = <String>[].obs;

  var position = Offset.zero.obs;
  var isDragging = false.obs;
  var screenSize = Size.zero.obs;
  var angle = 0.0.obs;
  var isScreenSizeReady = false.obs;

  List<String> get getUrlImages => urlImages;
  bool get getIsDragging => isDragging.value;
  Offset get getPosition => position.value;
  double get getAngle => angle.value;

  void setScreenSize(Size size) => screenSize.value = size;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(Get.context!).size;
      setScreenSize(size);
      resetUsers();
    });
  }

  void startPosition(DragStartDetails details) {
    isDragging.value = true;

    update();
  }

  void updatePosition(DragUpdateDetails details) {
    isDragging.value = true;
    position.value += details.delta;
    final x = position.value.dx;

    angle.value = 45 * x / screenSize.value.width;

    update();
  }

  void endPosition() {
    isDragging.value = false;
    update();
    final status = getStatus();

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split('.').last.toLowerCase(),
        fontSize: 36,
      );
    }

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superLike:
        superlike();
        break;
      default:
        resetPosition();
    }
    update();
  }

  void resetPosition() {
    isDragging.value = false;
    position.value = Offset.zero;
    angle.value = 0;

    update();
  }

  void resetUsers() {
    urlImages.value =
        <String>[
          "assets/1.jpg",
          "assets/2.jpg",
          "assets/3.jpg",
        ].reversed.toList();

    // No need for update() if using Obx widgets, but if using GetBuilder — keep it.
    update();
  }

  CardStatus? getStatus() {
    final x = position.value.dx;
    final y = position.value.dy;

    final detla = 100.obs;

    final forceSuperLike = x.abs() < 20;

    if (x >= detla.value) {
      return CardStatus.like;
    } else if (x <= -detla) {
      return CardStatus.dislike;
    } else if (y <= -detla / 2 && forceSuperLike) {
      return CardStatus.superLike;
    }
    return CardStatus.like;
  }

  void like() {
    angle.value = 20;
    _nextCard();

    position.value += Offset(2 * screenSize.value.width, 0);
  }

  Future _nextCard() async {
    if (urlImages.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 300));
    urlImages.removeLast();
    resetPosition();
  }

  void dislike() {
    angle.value = -20;
    _nextCard();

    position.value -= Offset(2 * screenSize.value.width, 0);
  }

  void superlike() {
    angle.value = 0;
    _nextCard();

    position.value -= Offset(0, screenSize.value.height);
  }
}
