import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/about_app.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/delete_account_container.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/log_out_container.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/profile_settings_row.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
            ),
            ProfileSettingsRow(
              title: 'البيانات الشخصية',
              onTap: () {
                Navigator.push(
                  context,
                  RightSlideTransition(
                    page: const SettingView(),
                  ),
                );
              },
              icon: Icons.person_2_outlined,
              wDevider: true,
            ),
            ProfileSettingsRow(
              title: 'معلومات عن التطبيق',
              onTap: () {
                Navigator.push(
                  context,
                  RightSlideTransition(
                    page: const AboutApp(),
                  ),
                );
              },
              icon: Icons.data_object_outlined,
              wDevider: true,
            ),
            // ProfileSettingsRow(
            //   title: 'معلومات عن المطوريين',
            //   onTap: () {
            //     Navigator.push(
            //         context, RightSlideTransition(page: const DevoloperData()));
            //   },
            //   icon: Icons.developer_mode_outlined,
            //   wDevider: true,
            // ),
            ProfileSettingsRow(
              title: 'الدعم',
              onTap: () async {
                await launchUrlString(
                  "sms:+9607869636020",
                  mode: LaunchMode.externalApplication,
                );
              },
              icon: Icons.support_agent_outlined,
              wDevider: true,
            ),
            const LogOutContainer(),
            const GeneralDivider(),
            const DeleteAccountContainer(),
            // const Spacer(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SvgPicture.asset(
            //       "assets/icons/facebook.svg",
            //       height: 20.w,
            //       width: 20.w,
            //       colorFilter: ColorFilter.mode(
            //           Colors.black.withOpacity(0.6), BlendMode.srcATop),
            //     ),
            //     SizedBox(
            //       width: 20.w,
            //     ),
            //     SvgPicture.asset(
            //       "assets/icons/instagram.svg",
            //       height: 20.w,
            //       width: 20.w,
            //       colorFilter: ColorFilter.mode(
            //           Colors.black.withOpacity(0.6), BlendMode.srcATop),
            //     ),
            //     SizedBox(
            //       width: 20.w,
            //     ),
            //     SvgPicture.asset(
            //       "assets/icons/globe.svg",
            //       height: 20.w,
            //       width: 20.w,
            //       colorFilter: ColorFilter.mode(
            //           Colors.black.withOpacity(0.6), BlendMode.srcATop),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
