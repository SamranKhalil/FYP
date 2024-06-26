import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:my_project/diet_tracker.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final Color themeColor;
  final String token;
  const HomeScreen({super.key, required this.themeColor, required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.robotoSlab(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        // backgroundColor: widget.themeColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.themeColor,
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.robotoSlab(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // No need to navigate since we're already on Home
              },
            ),
            ListTile(
              leading: const Icon(Icons.food_bank_outlined),
              title: const Text('Diet Tracker'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _navigateToScreen(
                    context,
                    DietTracker(
                        themeColor: widget.themeColor, token: widget.token));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Profile screen
                // _navigateToScreen(context, ProfileScreen(themeColor: widget.themeColor));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Settings screen
                // _navigateToScreen(context, SettingsScreen(themeColor: widget.themeColor));
              },
            ),
          ],
        ),
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
    );
  }
}
