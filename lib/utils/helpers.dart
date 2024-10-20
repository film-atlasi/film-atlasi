import 'package:flutter/material.dart';

Widget AddVerticalSpace(BuildContext context, double size) => SizedBox(
      height: MediaQuery.of(context).size.height * size,
    );

Widget AddHorizontalSpace(BuildContext context, double size) => SizedBox(
      width: MediaQuery.of(context).size.width * size,
    );
