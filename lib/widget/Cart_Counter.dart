import 'dart:collection';

import 'package:basketapp/model/Product_Item.dart';
import 'package:mobx/mobx.dart';

part 'Cart_Counter.g.dart';

class Cart_Counter = _Cart_Counter with _$Cart_Counter;

abstract class _Cart_Counter with Store {
  @observable
  Observable totalPrice = Observable(0);

  @observable
  Observable itemCounter = Observable(0);

  @observable
  Observable list = Observable(new List<Product_Item>());

  @observable
  ObservableMap redeemMap = new ObservableMap<String, int>();


  @observable
  ObservableList<Product_Item> cartList = ObservableList<Product_Item>();

  @observable
  Observable redeemTotalAmount = Observable(0);

  //String x = Observable("Test");

  @action
  void setRedeemMap(String id, int amount) {
    redeemMap.length == 0
        ? redeemMap = ObservableMap<String, int>.of({id: amount})
        : redeemMap.putIfAbsent(id, () => amount);
    print(redeemMap);
    //dispose();
  }

  @action
  int getRedeemTotalAmount() {
    return redeemTotalAmount.value;
    //dispose();
  }

  @action
  void resetRedeemAmount(value) {
    redeemTotalAmount.value = value;
    print(redeemTotalAmount);
    //dispose();
  }

  @action
  void setRedeemTotalAmount(value) {
    redeemTotalAmount.value += value;
    print(redeemTotalAmount);
    //dispose();
  }

  @action
  void getTotalPrice() {
    cartList.forEach((element) {
      print(element.quantity);
      totalPrice.value +=
      (int.parse(element.price) * int.parse(element.quantity));
    });
    //return totalPrice.value;
  }

  @action
  void increment() {
    itemCounter.value++;
    //dispose();
  }

  @action
  void decrement() {
    itemCounter.value--;
    //dispose();
  }

  @action
  void addCartItemToBusket(String itemId, String itemName, String imageUrl,
      String description, String quantity, String price, String itemUniqueId) {
    final cart = Product_Item(
        itemId,
        itemName,
        imageUrl,
        description,
        quantity,
        price,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        itemUniqueId);
    //totalPrice.value += int.parse(price);
    totalPrice.value += (int.parse(price) * int.parse(quantity));
    cartList.add(cart);
    //list.value
  }


  @action
  ObservableList<Product_Item> getCart() {
    print("inside computed" + totalPrice.value.toString());
    return cartList;
  }

  @action
  void removeCartItemToBusket(String itemName) {
    cartList.removeWhere(
            (element) => element.itemName == itemName
    );
    totalPrice.value = 0;
    cartList.forEach((element) {
      //totalPrice.value += int.parse(element.price);
      totalPrice.value +=
      (int.parse(element.price) * int.parse(element.quantity));
    });
    //list.value
  }

  @action
  void clearBusketCart() {
    cartList.clear();
    totalPrice.value = 0;
  }

  @computed
  int get getTotal {
    print("inside computed" + totalPrice.value.toString());
    return totalPrice.value;
  }

  @computed
  int get getTotalRedeemValue {
    print("inside computed redeem value :: " +
        redeemTotalAmount.value.toString());
    return redeemTotalAmount.value;
  }

  @computed
  ObservableMap get getRedeemMap {
    print("inside computed redeem value :: " + redeemMap.toString());
    return redeemMap;
  }

  static final greeting = Observable('Hello World');

  final dispose = autorun((_) {
    print(greeting.value);
  });
}
