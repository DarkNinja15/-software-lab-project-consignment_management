// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_consignment/constants/constants.dart';
import 'package:flutter_consignment/models/consignment_model.dart';
import 'package:flutter_consignment/models/product_model.dart';
import 'package:flutter_consignment/services/databse.dart';

class ConsignmentTile extends StatefulWidget {
  const ConsignmentTile({
    super.key,
    required this.consignment,
    required this.product,
  });
  final Consignment consignment;
  final Product product;

  @override
  State<ConsignmentTile> createState() => _ConsignmentTileState();
}

class _ConsignmentTileState extends State<ConsignmentTile> {
  @override
  Widget build(BuildContext context) {
    int val = getCompletionStatus[widget.product.status] ?? 0;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: GestureDetector(
              onTap: () {
                print('hello');
              },
              child: ListTile(
                leading: Image.network(
                  widget.product.photo,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(widget.consignment.consignmentName),
                subtitle: Text(
                    'Status: ${getStringStatus[widget.product.status] ?? 'PENDING'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Edit Product'),
                                content: SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                            widget.product.photo,
                                            fit: BoxFit.fill),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Consignment Name: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget
                                                  .consignment.consignmentName,
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
                                              text: widget.product.prodName,
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
                                              text: widget.product.price,
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
                                              text: 'Status: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: getStringStatus[
                                                      widget.product.status] ??
                                                  "PENDING",
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
                                      // Add other product details here
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Comments: \n',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.product.comments,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.remove_red_eye),
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Consignment'),
                              content: const Text(
                                  'Are you sure you want to delete this consignment?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    bool isSuccess = await Database()
                                        .deleteConsignment(
                                            widget.consignment.consignmentId);
                                    if (isSuccess) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Consignment Deleted Successfully',
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Error Deleting Consignment'),
                                        ),
                                      );
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: LinearProgressIndicator(
            value: val != -1 ? val / 5 : 1,
            backgroundColor: Colors.grey[200],
            valueColor: val != -1
                ? const AlwaysStoppedAnimation<Color>(
                    Colors.green,
                  )
                : const AlwaysStoppedAnimation<Color>(
                    Colors.red,
                  ),
          ),
        ),
      ],
    );
  }
}
