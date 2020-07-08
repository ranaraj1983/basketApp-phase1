import 'package:basketapp/model/Product_Item.dart';

class Category {
  String categoryId;
  String categoryName;
  String categoryImageUrl;
  List<Product_Item> itemList;

  Category(
      this.categoryId, this.categoryName, this.categoryImageUrl, this.itemList);
}
