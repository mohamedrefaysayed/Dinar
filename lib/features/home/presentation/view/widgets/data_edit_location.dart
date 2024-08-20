// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/defult_scaffold.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view_model/store_data_cubit/store_data_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataEditLocation extends StatelessWidget {
  const DataEditLocation({super.key, required this.position});

  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        ProfileCubit.markerPosition = null;
      },
      child: DefultScaffold(
        canPop: true,
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    blurRadius: 10.w,
                    spreadRadius: 15.w,
                    color: AppColors.kGrey,
                  )
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.w),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return GoogleMap(
                        onTap: (position) {
                          context.read<ProfileCubit>().addMarker(position);
                        },
                        mapToolbarEnabled: false,
                        minMaxZoomPreference:
                            const MinMaxZoomPreference(14, 17),
                        markers: {
                          if (ProfileCubit.marker != null) ProfileCubit.marker!,
                        },
                        compassEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          zoom: 18,
                          target: position,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          context.read<ProfileCubit>().addMarker(position);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            BlocConsumer<StoreDataCubit, StoreDataState>(
              listener: (context, state) async {
                if (state is UpdateLocationFailure) {
                  context.showMessageSnackBar(
                    message: " خطأ أثناء تعديل الموقع ${state.errMessage}",
                  );
                }
                if (state is UpdateLocationSuccess) {
                  await context
                      .read<ProfileCubit>()
                      .getProfile(context: context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  context.showMessageSnackBar(
                    message: "تم تعديل الموقع بنجاح",
                  );
                }
              },
              builder: (context, state) {
                if (state is UpdateLocationLoading) {
                  return const AppLoadingButton();
                }
                return AppDefaultButton(
                  color: AppColors.primaryColor,
                  onPressed: () {
                    if (ProfileCubit.markerPosition != null) {
                      context.read<StoreDataCubit>().updateLocation(
                            position: ProfileCubit.markerPosition!,
                            profileModel: ProfileCubit.profileModel!,
                          );
                    }
                  },
                  title: 'حفظ الموقع',
                  textStyle: TextStyles.textStyle16.copyWith(
                    fontSize: 16.w,
                    color: AppColors.kWhite,
                  ),
                );
              },
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
