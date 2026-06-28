
import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AchievmentCard extends StatelessWidget {
  const AchievmentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon, required this.textColor,
  });

  final String title;
  final String subtitle;
  final Color color,textColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:185 ,width: 182,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
       color:  color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.whiteColor,
            child: Icon(icon, color: textColor,size: 30,),
          ),
          Spacer(),
          Align(alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize:18 ,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 6,),
         Align(alignment: Alignment.center,
            child: Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12,)
        ],
      ),
    );
  }
}

