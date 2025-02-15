import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thread_clone_app/utils/helpers.dart';

class ImageCircle extends StatelessWidget {
  final double radius;
  final String? url;
  final File? file;
  const ImageCircle({
    super.key,
    required this.radius,
    this.url,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (file != null)
          CircleAvatar(radius: radius, backgroundImage: FileImage(file!))
        else if (url != null)
          CircleAvatar(radius: radius, backgroundImage: NetworkImage(getS3Url(url!)))
        else
          CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
      ],
    );
  }
}
