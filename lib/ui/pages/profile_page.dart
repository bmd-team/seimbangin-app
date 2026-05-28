import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seimbangin_app/routes/routes.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';
import 'package:seimbangin_app/blocs/theme/theme_cubit.dart';
import 'package:seimbangin_app/ui/sections/profile/profile_menu_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.color.secondaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: context.color.backgroundWhiteColor,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 32.h,
                  left: 24.w,
                  right: 24.w,
                  bottom: 8.h,
                ),
                child: Text(
                  'Setting',
                  style: context.text.blackTextStyle.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 30.r),
                child: Column(
                  children: [
                    ProfileMenuSection(
                      title: 'Kategori Transaksi',
                      icon: Icons.category_rounded,
                      onTap: () {
                        routes.pushNamed(RouteNames.categoryManagement);
                      },
                    ),
                    ProfileMenuSection(
                      title: 'Mata Uang Default',
                      icon: Icons.attach_money_rounded,
                      onTap: () {
                        // TODO: implement edit default currency
                      },
                    ),
                    ProfileMenuSection(
                      title: 'Bahasa',
                      icon: Icons.language_rounded,
                      onTap: () {
                        // TODO: implement language selection
                      },
                    ),
                    SizedBox(height: 16.r),
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, mode) {
                        final isDark = mode == ThemeMode.dark;
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.r, vertical: 8.r),
                          decoration: BoxDecoration(
                            color: context.color.backgroundWhiteColor,
                            borderRadius: BorderRadius.circular(16).r,
                            border: Border.all(
                                color: context.color.backgroundGreyColor),
                          ),
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            value: isDark,
                            onChanged: (value) {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                            title: Text(
                              'Mode Gelap',
                              style: context.text.blackTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            secondary: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: context.color.backgroundGreyColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isDark
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                                color: context.color.textPrimaryColor,
                                size: 24.r,
                              ),
                            ),
                            activeThumbColor: context.color.primaryColor,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40.r),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
