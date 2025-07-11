import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/app_config.dart';
import 'core/cubit/localization_cubit.dart';
import 'core/injection/injection.dart';
import 'core/navigation/app_router.dart';
import 'core/services/localization_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/dashboard_layout.dart';

class CreteApp extends StatelessWidget {
  const CreteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return ScreenUtilInit(
      designSize: const Size(393, 852), // Design dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider(
        create: (context) => getIt<LocalizationCubit>()..initialize(),
        child: BlocBuilder<LocalizationCubit, LocalizationState>(
          builder: (context, localizationState) => MaterialApp.router(
            title: AppConfig.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: AppConfig.isDevelopment,
            routerConfig: appRouter.router,

            // Localization configuration
            locale: localizationState.locale,
            localizationsDelegates: LocalizationService.delegates,
            supportedLocales: context
                .read<LocalizationCubit>()
                .supportedLocales,

            // Builder to provide localization context
            builder: (context, widget) => DashboardLayout()
          ),
        ),
      ),
    );
  }
}

/*

Directionality(
              textDirection: context.read<LocalizationCubit>().textDirection,
              child: widget ?? const SizedBox.shrink(),
            ),

*/