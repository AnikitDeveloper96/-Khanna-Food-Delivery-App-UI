import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/constants/color.dart';
import 'package:fooddeliveryapp/constants/dimensions.dart';

class FoodDeliveryAppWidgets {
  customButton(
    BuildContext context,
    Color buttonColor,
    String buttonText,
    Color textColor,
    double textSize,
    FontWeight fontweight,

    VoidCallback? onPressed, 
  ) {
    return GestureDetector
    (
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 36,
          left: AppDimensions.marginLarge,
      
          right: AppDimensions.marginLarge,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            buttonText,
            style: TextStyle(color: textColor,
            fontSize: textSize,fontWeight: fontweight),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
