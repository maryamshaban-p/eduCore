import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView(
      {super.key,
      required this.imageName,
     // required this.headline,
     // required this.body
      });
  final String imageName; //headline, body;

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.lightBlueColor, AppColors.whiteColor])),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            
            child: Image.asset(imageName),
          ),
    
        ],
      ),
    );
  }
}
