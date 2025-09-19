import "package:flutter/material.dart";

Text text16Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      color: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: color ?? Colors.black,
      height: 1.1,
      fontSize: 16,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w600,
      // height: 0.07,
    ),
  );
}

Text textPx(String text, double fontSize, {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w600,
      // height: 0.07,
    ),
  );
}

Row textPxRequired(String text, double fontSize, {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Row(
    children: [
      Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize,
          decorationColor: color ?? Colors.black,
          decoration: decoration ?? TextDecoration.none,
          height: 1.1,
          fontFamily: 'Inter',
          fontWeight: fontWeight ?? FontWeight.w600,
          // height: 0.07,
        ),
      ),
      textPx("*", fontSize, color: Colors.red),
    ],
  );
}

Text text18Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      color: color ?? Colors.black,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontSize: 18,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w600,
      // height: 0.07,
    ),
  );
}

Text text22Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    textAlign: textAlign ?? TextAlign.start,
    maxLines: maxLines,
    overflow: overflow,
    // textAlign: TextAlign.start,
    style: TextStyle(
      color: color ?? Colors.black,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontSize: 22,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w600,
    ),
  );
}

Text text20Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign ?? TextAlign.start,
    style: TextStyle(
      color: color ?? Colors.black,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontSize: 20,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w600,
    ),
  );
}

Text text14Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      color: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: color ?? Colors.black,
      height: 1.1,
      fontSize: 14,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w500,
      // height: 0.07,
    ),
  );
}

// Text text14Px(String text, {Color? color, Key? key, int? maxLines, TextOverflow? overflow, TextAlign? textAlign, FontWeight? fontWeight, TextDecoration? decoration}) {
//   return Text(
//     text,
//     maxLines: maxLines,
//     overflow: overflow,
//     key: key,
//     textAlign: textAlign,
//     style: TextStyle(
//       overflow: TextOverflow.ellipsis,
//       color: color ?? Colors.black,
//       decorationColor: color ?? Colors.black,
//       decoration: decoration ?? TextDecoration.none,
//       height: 1.1,
//       fontSize: 14,
//       fontFamily: 'Inter',
//       fontWeight: fontWeight ?? FontWeight.w400,
//     ),
//   );
// }

Text text15Px(String text, {Color? color, int? maxLines, TextOverflow? overflow = TextOverflow.ellipsis, TextAlign? textAlign, FontWeight? fontWeight, Key? key, TextDecoration? decoration}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
    key: key,
    style: TextStyle(
      overflow: TextOverflow.ellipsis,
      color: color ?? Colors.black,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontSize: 15,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w500,
    ),
  );
}

Text text12Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, FontWeight? fontWeight, TextAlign? textAlign, TextDecoration? decoration}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
    style: TextStyle(
      overflow: TextOverflow.ellipsis,
      color: color ?? Colors.black,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontSize: 12,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w400,
    ),
  );
}

Text text11Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      overflow: TextOverflow.ellipsis,
      color: color ?? Colors.black,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontSize: 11,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w400,
    ),
  );
}

Text text10Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      overflow: TextOverflow.ellipsis,
      color: color ?? Colors.black,
      decorationColor: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      height: 1.1,
      fontSize: 10,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w400,
    ),
  );
}

Text text13Px(String text, {Color? color, int? maxLines, TextOverflow? overflow, FontWeight? fontWeight, TextDecoration? decoration}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      overflow: TextOverflow.ellipsis,
      color: color ?? Colors.black,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: color ?? Colors.black,
      height: 1.1,
      fontSize: 13,
      fontFamily: 'Inter',
      fontWeight: fontWeight ?? FontWeight.w400,
    ),
  );
}
