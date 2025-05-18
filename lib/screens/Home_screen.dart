import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:learning2/screens/notification_screen.dart';
import 'package:learning2/screens/profile_screen.dart';
import 'package:learning2/screens/dashboard_screen.dart';
import 'package:learning2/screens/schema.dart';
import 'package:learning2/screens/token_scan.dart';
import 'package:learning2/screens/live_location_screen.dart';
import '../dsr_entry_screen/dsr_entry.dart';
import 'mail_screen.dart';
import 'app_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import '../chat_screen.dart'; // Removed

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final List<Widget> _screens = [
    const HomeContent(),
    const DashboardScreen(),
    const MailScreen(),
    const ProfilePage(),
  ];

  // Store the current screen.  Important for keeping bottom nav.
  Widget _currentScreen = const HomeContent();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to update the current screen.  Crucial for bottom nav persistence.
  void _updateCurrentScreen(int index, {Widget? screen}) {
    if (mounted) {
      //Check if the widget is still mounted.
      setState(() {
        _selectedIndex = index;
        _currentScreen =
            screen ?? _screens[index]; // Use provided screen or default
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Wrap your Scaffold with WillPopScope
      onWillPop: () async {
        // Handle back button press here
        if (_selectedIndex != 0) {
          //check if bottom navigation is selected
          _updateCurrentScreen(0); // Go back to the home screen
          return false; // Prevent default back button behavior (closing the app)
        }
        return true; // Allow closing the app from the home screen
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            // Use _currentScreen here.
            _currentScreen,
            _buildSearchInput(context),
          ],
        ),
        bottomNavigationBar: _buildPremiumBottomBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 4,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.blue],
          ),
        ),
      ),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star, color: Colors.white, size: 28),
          SizedBox(width: 8),
          Text(
            'SPARSH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
            print('Notifications tapped');
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child:
              _isSearchVisible
                  ? const SizedBox(width: 48, height: 48)
                  : IconButton(
                    key: const ValueKey('search_icon'),
                    icon: const Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearchVisible = true;
                      });
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isSearchVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Visibility(
        visible: _isSearchVisible,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for reports, orders, etc...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isSearchVisible = false;
                        _searchController.clear();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onSubmitted: (value) {
                  print('Searching for: $value');
                  setState(() {
                    _isSearchVisible = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBottomBar() {
    final List<Map<String, dynamic>> navItems = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Home',
        'color': Colors.blue.shade700,
        'gradient': LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade700],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.dashboard_outlined,
        'activeIcon': Icons.dashboard,
        'label': 'Dashboard',
        'color': Colors.purpleAccent,
        'gradient': LinearGradient(
          colors: [Colors.purple.shade300, Colors.purpleAccent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.qr_code_scanner,
        'activeIcon': Icons.qr_code_scanner,
        'label': 'Scan',
        'color': Colors.blueAccent,
        'gradient': LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue.shade600],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.schema_outlined,
        'activeIcon': Icons.schema,
        'label': 'Scheme',
        'color': Colors.orange,
        'gradient': LinearGradient(
          colors: [Colors.orange.shade300, Colors.deepOrange],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Profile',
        'color': Colors.green,
        'gradient': LinearGradient(
          colors: [Colors.teal.shade300, Colors.green.shade600],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Enhanced glass morphism background with parallax effect
        ClipPath(
          clipper: BottomNavClipper(),
          child: Container(
            height: 95,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFEAF6FF).withOpacity(0.8),
                  const Color(0xFFD6ECFF).withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, -5),
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.blue.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(navItems.length, (index) {
                  if (index == 2) return const SizedBox(width: 70);

                  final item = navItems[index];
                  final isActive = _selectedIndex == index;
                  final color = item['color'] as Color;
                  final gradient = item['gradient'] as Gradient;

                  return GestureDetector(
                    onTap: () {
                      if (index == 3) {
                        _updateCurrentScreen(index, screen: const Schema());
                      } else if (index == 4) {
                        _updateCurrentScreen(
                          index,
                          screen: const ProfilePage(),
                        );
                      } else {
                        _updateCurrentScreen(index);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: isActive ? gradient : null,
                        boxShadow:
                            isActive
                                ? [
                                  BoxShadow(
                                    color: color.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isActive ? item['activeIcon'] : item['icon'],
                            color:
                                isActive ? Colors.white : Colors.grey.shade600,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  isActive
                                      ? Colors.white
                                      : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // Floating Scanner Button with pulse animation
        Positioned(
          bottom: 30,
          child: GestureDetector(
            onTap: () {
              _updateCurrentScreen(2, screen: const TokenScanPage());
            },
            child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.shade400,
                        Colors.blueAccent.shade700,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: Offset.zero,
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 28,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  delay: 1000.ms,
                  duration: 1800.ms,
                  color: Colors.white.withOpacity(0.3),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ),
      ],
    );
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double notchRadius = 30;
    final double centerX = size.width / 2;
    const double notchWidth = notchRadius * 2 + 30;

    final path =
        Path()
          ..lineTo(centerX - notchWidth / 2, 0)
          ..quadraticBezierTo(
            centerX - notchRadius - 15,
            0,
            centerX - notchRadius,
            25,
          )
          ..arcToPoint(
            Offset(centerX + notchRadius, 25),
            radius: const Radius.circular(notchRadius),
            clockwise: false,
          )
          ..quadraticBezierTo(
            centerX + notchRadius + 15,
            0,
            centerX + notchWidth / 2,
            0,
          )
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;
  final List<String> _bannerImagePaths = [
    'assets/image1.png',
    'assets/image21.jpg',
    'assets/image22.jpg',
    'assets/image23.jpg',
    'assets/image24.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (_bannerImagePaths.length > 1) {
      _startAutoScroll();
    }
    _pageController.addListener(() {
      if (_pageController.position.isScrollingNotifier.value == false) {
        _restartAutoScroll();
      }
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) {
        timer.cancel();
        return;
      }
      double itemWidth = MediaQuery.of(context).size.width;
      double spacing = 10;
      double fullItemWidth = itemWidth + spacing;
      double maxScroll = _pageController.position.maxScrollExtent;
      double nextPosition = _currentIndex * fullItemWidth;

      if (nextPosition > maxScroll - itemWidth / 2) {
        _currentIndex = 0;
        nextPosition = 0;
      } else {
        _currentIndex++;
      }

      _pageController.animateTo(
        nextPosition,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoScroll() {
    _autoScrollTimer?.cancel();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _bannerImagePaths.length > 1) {
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.removeListener(_restartAutoScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildBanner(),
            const SizedBox(height: 20),
            _sectionTitle("Mostly Used Apps"),
            const SizedBox(height: 10),
            _mostlyUsedApps(screenWidth, screenHeight),
            const SizedBox(height: 20),
            const HorizontalMenu(),
            const SizedBox(height: 20),
            _sectionTitle("Quick Menu"),
            const SizedBox(height: 10),
            _quickMenu(screenHeight, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _quickMenu(double screenHeight, double screenWidth) {
    final List<Map<String, String>> quickMenuItems = [
      {'image': 'assets/image37.png', 'label': 'RPL Outlet\nTracker'},
      {'image': 'assets/image38.png', 'label': 'GKC\nLead Entry'},
      {'image': 'assets/image8.png', 'label': 'RPL Outlet\nTracker'},
      {'image': 'assets/image39.png', 'label': 'Training\nFeedback'},
      {'image': 'assets/image28.png', 'label': 'Settings'},
      {'image': 'assets/image29.png', 'label': 'Sales\nSummary'},
      {'image': 'assets/image30.png', 'label': 'Inventory'},
      {'image': 'assets/image31.png', 'label': 'Order\nHistory'},
      {'image': 'assets/image32.png', 'label': 'Delivery\nStatus'},
      {'image': 'assets/image40.png', 'label': 'First Aid\nPersonal'},
      {
        'image': 'assets/location_icon.png',
        'label': 'Live Location',
      }, // Add this line
    ];
    final double itemWidth = screenWidth / 4;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: itemWidth / (itemWidth + 40),
        ),
        itemCount: quickMenuItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = quickMenuItems[index];
          return GestureDetector(
            onTap: () {
              print("${item['label']} tapped");
              if (item['label'] == 'Live Location') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveLocationScreen(),
                  ),
                );
              }
            },
            child: _buildQuickMenuItem(
              item['image']!,
              item['label']!,
              itemWidth,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickMenuItem(String imagePath, String label, double itemWidth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: itemWidth * 0.6,
          height: itemWidth * 0.6,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _mostlyUsedApps(double screenWidth, double screenHeight) {
    final List<Map<String, String>> mostlyUsedItems = [
      {'image': 'assets/image33.png', 'label': 'DSR', 'route': 'dsr'},
      {
        'image': 'assets/image34.png',
        'label': 'Staff\nAttendance',
        'route': 'attendance',
      },
      {
        'image': 'assets/image35.png',
        'label': 'DSR\nException',
        'route': 'dsr_exception',
      },
      {
        'image': 'assets/image36.png',
        'label': 'Token Scan',
        'route': 'scanner',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            mostlyUsedItems.map((item) {
              return InkWell(
                onTap: () {
                  print('${item['label']} tapped');
                  if (item['route'] == 'dsr') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DsrEntry()),
                    );
                  } else if (item['route'] == 'scanner') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TokenScanPage(),
                      ),
                    );
                  }
                },
                child: _buildMostlyUsedAppItem(item['image']!, item['label']!),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMostlyUsedAppItem(String imagePath, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _bannerImagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _bannerImagePaths[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          if (_bannerImagePaths.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_bannerImagePaths.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentIndex == index ? 16 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index
                              ? Colors.blue
                              : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(
    double screenWidth,
    double screenHeight,
    String imagePath,
  ) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade400, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.0),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}

class HorizontalMenu extends StatefulWidget {
  const HorizontalMenu({super.key});

  @override
  State<HorizontalMenu> createState() => _HorizontalMenuState();
}

class _HorizontalMenuState extends State<HorizontalMenu> {
  String selected = "Quick Menu";

  final List<String> menuItems = [
    "Quick Menu",
    "Document",
    "Registration",
    "Entertainment",
    "Painter",
    "Attendance",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final label = menuItems[index];
          final isSelected = selected == label;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.blue,
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.grey.shade400,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                setState(() {
                  selected = label;
                });
                print('$label selected');
              },
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
