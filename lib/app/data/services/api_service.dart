import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';

abstract class ApiService<T> extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = "https://jsonplaceholder.typicode.com";
    super.onInit();
  }

  String get endpoint;

  Future<Either<String, List<T>>> fetchAll() async {
    try {
      final res = await get(endpoint);
      final list = (res.body as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } catch (e) {
      return left(e.toString());
    }
  }

  T fromJson(Map<String, dynamic> json);
}
