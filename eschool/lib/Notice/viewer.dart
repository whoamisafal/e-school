import 'package:flutter/material.dart';

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViwer extends StatelessWidget {
  final String  url;
  PDFViwer({@required this.url});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       
        body: const PDF().cachedFromUrl(
          url,
          placeholder: (double progress) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (dynamic error) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
