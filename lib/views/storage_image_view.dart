import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImageView extends StatelessWidget {
  final Reference image;
  const StorageImageView({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: image.getData(),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Image.memory(
                  data,
                  fit: BoxFit.cover,
                );
              } else {
                // consider handling error => if (snapshot.hasError))
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        });
  }
}
