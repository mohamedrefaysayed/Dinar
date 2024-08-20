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
        cartItemsModel = cartItems;
        cartItems.cart = await summedItemsFunc(cartItems: cartItems.cart!);
        await countTotal(items: cartItems.cart!);

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
            double productCount =
                ((quantity / (requiredProducts[i].pivot!.quantity!)).floor() *
                    requiredProducts[i].pivot!.requiredQuantiy! *
                    1.0);

            await storeItem(
              productId: requiredProducts[i].id!,
              quantity: productCount.toInt(),
              unitId: requiredProducts[i].pivot!.requiredUnitId!,
              price: requiredProducts[i].pivot!.requiredUnitId! ==
                      requiredProducts[i].retailUnit!.id
                  ? (requiredProducts[i].retailPrice! * 1.0)
                  : (requiredProducts[i].wholeSalePrice! * 1.0),
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
      totalPrice = totalPrice + element.price!;
      totalDiscount = totalDiscount +
          (((element.price!) / 100) * element.product!.discount!) *
              element.quantity!;
    }

    finalPrice = totalPrice - totalDiscount;
  }

  Future<List<CartItem>> summedItemsFunc({
    required List<CartItem> cartItems,
  }) async {
    // Create a new list of CartItem
    List<CartItem> summedItems = [];

    // Iterate over the original list
    for (var item in cartItems) {
      // Check if the new list already contains an item with the same productId
      item.isRetailed = item.quantity! <= item.product!.maxRetailQuantity!;
      var existingItem = summedItems.firstWhere(
        (i) => (i.productId == item.productId &&
            i.unitId == item.unitId &&
            i.isRetailed == item.isRetailed),
        orElse: () =>
            CartItem(updating: false, loading: false, isRetailed: false),
      );

      // If it does, increase the quantity of that item
      if (existingItem.productId != null && existingItem.unitId != null) {
        summedItems
            .firstWhere(
              (i) => (i.productId == item.productId &&
                  i.unitId == item.unitId &&
                  i.isRetailed == item.isRetailed),
              orElse: () =>
                  CartItem(updating: false, loading: false, isRetailed: false),
            )
            .quantity = summedItems
                .firstWhere(
                  (i) => (i.productId == item.productId &&
                      i.unitId == item.unitId &&
                      i.isRetailed == item.isRetailed),
                  orElse: () => CartItem(
                      updating: false, loading: false, isRetailed: false),
                )
                .quantity! +
            item.quantity!;
        summedItems
            .firstWhere(
              (i) => (i.productId == item.productId &&
                  i.unitId == item.unitId &&
                  i.isRetailed == item.isRetailed),
              orElse: () =>
                  CartItem(updating: false, loading: false, isRetailed: false),
            )
            .price = summedItems
                .firstWhere(
                  (i) => (i.productId == item.productId &&
                      i.unitId == item.unitId &&
                      i.isRetailed == item.isRetailed),
                  orElse: () => CartItem(
                      updating: false, loading: false, isRetailed: false),
                )
                .price! +
            item.price!;
      } else {
        // If it doesn't, add the item to the new list
        summedItems.add(item);
      }
    }

    // Replace the original list with the new list
    return summedItems;
  }
}
