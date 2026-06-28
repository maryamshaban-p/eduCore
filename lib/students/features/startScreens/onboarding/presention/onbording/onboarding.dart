
import 'package:edulink_app/students/features/startScreens/onboarding/widgets/custom_pageview.dart';
import 'package:edulink_app/students/shared_widgets/custom_auth_row.dart';
import 'package:edulink_app/students/shared_widgets/custom_elev_button.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController OnboardingController = PageController();
@override
  void dispose(){
   OnboardingController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: PageView(
                  controller: OnboardingController,
                  children: [
                    CustomPageView(
                      imageName: AppImages.onBoarding1,
                      ),
                    CustomPageView(
                      imageName: AppImages.onBoarding2,
                   ),
                    CustomPageView(
                      imageName: AppImages.onBoarding3,
                     ),
                  ],
                ),
              ),
              Center(
                child: SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primaryColor,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                    controller: OnboardingController,
                    count: 3),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: CoustomElevatedButton2(
                  onPressed: (){},
                  label: 'Login',
                  bgColor: AppColors.primaryColor,
                
                buttonTextStyle: AppStyles.whiteColor16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CoustomElevatedButton2(onPressed: (){},
                  label: 'Sign Up',
                  bgColor: AppColors.whiteColor,
                
                buttonTextStyle: AppStyles.primary16,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: Text(
                'or continue with',
                style: TextStyle(color: AppColors.greyColor, fontSize: 12),
              )),
              SizedBox(
                height: 15,
              ),
              CustomAuthRow()
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
    );
  }
}

