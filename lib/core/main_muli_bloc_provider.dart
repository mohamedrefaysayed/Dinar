import 'package:dinar_store/core/data/services/locatio_service.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';

import 'package:dinar_store/features/auth/data/services/log_in_services.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_in_cubit/log_in_cubit.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:dinar_store/features/auth/presentation/view_model/store_data_cubit/store_data_cubit.dart';
import 'package:dinar_store/features/home/data/services/ads_services.dart';
import 'package:dinar_store/features/home/data/services/cart_services.dart';
import 'package:dinar_store/features/home/data/services/categories_services.dart';
import 'package:dinar_store/features/home/data/services/companies_services.dart';
import 'package:dinar_store/features/home/data/services/orders_services.dart';
import 'package:dinar_store/features/home/data/services/profile_services.dart';
import 'package:dinar_store/features/home/data/services/search_services.dart';
import 'package:dinar_store/features/home/data/services/sub_categories_services.dart';
import 'package:dinar_store/features/home/presentation/view_model/ads_cubit/ads_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/bottom_nav_cubit.dart/cubit/bottton_nav_bar_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/categories_cubit/categories_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/companies_cubit/companies_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/search_cubit/cubit/search_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_categories_cubit/sub_categories_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_category_products_cubit/sub_category_product_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_sub_categories_cubit/sub_sub_categories_cubit.dart';
import 'package:dinar_store/features/splash/presentation/view_model/manage_navigation_cubit/manage_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainMultiBlocProvider extends StatelessWidget {
  const MainMultiBlocProvider({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ManageNavigationCubit(
            secureStorage: const FlutterSecureStorage(),
          ),
        ),
        BlocProvider(
          create: (context) => LogInCubit(
              logInServices: LogInServices(
                  dioHelper: DioHelper(),
                  secureStorage: const FlutterSecureStorage())),
        ),
        BlocProvider(create: (context) => BottomNavBarCubit()),
        BlocProvider(
          create: (context) => CompaniesCubit(
              companiesServices: CompaniesServices(
            dioHelper: DioHelper(),
          )),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit(
              categoriesServices: CategoriesServices(
            dioHelper: DioHelper(),
          )),
        ),
        BlocProvider(
          create: (context) => AdsCubit(
              adsServices: AdsServices(
            dioHelper: DioHelper(),
          )),
        ),
        BlocProvider(
          create: (context) => SubCategoriesCubit(
              subCategoriesServices: SubCategoriesServices(
            dioHelper: DioHelper(),
          )),
        ),
        BlocProvider(
          create: (context) => SubSubCategoriesCubit(
              subCategoriesServices: SubCategoriesServices(
            dioHelper: DioHelper(),
          )),
        ),
        BlocProvider(
          create: (context) => SubCategoryProductCubit(
              subCategoriesServices: SubCategoriesServices(
            dioHelper: DioHelper(),
          )),
        ),
        BlocProvider(
          create: (context) => CartCubit(
              cartServices: CartServices(
            dioHelper: DioHelper(),
          )),
        ),
        BlocProvider(
          create: (context) => StoreDataCubit(
              logInServices: LogInServices(
            dioHelper: DioHelper(),
            secureStorage: const FlutterSecureStorage(),
          )),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(
            profileServices: ProfileServices(
              dioHelper: DioHelper(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => LocationCubit(
            locationServices: LocationServices(),
          ),
        ),
        BlocProvider(
          create: (context) => OrderCubit(
              ordersServices: OrdersServices(dioHelper: DioHelper())),
        ),
        BlocProvider(
          create: (context) => SearchCubit(
              searchServices: SearchServices(dioHelper: DioHelper())),
        ),
        BlocProvider(
          create: (context) => LogOutCubit(
              logInServices: LogInServices(
                  dioHelper: DioHelper(),
                  secureStorage: const FlutterSecureStorage())),
        ),
      ],
      child: child,
    );
  }
}
