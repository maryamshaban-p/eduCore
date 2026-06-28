import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: w * .05,
        vertical: h * .025,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
    ? Theme.of(context).cardColor
    : const Color(0xff204593),
        borderRadius: BorderRadius.circular(w * .06),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [            
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: w * .055,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Contact Us".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * .05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: h * .01),

          Container(
            padding: EdgeInsets.all(w * .04),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent,
              color: Colors.white,
              size: w * .12,
            ),
          ),

          SizedBox(height: h * .02),

          Text(
            "We're Here To Help".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: w * .075,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: h * .012),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * .04,
            ),
            child: Text(
              "Reach out to our education support team anytime. We respond within 24 hours.".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                height: 1.5,
                fontSize: w * .038,
              ),
            ),
          ),
        ],
      ),
    );
  }
}