import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final Color themeColor;

  const HomeScreen({super.key, required this.themeColor});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Artboard? _artboard;
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final data = await rootBundle.load('assets/animations.riv');
    final file = RiveFile.import(data);

    setState(() {
      _artboard = file.mainArtboard;
      _controller = SimpleAnimation('idle happy 2');
      _artboard!.addController(_controller);
    });
  }

  void _changeAnimation(String animationName) {
    setState(() {
      _artboard!.removeController(_controller);
      _controller = SimpleAnimation(animationName);
      _artboard!.addController(_controller);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: widget.themeColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _artboard != null
                ? SizedBox(
                    height: 550, // Increased height for the animation
                    width: 350, // Increased width for the animation
                    child: Rive(
                      artboard: _artboard!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _changeAnimation('walking');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 70.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Walk',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Set the background color to white
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: widget.themeColor,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
