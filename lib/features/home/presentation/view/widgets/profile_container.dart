import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/columns/current_location_column.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/map_place_holder.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/profile_place_holder.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({super.key});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  @override
  void initState() {
    context.read<ProfileCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 30.w, right: 10.w, left: 10.w, bottom: 20.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(15.w),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.w,
            spreadRadius: 5.w,
            color: AppColors.kLightGrey,
          ),
        ],
      ),
      child: Column(
        children: [
          BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccess) {
                context.read<LocationCubit>().getAddress(
                    double.parse(state.profileModel.user!.first.store!.lat!),
                    double.parse(state.profileModel.user!.first.store!.lng!));
              }
            },
            builder: (context, state) {
              if (state is ProfileSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          state.profileModel.user!.first.countryCode! +
                              state.profileModel.user!.first.phone!,
                          style: TextStyles.textStyle18,
                        ),
                        Text(
                          "رقم الهاتف : ",
                          style: TextStyles.textStyle18,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const GeneralDivider(),
                    Text(
                      "بيانات المتجر",
                      style: TextStyles.textStyle18.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "اسم صاحب المتجر : ${state.profileModel.user!.first.store!.ownerName!}",
                      style: TextStyles.textStyle16.copyWith(
                        fontSize: 16.w,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "اسم المتجر : ${state.profileModel.user!.first.store!.storeName!}",
                      style: TextStyles.textStyle16.copyWith(
                        fontSize: 16.w,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "المحافظة : ${state.profileModel.user!.first.store!.district!}",
                      style: TextStyles.textStyle16.copyWith(
                        fontSize: 16.w,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "العنوان : ${state.profileModel.user!.first.store!.address!}",
                      style: TextStyles.textStyle16.copyWith(
                        fontSize: 16.w,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "رقم المتجر : ${state.profileModel.user!.first.store!.phone!}",
                      style: TextStyles.textStyle16.copyWith(
                        fontSize: 16.w,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                );
              }
              return const ProfilePLaceHolder();
            },
          ),
          BlocBuilder<LocationCubit, LocationState>(
            builder: (context, state) {
              if (state is AddressSuccess) {
                return CurrentLocationColumn(
                    currentLocationData: state.locationData);
              }
              return const MapPlaceHolder();
            },
          ),
        ],
      ),
    );
  }
}
