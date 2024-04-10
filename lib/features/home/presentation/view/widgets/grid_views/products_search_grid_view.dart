import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/search_model.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/product_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/search_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsSearchGridView extends StatelessWidget {
  const ProductsSearchGridView({super.key, required this.products});

  final List<SearchProduct> products;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GeneralDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "المنتجــــــات",
              style: TextStyles.textStyle16.copyWith(
                fontSize: 16.w,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const GeneralDivider(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) => SearchItem(
            imag: products[index].image!,
            name: products[index].productName!,
            onTap: () {
              Map<String, dynamic> data = products[index].toJson();
              Navigator.push(
                  context,
                  RightSlideTransition(
                      page: ProductView(product: Products.fromJson(data))));
            },
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            childAspectRatio: 115.h / 135.w,
          ),
        ),
      ],
    );
  }
}
