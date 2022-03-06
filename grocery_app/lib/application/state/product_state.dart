import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocery_app/models/product.dart';
part 'product_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  factory ProductsState({
    @Default(<Product>[]) List<Product> products,
    @Default(true) bool hasNext,
    @Default(false) bool isLoading,
  }) = _ProductsState;
}
