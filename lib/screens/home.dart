import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_consignment/models/consignment_model.dart';
import 'package:flutter_consignment/models/product_model.dart';
// import 'package:flutter_consignment/models/user_model.dart';
import 'package:flutter_consignment/screens/login.dart';
import 'package:flutter_consignment/services/databse.dart';
// import 'package:flutter_consignment/services/local%20storage/user_preferences.dart';
import 'package:flutter_consignment/widgets/consignment_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController prodIdcontroller = TextEditingController();
  List<Consignment> myConsignments = [];
  List<Product> allProds = [];
  final _formKey = GlobalKey<FormState>();
  bool consignmentsLoading = false;

  @override
  void dispose() {
    namecontroller.dispose();
    prodIdcontroller.dispose();
    super.dispose();
  }

  String userName = '';
  bool isLoadingDialog = false;
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      consignmentsLoading = true;
    });
    final prods = Provider.of<List<Consignment>>(context);
    allProds = Provider.of<List<Product>>(context);
    myConsignments = [];
    for (int i = 0; i < prods.length; i++) {
      if (prods[i].userid == FirebaseAuth.instance.currentUser!.uid) {
        myConsignments.add(prods[i]);
      }
    }
    myConsignments.sort(
      (a, b) {
        return a.consignmentName.compareTo(b.consignmentName);
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        consignmentsLoading = false;
      });
    });

    super.didChangeDependencies();
  }

  void getUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userName = value.data()!['name'];
    });
  }

  bool isLoading = false;
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
                        controller: TextEditingController(text: userName),
                        onChanged: (value) {
                          userName = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        isLoadingDialog
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : TextButton(
                                child: const Text('Save'),
                                onPressed: () async {
                                  setState(() {
                                    isLoadingDialog = true;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    'name': userName,
                                  }).then((value) {
                                    Navigator.of(context).pop();
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(error.toString()),
                                      ),
                                    );
                                  });
                                  setState(() {
                                    isLoadingDialog = true;
                                  });
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
                        isLoadingDialog
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : TextButton(
                                child: const Text('Logout'),
                                onPressed: () async {
                                  setState(() {
                                    isLoadingDialog = true;
                                  });
                                  await FirebaseAuth.instance
                                      .signOut()
                                      .then((value) {
                                    Navigator.of(context)
                                        .pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ),
                                    )
                                        .catchError((error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                        ),
                                      );
                                    });
                                  });
                                  setState(() {
                                    isLoadingDialog = false;
                                  });
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SingleChildScrollView(
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
                        Text(
                          'Welcome $userName!',
                          style: const TextStyle(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Your Consignments: ${myConsignments.length}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              consignmentsLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: myConsignments.length,
                                      itemBuilder: (context, index) {
                                        return ConsignmentTile(
                                          consignment: myConsignments[index],
                                          product:
                                              allProds.firstWhere((element) {
                                            return element.prodId ==
                                                myConsignments[index]
                                                    .consignmentId;
                                          }),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Create Consignment'),
                content: SizedBox(
                  width: 300,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: namecontroller,
                          decoration: const InputDecoration(
                            labelText: 'Consignment Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: prodIdcontroller,
                          decoration: const InputDecoration(
                            labelText: 'Product ID',
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter a product id';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoadingDialog = true;
                        });
                        await Database()
                            .createConsignment(prodIdcontroller.text.trim(),
                                namecontroller.text.trim(), context)
                            .then((value) {
                          prodIdcontroller.text = "";
                          namecontroller.text = "";
                          Navigator.of(context).pop();
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Success')));
                          }
                        });
                        setState(() {
                          isLoadingDialog = false;
                        });
                      }
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
