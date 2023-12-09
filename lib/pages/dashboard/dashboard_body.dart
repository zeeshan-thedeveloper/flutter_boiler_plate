import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/utils/app_styles.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({Key? key}) : super(key: key);

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: AppTheme.background_color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              _buildProjectCard('Project 1', '01:32:22'),
              _buildProjectCard('Project 2', '02:15:47'),
              // Add more project cards as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(String projectName, String time) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: AppTheme.background_color_overlay, // Replace with your desired color
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              projectName,
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                        time,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey[800],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    // Handle play/pause functionality for the project
                  },
                  icon: const Icon(Icons.play_arrow),
                  color: Colors.white,
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Handle tap for the project
        },
      ),
    );
  }
}
