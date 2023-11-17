// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_consignment/constants/constants.dart';
import 'package:flutter_consignment/models/product_model.dart';
import 'package:flutter_consignment/services/databse.dart';
// import 'package:dropdown_below/dropdown_below.dart';
// import 'package:flutter_consignment/widgets/custom_dropdown.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Material(
        elevation: 3,
        child: SelectionArea(
          child: ListTile(
            dense: true,
            isThreeLine: true,
            leading: Image.network(
              widget.product.photo,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              '${widget.product.prodName} (${widget.product.prodId})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Status : ${getStringStatus[widget.product.status] ?? "PENDING"}',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                _showEditDialog(context, widget.product);
              },
              icon: const Icon(Icons.edit, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Product product) {
    String selectedStatus = getStringStatus[product.status] ?? "PENDING";
    String comment = product.comments;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Product'),
              content: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(product.photo, fit: BoxFit.fill),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Product id: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: product.prodId,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Product Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: product.prodName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Price: ₹',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: product.price,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            focusColor: Colors.transparent,
                            value: selectedStatus,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            onChanged: (val) {
                              setState(() {
                                selectedStatus = val!;
                              });
                            },
                            items: [
                              'PENDING',
                              'COMPLETED',
                              'CANCELLED',
                              'IN_TRANSIT',
                              'DELIVERED',
                              'RETURNED',
                              'LOST',
                              'DAMAGED',
                              'ON_HOLD'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                    // Add other product details here
                    TextFormField(
                      controller: TextEditingController(text: comment),
                      decoration: const InputDecoration(labelText: 'Comment'),
                      onChanged: (value) {
                        comment = value;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    bool isSuccess = await Database()
                        .updateProduct(selectedStatus, comment, product.prodId);
                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product updated successfully'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update product'),
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
