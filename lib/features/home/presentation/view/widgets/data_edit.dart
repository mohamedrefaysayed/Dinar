// ignore_for_file: use_build_context_synchronously

import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/widgets/text_field_data_builder.dart';
import 'package:dinar_store/features/auth/presentation/view_model/store_data_cubit/store_data_cubit.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/data_edit_location.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataEdit extends StatelessWidget {
  const DataEdit({super.key, required this.profile, required this.position});

  final ProfileModel profile;
  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        StoreDataCubit.nameController.clear();
        StoreDataCubit.marketNameController.clear();
        StoreDataCubit.govController.clear();
        StoreDataCubit.addressController.clear();
        StoreDataCubit.marketPhoneController.clear();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 40.h,
          ),
          children: [
            Center(
              child: Text(
                "تعديل البيــــانات",
                style: TextStyles.textStyle16.copyWith(
                  fontSize: 20.w,
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            TextFieldDataBulder(
              title: 'اسم صاحب المتجر',
              hint: profile.user!.first.store!.ownerName ?? "",
              onChanged: (value) {},
              controller: StoreDataCubit.nameController,
            ),
            TextFieldDataBulder(
              title: 'اسم المتجر',
              hint: profile.user!.first.store!.storeName ?? "",
              onChanged: (value) {},
              controller: StoreDataCubit.marketNameController,
            ),
            TextFieldDataBulder(
              title: 'المحافظة',
              hint: profile.user!.first.store!.district ?? "",
              onChanged: (value) {},
              controller: StoreDataCubit.govController,
            ),
            TextFieldDataBulder(
              title: 'العنوان',
              hint: profile.user!.first.store!.address ?? "",
              onChanged: (value) {},
              controller: StoreDataCubit.addressController,
            ),
            TextFieldDataBulder(
              title: 'رقم المتجر',
              hint: profile.user!.first.store!.phone ?? "",
              onChanged: (value) {},
              controller: StoreDataCubit.marketPhoneController,
              keyType: TextInputType.number,
            ),
            SizedBox(
              height: 30.h,
            ),
            AppDefaultButton(
              color: AppColors.kASDCPrimaryColor,
              onPressed: () {
                double latitude = double.parse(
                    ProfileCubit.profileModel!.user!.first.store!.lat!);
                double longitude = double.parse(
                    ProfileCubit.profileModel!.user!.first.store!.lng!);

                Navigator.push(
                  context,
                  RightSlideTransition(
                    page: DataEditLocation(
                      position: LatLng(
                        latitude,
                        longitude,
                      ),
                    ),
                  ),
                );
              },
              title: 'تعديل الموقع',
              icon: Icon(
                Icons.location_on_rounded,
                color: AppColors.kWhite,
                size: 20.w,
              ),
              textStyle: TextStyles.textStyle16.copyWith(
                fontSize: 16.w,
                color: AppColors.kWhite,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            BlocConsumer<StoreDataCubit, StoreDataState>(
              listener: (context, state) async {
                if (state is UpdateDataFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    messageSnackBar(
                      message: " خطأ أثناء تعديل البيانات ${state.errMessage}",
                    ),
                  );
                }
                if (state is UpdateDataSuccess) {
                  await context
                      .read<ProfileCubit>()
                      .getProfile(context: context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    messageSnackBar(
                      message: "تم تعديل البيانات بنجاح",
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is UpdateDataLoading) {
                  return const AppLoadingButton();
                }
                return AppDefaultButton(
                  color: AppColors.kASDCPrimaryColor,
                  onPressed: () {
                    if (StoreDataCubit.nameController.text != "" ||
                        StoreDataCubit.marketNameController.text != "" ||
                        StoreDataCubit.govController.text != "" ||
                        StoreDataCubit.addressController.text != "" ||
                        StoreDataCubit.marketPhoneController.text != "") {
                      context.read<StoreDataCubit>().updateData(
                            profileModel: ProfileCubit.profileModel!,
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        messageSnackBar(
                          message: "لم يتم تعديل اى بيانات",
                        ),
                      );
                    }
                  },
                  title: 'حفظ',
                  textStyle: TextStyles.textStyle16.copyWith(
                    fontSize: 16.w,
                    color: AppColors.kWhite,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
