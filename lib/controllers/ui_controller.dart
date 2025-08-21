import 'package:get/get.dart';

class UiController extends GetxController {
  var currentPage = 0.obs;

  void updateCurrentPage(int page) {
    currentPage.value = page;
  }
}
