import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:seimbangin_app/blocs/homepage/homepage_bloc.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';
import 'package:seimbangin_app/ui/pages/analytics_page.dart';
import 'package:seimbangin_app/ui/pages/home_page.dart';
import 'package:seimbangin_app/ui/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  List<PersistentTabConfig> _tabs(BuildContext context) => [
        PersistentTabConfig(
          screen: const HomePage(),
          item: ItemConfig(
            icon: Icon(Icons.home_rounded, size: 24.r),
            title: "Home",
            textStyle: context.text.blackTextStyle
                .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
            activeForegroundColor: context.color.primaryColor,
            inactiveForegroundColor:
                context.color.textSecondaryColor.withValues(alpha: 0.5),
          ),
        ),
        PersistentTabConfig(
          screen: const AnalyticsPage(),
          item: ItemConfig(
            icon: Icon(Icons.bar_chart_rounded, size: 24.r),
            title: "Insight",
            textStyle: context.text.blackTextStyle
                .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
            activeForegroundColor: context.color.primaryColor,
            inactiveForegroundColor:
                context.color.textSecondaryColor.withValues(alpha: 0.5),
          ),
        ),
        PersistentTabConfig(
          screen: BlocProvider.value(
            value: BlocProvider.of<HomepageBloc>(context),
            child: const ProfilePage(),
          ),
          item: ItemConfig(
            icon: Icon(Icons.settings_rounded, size: 24.r),
            title: "Setting",
            textStyle: context.text.blackTextStyle
                .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
            activeForegroundColor: context.color.primaryColor,
            inactiveForegroundColor:
                context.color.textSecondaryColor.withValues(alpha: 0.5),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      navBarOverlap: const NavBarOverlap.full(),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      backgroundColor: Colors.transparent,
      tabs: _tabs(context),
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: context.color.backgroundWhiteColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            )
          ],
        ),
      ),
    );
  }
}
