import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/cart_items_model.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/data/services/cart_services.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required CartServices cartServices}) : super(CartInitial()) {
    _cartServices = cartServices;
  }

  late CartServices _cartServices;

  static CartItemsModel? cartItemsModel;

  static double totalPrice = 0;
  static double totalDiscount = 0;

  static double finalPrice = 0;

  static bool retailIsDone = true;
  static bool wholeIsDone = true;

  Future<void> getAllItems() async {
    cartItemsModel == null ? emit(GetCartLoading()) : null;
    Either<ServerFailure, CartItemsModel> result =
        await _cartServices.getAllItems(
      token: AppCubit.token!,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          GetCartFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (cartItems) async {
        await countTotal(items: cartItems.cart!);
        cartItemsModel = cartItems;
        emit(GetCartSuccess(cartItemsModel: cartItems));
      },
    );
  }

  Future<void> storeItem({
    required int productId,
    required int quantity,
    required int unitId,
    required double price,
    required String isRequired,
    required bool isLast,
    int? refrenceId,
    required List<RequiredProducts> requiredProducts,
  }) async {
    emit(AddToCartLoading());
    Either<ServerFailure, int> result = await _cartServices.storeItem(
      token: AppCubit.token!,
      productId: productId,
      quantity: quantity,
      unitId: unitId,
      price: price,
      isRequired: isRequired,
      refrenceId: refrenceId,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          AddToCartFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (refId) async {
        if (isLast && retailIsDone && wholeIsDone) {
          emit(AddToCartSuccess());
        }
        if (isRequired == '0') {
          for (int i = 0; i < requiredProducts.length; i++) {
            double productCount = ((quantity /
                        (double.parse(requiredProducts[i].pivot!.quantity!)))
                    .floor() *
                double.parse(requiredProducts[i].pivot!.requiredQuantiy!));

            await storeItem(
              productId: requiredProducts[i].id!,
              quantity: productCount.toInt(),
              unitId: int.parse(requiredProducts[i].pivot!.requiredUnitId!),
              price: requiredProducts[i].pivot!.requiredUnitId! ==
                      requiredProducts[i].retailUnit!.id.toString()
                  ? double.parse(requiredProducts[i].retailPrice!)
                  : double.parse(requiredProducts[i].wholeSalePrice!),
              isRequired: '1',
              isLast: requiredProducts.length - 1 == i,
              requiredProducts: [],
              refrenceId: refId,
            );
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      },
    );
  }

  updateItem({
    required int productId,
    required int quantity,
    required int unitId,
    required double price,
    required String isRequired,
    required int itemId,
  }) async {
    emit(UpdateItemLoading());
    Either<ServerFailure, CartItemsModel> result =
        await _cartServices.updateItem(
      token: AppCubit.token!,
      productId: productId,
      quantity: quantity,
      unitId: unitId,
      price: price,
      isRequired: isRequired,
      itemId: itemId,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          UpdateItemFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (cartItemsModel) async {
        countTotal(items: cartItemsModel.cart!);
        emit(UpdateItemSuccess(cartItemsModel: cartItemsModel));
      },
    );
  }

  deleteItem({
    required int itemId,
  }) async {
    emit(DeleteItemLoading());
    Either<ServerFailure, CartItemsModel> result =
        await _cartServices.deleteItem(
      token: AppCubit.token!,
      itemId: itemId,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          DeleteItemFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (cartItemsModel) async {
        countTotal(items: cartItemsModel.cart!);
        emit(DeleteItemSuccess(cartItemsModel: cartItemsModel));
      },
    );
  }

  Future<void> countTotal({
    required List<CartItem> items,
  }) async {
    totalPrice = 0;
    totalDiscount = 0;
    for (var element in items) {
      totalPrice = totalPrice +
          (double.parse(element.price!) * double.parse(element.quantity!));
      totalDiscount = totalDiscount +
          (((double.parse(element.price!) / 100) *
                  double.parse(element.product!.discount!)) *
              double.parse(element.quantity!));
    }
    finalPrice = totalPrice - totalDiscount;
  }

  Future<void> mergeSameProducts({
    required List<CartItem> items,
  }) async {
    Map<CartItem, int> uniqeItems = {};

    for (var element in items) {
      uniqeItems[element] = uniqeItems.containsKey(element)
          ? uniqeItems[element]! + double.parse(element.quantity!).toInt()
          : double.parse(element.quantity!).toInt();
    }
    uniqeItems.forEach((key, value) {
      key.quantity = value.toString();
    });
    cartItemsModel = CartItemsModel(cart: uniqeItems.keys.toList());
  }
}
