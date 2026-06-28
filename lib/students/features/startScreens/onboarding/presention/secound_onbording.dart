import 'package:edulink_app/students/features/startScreens/onboarding/widgets/onbording_bottom.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class onBoarding2 extends StatelessWidget {
  const onBoarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox.expand(
          child: Stack(
            children: [
              Container(
                width:MediaQuery.of(context).size.width*0.7,height: MediaQuery.of(context).size.height*0.5 ,
              decoration: BoxDecoration( color: const Color(0xFFCF8D50),borderRadius: BorderRadius.only(bottomRight:Radius.circular(50))),
               
              ),
        
             
              Positioned(
                left: MediaQuery.of(context).size.width * 0.24,
                top: MediaQuery.of(context).size.height * 0.16,
                child: Image.asset(
                 AppImages.onBoarding1_2,
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
              ),
        
            Positioned(left: 16,top:MediaQuery.of(context).size.height * 0.62 ,child: Text('Learn Smarter With AI',style: AppStyles.black36,)),
            Positioned(left: 16,top:MediaQuery.of(context).size.height * 0.7 ,child: Text(''' Powered by Artificial Intelligence, 
         our app personalizes every learning
         journey for you.''')),
         
         Positioned(
          right: 16,
          left: 16,
          top: MediaQuery.of(context).size.height * 0.9,
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
        Row(children: [OnbordinBotton(onbordingIcon: Icons.arrow_back,iconColor:Color(0xFFFFF3E0) ,backgroundColor:const Color(0xFFAE4C03) ,),
             SizedBox(width: 16,),
        OnbordinBotton(onbordingIcon: Icons.arrow_forward,iconColor:Color(0xFFFFF3E0) ,backgroundColor:const Color(0xFFAE4C03) ,),
        ],),
        TextButton(onPressed: (){}, child: Text('Skip',style: AppStyles.black15,)),
             
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




class Onboarding2Clipper extends CustomClipper<Path> {
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
