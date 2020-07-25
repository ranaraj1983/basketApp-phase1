// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cart_Counter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Cart_Counter on _Cart_Counter, Store {
  Computed<int> _$getTotalComputed;

  @override
  int get getTotal => (_$getTotalComputed ??=
          Computed<int>(() => super.getTotal, name: '_Cart_Counter.getTotal'))
      .value;
  Computed<int> _$getTotalRedeemValueComputed;

  @override
  int get getTotalRedeemValue => (_$getTotalRedeemValueComputed ??=
          Computed<int>(() => super.getTotalRedeemValue,
              name: '_Cart_Counter.getTotalRedeemValue'))
      .value;

  final _$totalPriceAtom = Atom(name: '_Cart_Counter.totalPrice');

  @override
  Observable<dynamic> get totalPrice {
    _$totalPriceAtom.reportRead();
    return super.totalPrice;
  }

  @override
  set totalPrice(Observable<dynamic> value) {
    _$totalPriceAtom.reportWrite(value, super.totalPrice, () {
      super.totalPrice = value;
    });
  }

  final _$itemCounterAtom = Atom(name: '_Cart_Counter.itemCounter');

  @override
  Observable<dynamic> get itemCounter {
    _$itemCounterAtom.reportRead();
    return super.itemCounter;
  }

  @override
  set itemCounter(Observable<dynamic> value) {
    _$itemCounterAtom.reportWrite(value, super.itemCounter, () {
      super.itemCounter = value;
    });
  }

  final _$listAtom = Atom(name: '_Cart_Counter.list');

  @override
  Observable<dynamic> get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(Observable<dynamic> value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$redeemMapAtom = Atom(name: '_Cart_Counter.redeemMap');

  @override
  ObservableMap<dynamic, dynamic> get redeemMap {
    _$redeemMapAtom.reportRead();
    return super.redeemMap;
  }

  @override
  set redeemMap(ObservableMap<dynamic, dynamic> value) {
    _$redeemMapAtom.reportWrite(value, super.redeemMap, () {
      super.redeemMap = value;
    });
  }

  final _$cartListAtom = Atom(name: '_Cart_Counter.cartList');

  @override
  ObservableList<Product_Item> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(ObservableList<Product_Item> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  final _$redeemTotalAmountAtom = Atom(name: '_Cart_Counter.redeemTotalAmount');

  @override
  Observable<dynamic> get redeemTotalAmount {
    _$redeemTotalAmountAtom.reportRead();
    return super.redeemTotalAmount;
  }

  @override
  set redeemTotalAmount(Observable<dynamic> value) {
    _$redeemTotalAmountAtom.reportWrite(value, super.redeemTotalAmount, () {
      super.redeemTotalAmount = value;
    });
  }

  final _$_Cart_CounterActionController =
  ActionController(name: '_Cart_Counter');

  @override
  void setRedeemMap(String id, int amount) {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.setRedeemMap');
    try {
      return super.setRedeemMap(id, amount);
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  int getRedeemTotalAmount() {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.getRedeemTotalAmount');
    try {
      return super.getRedeemTotalAmount();
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetRedeemAmount(dynamic value) {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.resetRedeemAmount');
    try {
      return super.resetRedeemAmount(value);
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRedeemTotalAmount(dynamic value) {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.setRedeemTotalAmount');
    try {
      return super.setRedeemTotalAmount(value);
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getTotalPrice() {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.getTotalPrice');
    try {
      return super.getTotalPrice();
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increment() {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.increment');
    try {
      return super.increment();
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement() {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.decrement');
    try {
      return super.decrement();
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addCartItemToBusket(String itemId, String itemName, String imageUrl,
      String description, String quantity, String price, String itemUniqueId) {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.addCartItemToBusket');
    try {
      return super.addCartItemToBusket(
          itemId,
          itemName,
          imageUrl,
          description,
          quantity,
          price,
          itemUniqueId);
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  ObservableList<Product_Item> getCart() {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.getCart');
    try {
      return super.getCart();
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCartItemToBusket(String itemName) {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.removeCartItemToBusket');
    try {
      return super.removeCartItemToBusket(itemName);
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearBusketCart() {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.clearBusketCart');
    try {
      return super.clearBusketCart();
    } finally {
      _$_Cart_CounterActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalPrice: ${totalPrice},
itemCounter: ${itemCounter},
list: ${list},
redeemMap: ${redeemMap},
cartList: ${cartList},
redeemTotalAmount: ${redeemTotalAmount},
getTotal: ${getTotal},
getTotalRedeemValue: ${getTotalRedeemValue}
    ''';
  }
}
