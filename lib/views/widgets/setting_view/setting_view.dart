import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/generated/l10n.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_appbar_editing_view.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/views/widgets/menu_view/manager/user_data_cubit.dart';
import '../../../utils/show_logout_alert_dialog.dart';
import '../profile_view/edit_user_profile_view.dart';
import '../splash_view/splash_view.dart';
import 'animated_switcher.dart';
import 'animated_tile.dart';
import 'manager/setting_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return BlocProvider(
      create: (_) => SettingsCubit()..loadSettings(),
      child: BlocConsumer<UserDataCubit, UserDataState>(
        listener: (context, state) {
          if (state is UserDataLogoutFailure) {
            showSnackBar(
              context: context,
              message: state.failure,
              backgroundColor: Colors.redAccent,
            );
          } else if (state is NoInternetConnectionState) {
            showSnackBar(
              context: context,
              message: state.message,
              backgroundColor: Colors.yellow[800],
            );
          } else if (state is UserDataLogoutSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SplashView()),
              (route) => false,
            );
          }
        },
        builder: (context, userState) {
          final userDataCubit = context.read<UserDataCubit>();
          final settingsCubit = context.read<SettingsCubit>();

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: CustomAppBarEditingView(
                onPressed: () => Navigator.pop(context),
                title: loc.Settings,
              ),
            ),
            body: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF5F5F5), Color(0xFFECE0DC)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: ListView(
                      children: [
                        // edit user profile
                        animatedTile(
                          index: 0,
                          icon: Icons.person_outline,
                          title: loc.EditProfile,
                          subtitle: loc.TapToEditProfileInline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: userDataCubit,
                                      child: const EditProfileScreen(),
                                    ),
                              ),
                            );
                          },
                        ),
                        //edit language
                        animatedTile(
                          index: 1,
                          icon: Icons.language_outlined,
                          title: loc.Language,
                          subtitle:
                              settingsCubit.selectedLanguage == 'ar'
                                  ? 'العربية'
                                  : 'English',
                          onTap:
                              () => _showLanguageSheet(context, settingsCubit),
                        ),
                        //edit notifications
                        animatedSwitchTile(
                          index: 2,
                          icon: Icons.notifications_none_outlined,
                          title: loc.Notifications,
                          value: settingsCubit.notificationsEnabled,
                          onChanged: (v) {
                            settingsCubit.toggleNotifications();
                          },
                        ),
                        //edit mode dark or light
                        animatedSwitchTile(
                          index: 3,
                          icon: Icons.dark_mode_outlined,
                          title: loc.DarkMode,
                          value: settingsCubit.darkMode,
                          onChanged: (v) {
                            settingsCubit.toggleDarkMode();
                          },
                        ),
                        //info about app
                        animatedTile(
                          index: 4,
                          icon: Icons.info_outline,
                          title: loc.AboutApp,
                          onTap: () {
                            _showAboutDialog(context);
                          },
                        ),
                        userState is UserDataLogoutLoading
                            ? const AppLoader()
                            : animatedTile(
                              index: 5,
                              icon: Icons.logout,
                              title: loc.LogOut,
                              color: Colors.redAccent,
                              onTap:
                                  () => showLogoutDialog(
                                    context: context,
                                    onLogoutPressed: () async {
                                      if (await userDataCubit
                                          .hasInternetConnection()) {
                                        await userDataCubit.logout();
                                      }
                                    },
                                  ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // 🌐 Language Selector (shows alert before applying)
  void _showLanguageSheet(BuildContext context, SettingsCubit cubit) {
    final loc = S.of(context);
    final languages = {'en': 'English', 'ar': 'العربية'};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.ChooseLanguage,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 🌍 Language list
              ...languages.entries.map((entry) {
                final code = entry.key;
                final name = entry.value;
                final isSelected = cubit.selectedLanguage == code;

                return ListTile(
                  title: Text(name, style: TextStyle(fontSize: 14.sp)),
                  trailing:
                      isSelected
                          ? const Icon(Icons.check, color: Colors.brown)
                          : null,
                  onTap: () async {
                    Navigator.pop(sheetContext); // close bottom sheet first
                    if (isSelected) return;
                    await showDialog(
                      context: sheetContext,
                      builder:
                          (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Text(
                              loc.RestartRequiredTitle,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              loc.RestartRequiredMessage,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (Navigator.canPop(dialogContext)) {
                                    Navigator.pop(dialogContext);
                                  }
                                },
                                child: Text(
                                  loc.Cancel,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (Navigator.canPop(dialogContext)) {
                                    Navigator.pop(dialogContext);
                                  }
                                  await cubit.changeLanguage(
                                    code: code,
                                    context: dialogContext,
                                  );
                                  // ✅ Use the ROOT context from the SettingsView
                                  if (!context.mounted) return;

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SplashView(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  loc.Restart,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                );
              }),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  // 🧾 About App Dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "About This App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            content: Text(
              "Infantry House App v1.0.0\n\nDeveloped with ❤️ using Flutter.\n© 2025 Infantry House.",
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: Colors.brown[700])),
              ),
            ],
          ),
    );
  }
}
