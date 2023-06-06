import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(249, 50, 9, .2),
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: Colors.red[600], // Customize the app bar color
        ),
        body: Container(
          margin: EdgeInsets.all(50),
          width: 300,
          child: GridView.count(
            padding: const EdgeInsets.symmetric(vertical: 4),
            crossAxisCount: 1,
            childAspectRatio: 2,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: DashboardItem(
                    title: 'Users',
                    icon: Icons.people,
                    onPressed: () {
                      Navigator.pushNamed(context, 'UsersScreen');
                    },
                    color: Colors.orange, // Customize the item color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: DashboardItem(
                    title: 'Posts',
                    icon: Icons.list_alt_sharp,
                    onPressed: () {
                      Navigator.pushNamed(context, 'PostsScreen');
                    },
                    color: Colors.orange, // Customize the item color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: DashboardItem(
                    title: 'Reports',
                    icon: Icons.report,
                    onPressed: () {
                      Navigator.pushNamed(context, 'ReportsScreen');
                    },
                    color: Colors.red, // Customize the item color
                  ),
                ),
              ),
              // Add more dashboard items as needed
            ],
          ),
        ), // Customize the background color
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const DashboardItem({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 75, color: Colors.amber[900]),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
