import 'package:flutter/material.dart';
import 'package:flutter_consignment/models/product_model.dart';
import 'package:flutter_consignment/screens/login.dart';
import 'package:flutter_consignment/widgets/add_prod_dialog.dart';
import 'package:flutter_consignment/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  List<Product> products = [];
  bool productsLoading = false;
  @override
  void didChangeDependencies() {
    setState(() {
      productsLoading = true;
    });
    products = Provider.of<List<Product>>(context);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        productsLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Consignment Management System'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.logout))
        ],
        elevation: 1,
      ),
      body: SingleChildScrollView(
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
                    'Welcome Company!',
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
              const SizedBox(
                width: 30,
              ),
              Text('Your products: ${products.length}'),
              const SizedBox(
                width: 30,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        productsLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return ProductTile(
                                    product: products[index],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('Add Product'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    ProductFormDialog(onSave: (Product product) {}));
          }),
    );
  }
}
