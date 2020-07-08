

import 'package:basketapp/model/ItemProduct.dart';
import 'package:mobx/mobx.dart';
part 'Cart.g.dart';

class Cart extends _Cart with _$Cart{
  Cart(ObservableList<ItemProduct> cartList) : super(cartList);
}
abstract class _Cart with Store{
  _Cart(_cartList);

  @observable
  ObservableList<ItemProduct> _cartList = new ObservableList<ItemProduct>();
  @observable
  ObservableList<ItemProduct> get cartList => _cartList;
  @observable
  Observable counter = Observable(0);



  @computed
  List<ItemProduct> get uniProduct => ObservableList.of(_cartList).toSet().toList();

  @action
  void addItemToCartList(ItemProduct itemProduct){
    _cartList.add(itemProduct);
  }

  @action
  ObservableList<ItemProduct>  getCartList(){
    return _cartList;
  }

  @action
  void increment(){
    counter.value++;
  }

}


