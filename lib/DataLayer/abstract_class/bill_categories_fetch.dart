import '../model/bill_categories.dart';

abstract class BillCategoriesFetch {
  List<CategoryData>? getCategories();
}
