import 'package:edulink_app/students/features/startScreens/onboarding/widgets/onbording_bottom.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox.expand(
          child: Stack(
            children: [
            Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 300,
            ),
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.7,
            decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFC4B098),
            ),
          ),
        ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.28,
                top: MediaQuery.of(context).size.height * 0.16,
                child: Image.asset(
                  AppImages.onBoarding1_3,
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
              ),
              Positioned(
                  left: 16,
                  top: MediaQuery.of(context).size.height * 0.62,
                  child: Text(
                    'Get Ready ',
                    style: AppStyles.black36,
                  )),
              Positioned(
                  left: 16,
                  top: MediaQuery.of(context).size.height * 0.7,
                  child: Text('''to Learn Smarter!
        Start your personalized learning 
        journey... AI powered, interactive, 
        and designed just for you. ''')),
              Positioned(
                right: 16,
                left: 16,
                top: MediaQuery.of(context).size.height * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnbordinBotton(
                      onbordingIcon: Icons.arrow_back,
                      iconColor: Color(0xFFF5E6D3),
                      backgroundColor: const Color(0xFFC4B098),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Start',
                          style: AppStyles.black15,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5E6D3),
    );
  }
}

class Onboarding1Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.32);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.8,
      size.width,
      size.height * 0.32,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
