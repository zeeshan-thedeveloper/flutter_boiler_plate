import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/managers/socket_manager.dart';
import 'package:flutter_boiler_plate/managers/storage_manager.dart';
import 'package:flutter_boiler_plate/pages/dashboard/dashboard_body.dart';
import 'package:flutter_boiler_plate/pages/dashboard/settings.dart';
import 'package:flutter_boiler_plate/pages/home.dart';
import 'package:flutter_boiler_plate/utils/app_styles.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _selectedItem = 'Dashboard'; // Initialize the selected item
  late SocketManager socket;
  late StorageManager storageManager;
  String _currentProjectTitle = ''; // Initialize the current project title

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSocketConnection();
      _listenToCurrentProjectChanges();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // storageManager = Provider.of<StorageManager>(context);
  //   // Call method to fetch projects when dependencies change
  //   _getCurrentProjectUnderWork();
  // }

  void _initSocketConnection() {
    socket = Provider.of<SocketManager>(context, listen: false);
    socket.connect(); // Call connect method here
  }

 

  void _listenToCurrentProjectChanges() {
    storageManager = Provider.of<StorageManager>(context, listen: false);

    // Listen to changes in the current project under work
    storageManager.addListener(() {
      Project? currentProject = storageManager.getCurrentProjectUnderWork();
      if (currentProject != null) {
        setState(() {
          _currentProjectTitle = currentProject.title;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget _getSelectedScreen() {
      // Return the screen widget based on the selected item
      // print(_selectedItem);
      switch (_selectedItem) {
        case 'Dashboard':
          return DashboardBody(); // Show Dashboard content
        case 'Settings':
          return Settings(); // Show Settings content
        // Add cases for other sidebar items if needed
        default:
          return Container(); // Default empty container
      }
    }

    return Scaffold(
        backgroundColor: AppTheme.background_color_contrast,
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: [
              Drawer(
                width: 230,
                backgroundColor: AppTheme.background_color,
                child: ListView(
                  children: [
                    Container(
                      height: 90, // Set the desired height here
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: AppTheme.background_color,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'lib/utils/images/girl_sitting.png'), // Replace with your image path
                                    radius: 20, // Set your desired radius
                                  ), // Replace with your icon
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Zeeshan Ahmed', // Replace with user's name
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Co-founder', // Replace with user's role or subtitle
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Add more widgets below the row as needed
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Divider(color: Colors.white.withOpacity(0.3)),
                    // Listview
                    ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.white, // Set the text color here
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedItem = 'Dashboard';
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white, // Set the text color here
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedItem = 'Settings';
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white, // Set the text color here
                        ),
                      ),
                      onTap: () {
                        SocketManager socket =
                            Provider.of<SocketManager>(context, listen: false);
                        socket
                            .disconnectSocket(); // Disconnect socket connection

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                    // Add other ListTiles or widgets for drawer items
                  ],
                ),
              ),

              // Container on the right
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth - 230,
                        height: 100,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: AppTheme.background_color_overlay,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Dashboard',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Toggle play/pause functionality
                                  },
                                  icon: Icon(Icons.play_arrow),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Working on : $_currentProjectTitle', // Another text below Work Hrs Today
                                  style: TextStyle(color: Colors.white),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '01:32:22', // Another text below Work Hrs Today
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Work Hrs Today: 8', // Display work hours today here
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _getSelectedScreen()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
