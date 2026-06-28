import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/Login/cubit/student_login_cubit.dart';
import 'package:edulink_app/students/features/home/views/home_view_screen.dart';
import 'package:edulink_app/students/shared_widgets/custom_elevated_button.dart';
import 'package:edulink_app/students/shared_widgets/custom_textForm_field.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/student_auth_repo.dart';

class LoginViewscreen extends StatelessWidget {
  const LoginViewscreen({super.key});
/*

{
    "studentId": "87d20a8b-5972-418a-956e-e204757de25e",
    "username": "maram.basyouny.2026_3",
    "password": "z%LeAyx4",
    "fullName": "Maram Basyouny",
    "email": "maroma@gmail.com",
    "assignedTeacherNames": [
        "Mona Mohamad"
        
    ]
}
    
 */
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentLoginCubit(StudentAuthRepository()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePass   = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth  = MediaQuery.of(context).size.width;

    return BlocConsumer<StudentLoginCubit, StudentLoginState>(
      listener: (context, state) {
        if (state is StudentLoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Done Successfully Welcome ${state.student.fullName}'.tr()),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeViewScreen()));
          });
        }
        if (state is StudentLoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is StudentLoginLoading;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.08),
                Image.asset(
                  AppImages.loginCharacter,
                  width: screenWidth * 0.4,
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                   height: screenHeight -(screenHeight * 0.08) -(screenHeight * 0.02) - (screenWidth * 0.2), 
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightGray,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, -3),
                      ),
                    ],
                    color: AppColors.mediumBlueColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        Text('Log In'.tr(), style: AppStyles.whiteColor40),
                        SizedBox(height: screenHeight * 0.08),
                        CustomTextFormField(
                          hintText: 'Username'.tr(),
                          controller: _usernameCtrl,
                          prefix: Icon(Icons.person_outline, color: AppColors.charcoalGray),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomTextFormField(
                          hintText: 'Password'.tr(),
                          controller: _passwordCtrl,
                          obscureText: _obscurePass,
                          prefix: Icon(Icons.lock_outline, color: AppColors.charcoalGray),
                          suffix: GestureDetector(
                            onTap: () => setState(() => _obscurePass = !_obscurePass),
                            child: Icon(
                              _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Checkbox(
                        //           value: false,
                        //           onChanged: (value) {},
                        //           activeColor: AppColors.whiteColor,
                        //         ),
                        //         Text('Remember Me', style: AppStyles.whiteColor13),
                        //       ],
                        //     ),
                        //     Text('Forgot Password?', style: AppStyles.whiteColor13),
                        //   ],
                        // ),
                        SizedBox(height: screenHeight * 0.04),
                        CustomElevatedButton(
                          label: isLoading ? '' : 'Log In'.tr(),
                          bgColor: AppColors.primaryColor,
                          textColor: AppColors.whiteColor,
                          textStyle: AppStyles.whiteColor24,
                          buttonWidth: screenWidth * 0.9,
                          buttonHeight: screenHeight * 0.06,
                          onPressed: isLoading ? () {} : () {
                            context.read<StudentLoginCubit>().login(
                              _usernameCtrl.text.trim(),
                              _passwordCtrl.text,
                            );
                          },
                          child: isLoading
                              ? const SizedBox(
                                  height: 24, width: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : null,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        // Text('or sign in with', style: AppStyles.whiteColor16),
                        // SizedBox(height: screenHeight * 0.02),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [؟؟ظ
                        //     CustomIcon(iconName: AppImages.googleIcon),
                        //     SizedBox(width: screenWidth * 0.06),
                        //     CustomIcon(iconName: AppImages.facebookIcon),
                        //     SizedBox(width: screenWidth * 0.06),
                        //     CustomIcon(iconName: AppImages.appleIcon),
                        //   ],
                        // ),
                        // SizedBox(height: screenHeight * 0.02),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text("Don't have an account? ", style: AppStyles.whiteColor16),
                        //     Text('Sign Up', style: AppStyles.backgroundColor),
                        //   ],
                        // ),
                       // SizedBox(height: screenHeight * 0.09),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}