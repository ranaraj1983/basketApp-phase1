// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cart_Counter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Cart_Counter on _Cart_Counter, Store {
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

  final _$_Cart_CounterActionController =
      ActionController(name: '_Cart_Counter');

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
  void removeCartItemToBusket(String itemId) {
    final _$actionInfo = _$_Cart_CounterActionController.startAction(
        name: '_Cart_Counter.removeCartItemToBusket');
    try {
      return super.removeCartItemToBusket(itemId);
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
cartList: ${cartList}
    ''';
  }
}
