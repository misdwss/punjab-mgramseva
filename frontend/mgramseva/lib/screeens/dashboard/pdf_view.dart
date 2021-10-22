import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
class PdfPreview extends StatefulWidget {
  final String path;
  const PdfPreview({Key? key, required this.path}) : super(key: key);
  @override
  _PdfPreviewState createState() => _PdfPreviewState();
}
class _PdfPreviewState extends State<PdfPreview> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (_pages) {
              // setState(() {
              //   pages = _pages;
              //   isReady = true;
              // });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            }
        ),
      ),
    );
  }
}