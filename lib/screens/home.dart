import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Consignment Management System'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.account_circle,
                size: 30,
              ),
              color: Colors.grey,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Edit Name'),
                      content: TextField(
                        controller: TextEditingController(text: 'EvilShadow'),
                        onChanged: (value) {},
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Save'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('You are about to get logged out'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout))
        ],
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          // physics: const ,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Welcome EvilShadow!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/delivery.png',
                      height: 80,
                    ),
                  ],
                ),
                const Text('Your Consignments: 0'),
                Row(
                  children: [
                    Flexible(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 100,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: ListTile(
                                          title: const Text('Consignment1'),
                                          subtitle:
                                              const Text('Status: Active'),
                                          trailing: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Delete Consignment'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this consignment?'),
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                              'Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                              'Delete'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.delete),
                                              color: Colors.red),
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: LinearProgressIndicator(
                                        value: 0.5,
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                    const Flexible(
                      flex: 2,
                      child: SizedBox.shrink(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Create Consignment'),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Consignment Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Product ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(),
                    child: const Text('Create'),
                    onPressed: () {
                      print('Creating consignment');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
