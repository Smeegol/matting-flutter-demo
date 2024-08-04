import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matting_plugin/matting_plugin.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _resultFile;

  @override
  initState() {
    super.initState();
    _startMatting();
  }

  _startMatting() async {
    final originPath = await _saveAssetToCache('origin.png');
    final maskPath = await _saveAssetToCache('mask.jpeg');
    print('originPath = $originPath');
    print('maskPath = $maskPath');
    if (originPath == null || maskPath == null) {
      return;
    }

    try {
      final resultPath = await MattingPlugin().startMatting(originPath, maskPath);
      print('resultPath = $resultPath');
      if (resultPath != null) {
        if (mounted) {
          setState(() {
            _resultFile = File(resultPath);
          });
        }
      }
    } catch (error) {
      print('error = $error');
    }
  }

  Future<String?> _saveAssetToCache(String assetFileName) async {
    try {
      final data = await rootBundle.load('assets/$assetFileName');
      final bytes = data.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final file = File('$tempPath/$assetFileName');
      final file2 = await file.writeAsBytes(bytes, flush: true);
      return file2.path;
    } catch (error) {
      print('[$runtimeType][doAfterInitState] error = $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: GridView(
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 1,
    //       mainAxisSpacing: 10,
    //       crossAxisSpacing: 0,
    //       mainAxisExtent: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical - 10 * 2) / 3,
    //     ),
    //     children: [
    //       Image.asset('assets/origin.png'),
    //       Image.asset('assets/mask.jpeg'),
    //       _resultFile == null ? Container() : Image.file(_resultFile!),
    //     ],
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _resultFile == null ? Container() : Image.file(_resultFile!),
              Image.asset('assets/origin.png'),
              Image.asset('assets/mask.jpeg'),
            ],
          ),
        ),
      ),
    );
  }
}
