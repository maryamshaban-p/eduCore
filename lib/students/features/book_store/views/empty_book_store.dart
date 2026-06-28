import 'package:flutter/material.dart';

class EmptyBookStore extends StatelessWidget {
  const EmptyBookStore({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Book Store',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF022544),
                      fontSize: 22),
                ),
                const Spacer(),
               /* IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF012D54),
                  ),
                ),*/
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Color(0xFF012D54),
                  ),
                ),
              ],
            ),SizedBox(height: 80,),
            Image.asset('assets/images/empty_image.png',scale: 2.5,),
            SizedBox(height: 30,),
            Text("Empty",style: TextStyle(color: Color(0xFF616161),fontSize: 30),)
          ],
        ),
      ),
    );
  }
}
