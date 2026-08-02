import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const TradingVoiceApp());
}

class TradingVoiceApp extends StatelessWidget {
  const TradingVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading Voice App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1016),
      ),
      home: const StrategyBuilderPage(),
    );
  }
}

class StrategyBuilderPage extends StatefulWidget {
  const StrategyBuilderPage({super.key});

  @override
  State<StrategyBuilderPage> createState() => _StrategyBuilderPageState();
}

class _StrategyBuilderPageState extends State<StrategyBuilderPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _pickChartImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading Voice App - Strategy Builder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Upload Chart Screenshot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickChartImage,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1E33),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImage != null
                    ? Center(
                        child: Text(
                          'Selected: ${_selectedImage!.name}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 40, color: Colors.blueAccent),
                          SizedBox(height: 8),
                          Text('Tap to select chart image', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
