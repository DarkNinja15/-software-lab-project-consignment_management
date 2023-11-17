// ignore_for_file: use_build_context_synchronously

// import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_consignment/constants/constants.dart';
// import 'package:flutter_consignment/models/consignment_model.dart';
import 'package:flutter_consignment/services/databse.dart';
import 'package:flutter_consignment/services/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_consignment/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductFormDialog extends StatefulWidget {
  final Function(Product) onSave;

  const ProductFormDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  _ProductFormDialogState createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Uint8List? _image;

  _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = await pickedFile.readAsBytes();
    }

    setState(() {
      if (pickedFile != null) {
        // _image = File(pickedFile.path);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _commentController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _getImage,
              child: _image != null
                  ? SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.memory(_image!),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Icon(Icons.camera_alt,
                          size: 40, color: Colors.grey[600]),
                    ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                // You can add additional validation for the price
                return null;
              },
            ),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
              maxLines: 3,
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
            if (_formKey.currentState?.validate() ?? false) {
              // Validation passed, save the product and close the dialog

              String downLoadUrl = await StorageMethods()
                  .uploadImageToStorage('company1', _image!);
              // print(downLoadUrl);
              final newProduct = Product(
                prodId: const Uuid().v1(),
                status: ConsignmentStatus.PENDING,
                prodName: _nameController.text,
                price: _priceController.text,
                comments: _commentController.text,
                photo: downLoadUrl,
              );
              Navigator.of(context).pop();
              bool isSuccess = await Database().createProduct(newProduct);
              if (isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Product added successfully'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to add product'),
                ));
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
