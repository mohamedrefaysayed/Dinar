import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/category_container.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/categories_place_holder_home.dart';
import 'package:dinar_store/features/home/presentation/view_model/categories_cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesViewHome extends StatefulWidget {
  const CategoriesViewHome({super.key});

  @override
  State<CategoriesViewHome> createState() => _CategoriesViewHomeState();
}

class _CategoriesViewHomeState extends State<CategoriesViewHome> {
  @override
  void initState() {
    context.read<CategoriesCubit>().getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesFaliuer) {
          ScaffoldMessenger.of(context).showSnackBar(
            messageSnackBar(
              message: state.errMessage,
              isBottomNavBar: true,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CategoriesSuccess) {
          return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.categoriesModel.categories!.length,
              itemBuilder: (context, index) {
                final Categories category =
                    state.categoriesModel.categories![index];

                return CategoryContainer(
                  category: category,
                );
              });
        }
        if (state is CategoriesFaliuer) {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: Text(
                "حدثت مشكلة أثناء جلب المجموعات",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.kGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return const CategoriesPlaceHolderHome();
      },
    );
  }
}
