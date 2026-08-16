import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/maps/app_map.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class OrderLocationMap extends StatefulWidget {
  const OrderLocationMap({
    super.key,
  });

  @override
  State<OrderLocationMap> createState() => _OrderLocationMapState();
}

class _OrderLocationMapState extends State<OrderLocationMap> {
  @override
  void initState() {
    context.read<LocationCubit>().getCurrentLocation(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationSuccess) {
            final LatLng myLocation = LatLng(
              state.position.latitude,
              state.position.longitude,
            );
            return BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                return Column(
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
                          child: FlutterMap(
                            options: MapOptions(
                              onTap: (_, LatLng point) {
                                context.read<OrderCubit>().addMarker(point);
                              },
                              initialCenter: myLocation,

                              ///the google map clamped its zoom-18 camera to
                              ///the 14..17 range below, so 17 is the zoom this
                              ///screen has always actually opened at
                              initialZoom: 17,
                              minZoom: 14,
                              maxZoom: 17,
                              interactionOptions: kPickerInteractionOptions,
                            ),
                            children: [
                              const AppTileLayer(),
                              MarkerLayer(
                                markers: [
                                  MyLocationMarker(point: myLocation),
                                  if (OrderCubit.pickedPosition != null)
                                    AppMapMarker(
                                      point: OrderCubit.pickedPosition!,
                                    ),
                                ],
                              ),
                              const AppMapAttribution(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 10.w),
                      child: OrderCubit.pickedPosition == null
                          ? Text(
                              "أختر موقع التوصيل",
                              style: TextStyles.textStyle14,
                            )
                          : Wrap(
                              children: [
                                Text(
                                  OrderCubit.currentAddress,
                                  style: TextStyles.textStyle14
                                      .copyWith(overflow: TextOverflow.visible),
                                ),
                              ],
                            ),
                    ),
                    Center(
                      child: AppDefaultButton(
                        width: 100.w,
                        height: 40.w,
                        color: AppColors.primaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: 'تم',
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                );
              },
            );
          }
          return const SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("...جارى تحديد الموقع"),
              ],
            ),
          );
        },
      ),
    );
  }
}
