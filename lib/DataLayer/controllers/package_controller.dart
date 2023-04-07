import 'package:enk_pay_project/DataLayer/repository/package_repository.dart';

class GetAllPackage {
  Future<Map> getProduct() async {
    return await PackageRepository().getPackage();
  }

  Future<Map> getCableProduct() async {
    return await PackageRepository().getCablePackage();
  }
}
