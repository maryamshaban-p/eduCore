import 'package:edulink_app/students/features/startScreens/onboarding/widgets/onbording_bottom.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox.expand(
          child: Stack(
            children: [
              ClipPath(
                clipper: Onboarding1Clipper(),
                child: Container(
                
                  color: const Color(0xFF79B7B2),
                ),
              ),
        
             
              Positioned(
                left: MediaQuery.of(context).size.width * 0.28,
                top: MediaQuery.of(context).size.height * 0.18,
                child: Image.asset(
                 AppImages.onBoarding1_1,
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
              ),
        
            Positioned(left: 16,top:MediaQuery.of(context).size.height * 0.62 ,child: Text('Welcome',style: AppStyles.black36,)),
            Positioned(left: 16,top:MediaQuery.of(context).size.height * 0.7 ,child: Text('''to our smart Learning App! 
        Learn in a new, interactive, and
        enjoyable way.''')),
         
         Positioned(
          right: 16,
          left: 16,
          top: MediaQuery.of(context).size.height * 0.9,
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
        OnbordinBotton(onbordingIcon: Icons.arrow_forward,iconColor:Color(0xFFCFE7E5) ,backgroundColor:const Color(0xFF79B7B2) ,),
        TextButton(onPressed: (){}, child: Text('Skip',style: AppStyles.black15,)),
             
            ],
          ),
        ),
        
            ],
          ),
          
        ),
      ),
      backgroundColor:  Color(0xFFCFE7E5),
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
      size.height *0.8,    
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
