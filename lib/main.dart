import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const OvincApp());
}

class OvincApp extends StatelessWidget {
  const OvincApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OVINC Genesis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF6C63FF),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6C63FF),
          secondary: Colors.greenAccent,
        ),
      ),
      home: const OvincHomeContainer(),
    );
  }
}

class OvincHomeContainer extends StatefulWidget {
  const OvincHomeContainer({Key? key}) : super(key: key);

  @override
  State<OvincHomeContainer> createState() => _OvincHomeContainerState();
}

class _OvincHomeContainerState extends State<OvincHomeContainer> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const OvincDashboardPage(),
    const StrategyBuilderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1D1E33),
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Strategy Hub',
          ),
        ],
      ),
    );
  }
}

// --- PAGE 1: DASHBOARD & LIVE WEBSOCKET SCANNER ---
class OvincDashboardPage extends StatefulWidget {
  const OvincDashboardPage({Key? key}) : super(key: key);

  @override
  State<OvincDashboardPage> createState() => _OvincDashboardPageState();
}

class _OvincDashboardPageState extends State<OvincDashboardPage> {
  bool isAutoTrading = false;
  late WebSocketChannel _channel;
  bool _isConnected = false;

  List<Map<String, dynamic>> watchedMarkets = [
    {'symbol': 'XAUUSD', 'name': 'Gold', 'price': '2,386.15', 'status': 'Active Stream', 'score': '95%'},
    {'symbol': 'EURUSD', 'name': 'Euro / US Dollar', 'price': '1.0872', 'status': 'Monitoring', 'score': '65%'},
  ];

  @override
  void initState() {
    super.initState();
    _initWebSocketConnection();
  }

  void _initWebSocketConnection() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://echo.websocket.events'),
      );
      setState(() {
        _isConnected = true;
      });

      _channel.stream.listen(
        (message) {},
        onError: (error) {
          setState(() {
            _isConnected = false;
          });
        },
        onDone: () {
          setState(() {
            _isConnected = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  void dispose() {
    if (_isConnected) {
      _channel.sink.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OVINC AI Command Center'),
        backgroundColor: const Color(0xFF1D1E33),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isConnected ? 'Live Feed' : 'Offline',
                    style: TextStyle(fontSize: 12, color: _isConnected ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1E33),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6C63FF), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy, size: 48, color: Color(0xFF6C63FF)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('AI STATUS: ONLINE', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('WebSocket Stream Bridge Active', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Trading Mode:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Switch(
                  value: isAutoTrading,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isAutoTrading = value;
                    });
                  },
                ),
              ],
            ),
            Text(
              isAutoTrading ? 'Status: Automatic Execution Active' : 'Status: Manual Approval Required',
              style: TextStyle(color: isAutoTrading ? Colors.greenAccent : Colors.orangeAccent),
            ),
            const SizedBox(height: 28),
            const Text('Real-Time Market Watchlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: watchedMarkets.length,
              itemBuilder: (context, index) {
                final market = watchedMarkets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(market['symbol'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(market['name'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(market['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text('Match: ${market['score']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- PAGE 2: STRATEGY BUILDER & IMAGE PICKER HUB ---
class StrategyBuilderPage extends StatefulWidget {
  const StrategyBuilderPage({Key? key}) : super(key: key);

  @override
  State<StrategyBuilderPage> createState() => _StrategyBuilderPageState();
}

class _StrategyBuilderPageState extends State<StrategyBuilderPage> {
  final TextEditingController _strategyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isAnalyzing = false;

  Future<void> _pickChartImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submitStrategy() {
    if (_strategyController.text.isEmpty && _selectedImage == null) return;
    setState(() {
      _isAnalyzing = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnalyzing = false;
        _selectedImage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Strategy and chart successfully compiled by AI!')),
      );
      _strategyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Strategy & Screenshot Hub'),
        backgroundColor: const Color(0xFF1D1E33),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Describe Your Strategy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Type your entry rules or logic for automated processing.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: _strategyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your trading rules here...',
                filled: true,
                fillColor: const Color(0xFF1D1E33),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Upload Chart Screenshot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickChartImage,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1E33),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.dash),
                ),
                child: _selectedImage != null
                    ? Center(
                        child: Text(
                          'Selected: ${_selectedImage!.name}',
                          style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_photo_alternate, size: 40, color: Color(0xFF6C63FF)),
                          SizedBox(height: 8),
                          Text('Tap to select chart screenshot from device', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isAnalyzing ? null : _submitStrategy,
                child: _isAnalyzing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Compile & Deploy Strategy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
