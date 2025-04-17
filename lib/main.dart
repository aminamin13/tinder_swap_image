import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tinder_swap_image/controller.dart';
import 'package:tinder_swap_image/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: BuildCards(),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BuildCards() {
    final controller = Get.put(PagePictureController());

    return Obx(() {
      final urlImages = controller.urlImages;

      return urlImages.isEmpty
          ? Center(
            child: ElevatedButton(
              onPressed: controller.resetUsers,
              child: Text("Reset Users"),
            ),
          )
          : Stack(
            children:
                urlImages
                    .map(
                      (urlImage) => TinderCard(
                        urlImage: urlImage,
                        isFront: urlImages.last == urlImage,
                      ),
                    )
                    .toList(),
          );
    });
  }
}
