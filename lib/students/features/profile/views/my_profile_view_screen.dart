import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/core/theme/cubit/theme_cubit.dart';
import 'package:edulink_app/students/features/Login/views/login_viewScreen.dart';
import 'package:edulink_app/students/features/contact%20us/views/contact_us_viewscreen.dart';
import 'package:edulink_app/students/features/profile/cubit/profile_cubit.dart';
import 'package:edulink_app/students/features/profile/data/profile_repo.dart';

import 'package:edulink_app/students/features/profile/widgets/profile_header.dart';
import 'package:edulink_app/students/features/profile/widgets/profile_card.dart';
import 'package:edulink_app/students/features/profile/widgets/quick_info_card.dart';
import 'package:edulink_app/students/features/profile/widgets/profile_menu_tile.dart';
import 'package:edulink_app/students/features/profile/widgets/edit_profile_dialog.dart';
import 'package:edulink_app/students/features/profile/widgets/language_sheet.dart';

import 'package:edulink_app/students/shared_widgets/custom_bottom_navigationBar.dart';
import 'package:edulink_app/utils/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileViewScreen extends StatelessWidget {
  const MyProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepository())..loadProfile(),
      child: const _MyProfileView(),
    );
  }
}

class _MyProfileView extends StatelessWidget {
  const _MyProfileView();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Profile updated successfully'.tr()),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
builder: (context, state) {
  return Stack(
    children: [
      Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),
            child: _buildBody(context, state),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          selectedIndex: 3,
        ),
      ),

      if (state is ProfilePhotoUploading)
        Container(
          color: AppColors.blackColor.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ],
  );
}
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (state is ProfileLoading || state is ProfileInitial) {
      return SizedBox(
        height: screenWidth,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is ProfileError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04),
          ),
        ),
      );
    }

final profile = switch (state) {
  ProfileLoaded(profile: final p) => p,
  ProfileSaving(profile: final p) => p,
  ProfileSaved(profile: final p) => p,
  ProfilePhotoUploading(profile: final p) => p,
  _ => null,
};

    if (profile == null) return const SizedBox();

    final initials = _getInitials(profile.fullName);

    return Column(
      children: [
        SizedBox(height: screenWidth * 0.02),

       Row(
  children: [
    Expanded(child: ProfileHeader(onBack: () => Navigator.pop(context))),
    // Align(
    //   alignment: Alignment.centerRight,
    //   child: TextButton(
    //     onPressed: () => showEditProfileDialog(context, profile),
    //     child: Text(
    //       'Edit',
    //       style: TextStyle(
    //         color: const Color(0xFF3D8FEF),
    //         fontSize: screenWidth * 0.04,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //   ),
    // ),
  ],
),

        SizedBox(height: screenWidth * 0.04),

ProfileCard(
  initials: profile.avatarInitials.isNotEmpty
      ? profile.avatarInitials
      : initials,
  fullName: profile.fullName,
  email: profile.email,
  academicLevel: profile.academicLevel,
  classLevel: int.tryParse(profile.classLevel) ?? 0,
  imageUrl: profile.imageUrl,
  isUploadingPhoto: state is ProfilePhotoUploading,
),

        SizedBox(height: screenWidth * 0.04),

        Row(
          children: [
            Expanded(
              child: QuickInfoCard(
                icon: Icons.phone_outlined,
                label: "Phone".tr(),
                value: profile.phone,
                bg: const Color(0xFFE6F1FB),
                fg: const Color(0xFF0C447C),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: QuickInfoCard(
  icon: Icons.language_rounded,
  label: "Language".tr(),
  value: context.locale.languageCode == 'en' ? "English".tr() : "العربية".tr(),
  bg: const Color(0xFFFAECE7),
  fg: const Color(0xFF712B13),
),
            ),
          ],
        ),

        SizedBox(height: screenWidth * 0.04),

        ProfileMenuTile(
          icon: Icons.language_rounded,
          iconBg: const Color(0xFFEEEDFE),
          iconColor: const Color(0xFF534AB7),
          title: "Language".tr(),
          onTap: () => showLanguageSheet(context, profile),
        ),

        SizedBox(height: screenWidth * 0.025),

        ProfileMenuTile(
          icon: Icons.mail_outline_rounded,
          iconBg: const Color(0xFFE1F5EE),
          iconColor: const Color(0xFF0F6E56),
          title: "Contact Us".tr(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactUsScreen()),
            );
          },
        ),

        SizedBox(height: screenWidth * 0.025),

        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return ProfileMenuTile(
              icon: Icons.dark_mode_outlined,
              iconBg: const Color(0xFFFAEEDA),
              iconColor: const Color(0xFF854F0B),
              title: "Dark Mode".tr(),
              onTap: () => context.read<ThemeCubit>().toggleTheme(),
              trailing: Switch(
                value: themeState.isDark,
                activeColor: const Color(0xFF3D8FEF),
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            );
          },
        ),

        SizedBox(height: screenWidth * 0.025),

        ProfileMenuTile(
          icon: Icons.logout_rounded,
          iconBg: const Color(0xFFFCEBEB),
          iconColor: const Color(0xFFA32D2D),
          title: "Log Out".tr(),
          titleColor: const Color(0xFFA32D2D),
          onTap: () async {
            await context.read<ProfileCubit>().logout();

            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginViewscreen()),
                (route) => false,
              );
            }
          },
        ),

        SizedBox(height: screenWidth * 0.04),
      ],
    );
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return "?";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}