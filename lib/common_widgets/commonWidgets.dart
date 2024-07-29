import 'package:flutter/material.dart';

class CommonDivider extends StatelessWidget {
  const CommonDivider({Key? key, this.direction}) : super(key: key);
  final String? direction;

  @override
  Widget build(Object context) {
    if (direction == "H") {
      return Divider(
        height: 1,
        color: Color.fromARGB(255, 221, 218, 218),
      );
    }
    return VerticalDivider(
      width: 1,
      color:  const Color.fromARGB(255, 180, 180, 180),
    );
  }
}

class Texts extends StatelessWidget {
  const Texts({
    Key? key,
    required this.text,
    this.fontSize = 10,
    this.maxLine = 1,
    this.multiLine = true,
    this.color = Colors.white,
    this.textAlignment = TextAlign.start,
    this.bold = false,
    this.dot = false,
  }) : super(key: key);
  final String text;
  final int maxLine;
  final double fontSize;
  final bool multiLine;
  final Color color;
  final TextAlign textAlignment;
  final bool bold;
  final bool dot;

  @override
  Widget build(Object context) {
    return Row(
      children: [
        if (dot) ...[
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          10.horizontalSpace,
        ],
        Expanded(
          child: Text(
            text,
            style: textStyle,
            textAlign: textAlignment,
            maxLines: maxLine,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  TextStyle get textStyle {
    if (bold) {
      return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w700,
      );
    }
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }
}

extension Space on int {
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}

class ImageTextCell extends StatelessWidget {
  const ImageTextCell({
    Key? key,
    this.img,
    this.height,
    this.width,
    this.imgHeight,
    this.imgWidth,
    this.padding = 0,
    this.spaceBetweenImgAndText = 0,
    this.text,
    this.fontSize = 10,
    this.maxLine = 1,
    this.multiLine = true,
    this.color = Colors.white,
    this.textAlignment = TextAlign.start,
    this.borderRadius = 0,
    this.onTap,
    this.trimImgBorder = false,
  }) : super(key: key);
  final String? img;
  final double? height;
  final double? width;
  final double? imgHeight;
  final double? imgWidth;
  final double padding;
  final double spaceBetweenImgAndText;
  final String? text;
  final int maxLine;
  final double fontSize;
  final bool multiLine;
  final Color color;
  final TextAlign textAlignment;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool trimImgBorder;

  @override
  Widget build(Object context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade600,
            width: 2.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (img != null) ...[
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(trimImgBorder ? borderRadius : 0),
                child: Image.network(
                  img!,
                  height: imgHeight,
                  width: imgWidth,
                ),
              ),
              SizedBox(
                height: spaceBetweenImgAndText,
              ),
            ],
            if (text != null) ...[
              Text(
                text!,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color,
                ),
                textAlign: textAlignment,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    this.img,
    this.text,
    this.width,
    this.height,
    this.spaceBetweenImgAndText = 5,
    this.onTap,
  }) : super(key: key);
  final String? img;
  final String? text;
  final double? height;
  final double? width;
  final double spaceBetweenImgAndText;
  final Function(int)? onTap;

  @override
  Widget build(Object context) {
    return InkWell(
      onTap: () => onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 23, 95, 177),
          border: Border.all(
            color: Color.fromARGB(255, 23, 95, 177),
            width: 2.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (img != null) ...[
              Image.network(
                img!,
                width: 60,
                height: 40,
                color: Colors.white,
              ),
              SizedBox(
                height: spaceBetweenImgAndText,
              ),
            ],
            if (text != null) ...[
              Text(
                text!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
