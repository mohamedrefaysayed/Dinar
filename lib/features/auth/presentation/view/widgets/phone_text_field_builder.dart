import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneTextFieldBuilder extends StatelessWidget {
  const PhoneTextFieldBuilder({super.key, required this.onChanged});

  final void Function(PhoneNumber? newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'رقم الهاتف',
          style: TextStyles.textStyle14.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        IntlPhoneField(
          onChanged: onChanged,
          initialCountryCode: 'IQ',
          style: TextStyles.textStyle16.copyWith(
            fontSize: 16.w,
          ),
          autovalidateMode: AutovalidateMode.disabled,
          dropdownTextStyle: TextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.w,
          ),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kIsTablet ? 10.w : 15.w),
          ),
          pickerDialogStyle: PickerDialogStyle(
            countryCodeStyle: TextStyles.textStyle12.copyWith(
              fontWeight: FontWeight.w700,
            ),
            countryNameStyle: TextStyles.textStyle12,
          ),
          decoration: InputDecoration(
            prefixIconColor: AppColors.primaryColor,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kIsTablet ? 10.w : 15.w),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                )),
            counterText: '',
            errorStyle: TextStyles.textStyle10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kIsTablet ? 10.w : 15.w),
            ),
          ),
        ),
      ],
    );
  }
}
