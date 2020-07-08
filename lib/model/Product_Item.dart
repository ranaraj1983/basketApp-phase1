class Product_Item {
  String itemUniqueId;
  String itemId;
  String itemName;
  String imageUrl;
  String description;
  String quantity;
  String price;
  String orderStatus;
  String paymentOption;
  String totalAmount;
  String location;
  String orderDateTime;
  String unit;
  String brand;

  Product_Item(this.itemId,
      this.itemName,
      this.imageUrl,
      this.description,
      this.quantity,
      this.price,
      this.orderStatus,
      this.paymentOption,
      this.totalAmount,
      this.location,
      this.orderDateTime,
      this.unit,
      this.brand,
      this.itemUniqueId);
}
