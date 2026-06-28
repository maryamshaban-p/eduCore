import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: h * .018),
      padding: EdgeInsets.symmetric(
        horizontal: w * .04,
        vertical: h * .02,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(w * .045),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(w * .03),
            decoration: BoxDecoration(
              color: const Color(0xffEEF4FF),
              borderRadius: BorderRadius.circular(w * .03),
            ),
            child: Icon(
              icon,
              color: const Color(0xff204593),
              size: w * .06,
            ),
          ),

          SizedBox(width: w * .04),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: w * .042,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: h * .005),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: w * .033,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: w * .045,
            color: const Color(0xff204593),
          ),
        ],
      ),
    );
  }
}