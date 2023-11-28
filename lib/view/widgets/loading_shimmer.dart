import 'package:flutter/material.dart';
import 'package:todo_app/view/widgets/custum_shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ShimmerWidget.rectangular(
              height: 150,
              width: width * 0.4,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                ShimmerWidget.rectangular(
                  height: 30,
                  width: width * 0.5,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                ShimmerWidget.rectangular(
                  height: 30,
                  width: width * 0.5,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                ShimmerWidget.rectangular(
                  height: 30,
                  width: width * 0.5,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
