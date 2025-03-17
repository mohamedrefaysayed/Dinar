import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.canGoBack,
    this.whenBack,
    required this.haveFilter,
    this.onFilter,
    required this.onChanged,
    this.autofocus,
    this.onDismiss,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final bool canGoBack;
  final void Function()? whenBack;
  final bool haveFilter;
  final void Function()? onFilter;
  final void Function(String) onChanged;
  final bool? autofocus;
  final Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (haveFilter)
          IconButton(
            onPressed: onFilter,
            icon: Icon(
              Icons.filter_list_rounded,
              color: AppColors.primaryColor,
              size: 30.w,
            ),
          ),
        SizedBox(
          width: 5.w,
        ),
        Expanded(
          child: SizedBox(
            child: TextField(
              onTapOutside: (_) {
                if (onDismiss != null) {
                  onDismiss!();
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              autofocus: autofocus ?? false,
              controller: textEditingController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                hintText: hintText,
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyles.textStyle10,
                filled: true,
                fillColor: AppColors.primaryColor.withOpacity(0.09),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.w),
                  borderSide: BorderSide.none,
                ),
                // suffixIcon: Padding(
                //   padding: EdgeInsets.all(5.w),
                //   child: Icon(
                //     Icons.manage_search_rounded,
                //     color: AppColors.primaryColor,
                //     size: 30.w,
                //   ),
                // ),
              ),
              onChanged: onChanged,
            ),
          ),
        ),
        if (canGoBack)
          IconButton(
            onPressed: whenBack,
            icon: Transform.flip(
              flipX: true,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 30.w,
                color: AppColors.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
