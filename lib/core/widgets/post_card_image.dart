import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/core/utils/helpers.dart';

class PostCardImage extends StatelessWidget {
  final String url;
  const PostCardImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        getS3Url(url),
        width: double.infinity,
        height: context.height * 0.4,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
      ),
    );
  }
}
