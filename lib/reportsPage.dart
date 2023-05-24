import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.red[600],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of reports: 3',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/user1.png'),
                        ),
                        title: Text('ALi banana \n'
                            'Post Link :   \n '
                            'https://posts/post1'),
                      ),
                    );
                  }
                  if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/user2.png'),
                        ),
                        title: Text('Fares Karbia \n'
                            'Post Link :    \n'
                            'https://posts/post85'),
                      ),
                    );
                  }
                  if (index == 2) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/user3.png'),
                        ),
                        title: Text('koka RAouf \n'
                            'Post Link :    \n'
                            'https://posts/post45'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
