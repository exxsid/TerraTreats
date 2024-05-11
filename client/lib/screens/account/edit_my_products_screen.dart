import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terratreats/models/my_product_model.dart';

import 'package:terratreats/models/product_model.dart';
import 'package:terratreats/riverpod/my_products_riverpod.dart';
import 'package:terratreats/services/category_service.dart';
import 'package:terratreats/services/selected_product_service.dart';
import 'package:terratreats/services/seller/my_products_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/appbar.dart';

class EditMyProducts extends ConsumerStatefulWidget {
  final int productId;
  const EditMyProducts({super.key, required this.productId});

  @override
  ConsumerState<EditMyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends ConsumerState<EditMyProducts> {
  final _formKey = new GlobalKey<FormState>();

  String? _formValidator(String? value) {
    if (value!.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? _selectedCategory;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.customAppBar(title: "My Product"),
      body: Container(
        child: FutureBuilder(
          future: getSelectedProduct(widget.productId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final product = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productImageView(product, context),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productNameFormField(product.name),
                          const SizedBox(
                            height: 8,
                          ),
                          priceUnitFormField(product.price, product.unit),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                "${product.rating} rating",
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "${product.sold} sold",
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            product.seller,
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          descriptionFormField(product.description),
                          const SizedBox(
                            height: 16,
                          ),
                          stockFormField(product.stock),
                          const SizedBox(
                            height: 16,
                          ),
                          shippingFeeFormField(product.shippingFee),
                          const SizedBox(
                            height: 16,
                          ),
                          categoryFormField(product),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              saveButton(
                                updatedProduct: MyProductModel(
                                  productId: product.productId,
                                  name:
                                      ref.watch(myProductNotifierProvider).name,
                                  description: ref
                                      .watch(myProductNotifierProvider)
                                      .description,
                                  price: ref
                                      .watch(myProductNotifierProvider)
                                      .price,
                                  stock: ref
                                      .watch(myProductNotifierProvider)
                                      .stock,
                                  unit:
                                      ref.watch(myProductNotifierProvider).unit,
                                  image: convertImageToBase64(),
                                  category: ref
                                      .watch(myProductNotifierProvider)
                                      .category,
                                  shippingFee: ref
                                      .watch(myProductNotifierProvider)
                                      .shippingFee,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              cancelButton(context),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Row categoryFormField(Product product) {
    return Row(
      children: [
        Text(
          "Category",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        FutureBuilder(
          future: getCategory(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final categories = snapshot.data!;
            return DropdownButton(
              style: TextStyle(
                color: AppTheme.secondary,
              ),
              value: ref.watch(myProductNotifierProvider).category,
              items: categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.cardTitle,
                      child: Text(category.cardTitle),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                ref
                    .read(myProductNotifierProvider.notifier)
                    .updateCategory(value!);
              },
            );
          },
        )
      ],
    );
  }

  OutlinedButton cancelButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  OutlinedButton saveButton({required MyProductModel updatedProduct}) {
    return OutlinedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        print("gago ${updatedProduct.name}");
        await updateMyProduct(
          product: updatedProduct,
        );
        setState(() {});
        final snackBar = SnackBar(
          content: Text("Product updated successfully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Text(
        "Save",
        style: TextStyle(color: Colors.white),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  Column shippingFeeFormField(double shippingFee) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Shipping Fee",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          initialValue: shippingFee.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(
            color: AppTheme.secondary,
            fontSize: 15,
          ),
          validator: _formValidator,
          onChanged: (value) {
            ref
                .read(myProductNotifierProvider.notifier)
                .updateShippingFee(double.parse(value));
          },
        ),
      ],
    );
  }

  Column stockFormField(int stock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Stock",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          initialValue: stock.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(
            color: AppTheme.secondary,
            fontSize: 15,
          ),
          validator: _formValidator,
          onChanged: (value) {
            ref
                .read(myProductNotifierProvider.notifier)
                .updateStock(int.parse(value));
          },
        ),
      ],
    );
  }

  Column descriptionFormField(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          initialValue: description,
          maxLines: 20,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: TextStyle(
            color: AppTheme.secondary,
            fontSize: 15,
          ),
          validator: _formValidator,
          onChanged: (value) {
            ref
                .read(myProductNotifierProvider.notifier)
                .updateDescription(value);
          },
        ),
      ],
    );
  }

  Row priceUnitFormField(double price, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // currency
        Expanded(
          child: Text(
            "PHP",
            style: TextStyle(
              color: AppTheme.secondary,
              fontSize: 15,
            ),
          ),
        ),
        // price
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: price.toString(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            style: TextStyle(
              color: AppTheme.secondary,
              fontSize: 15,
            ),
            validator: _formValidator,
            onChanged: (value) {
              ref
                  .read(myProductNotifierProvider.notifier)
                  .updatePrice(double.parse(value));
            },
          ),
        ),
        // per
        Expanded(
          child: Center(
            child: Text(
              "/",
              style: TextStyle(
                color: AppTheme.secondary,
                fontSize: 25,
              ),
            ),
          ),
        ),
        // unit
        Expanded(
          child: TextFormField(
            initialValue: unit,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            style: TextStyle(
              color: AppTheme.secondary,
              fontSize: 15,
            ),
            validator: _formValidator,
            onChanged: (value) {
              ref.read(myProductNotifierProvider.notifier).updateUnit(value);
            },
          ),
        ),
      ],
    );
  }

  TextFormField productNameFormField(String name) {
    return TextFormField(
      initialValue: name,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      style: TextStyle(
        color: AppTheme.primary,
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
      validator: _formValidator,
      onChanged: (value) {
        ref.read(myProductNotifierProvider.notifier).updateName(value);
        print("NNNAAAAMMMEEE: ${ref.watch(myProductNotifierProvider).name}");
      },
    );
  }

  Stack productImageView(Product product, BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          child: _selectedImage != null
              ? Image.file(_selectedImage!)
              : FadeInImage(
                  image: AssetImage("assets/images/placeholder.jpg"),
                  placeholder: AssetImage("assets/images/placeholder.jpg"),
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              _pickImageFromGallery(context);
            },
            child: Icon(
              FeatherIcons.edit,
              color: AppTheme.primary,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future _pickImageFromGallery(BuildContext context) async {
    const MAX_IMAGE_SIZE = 512000;

    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    var imagePath = returnedImage!.path;

    var image = File(imagePath);
    var imageStat = await image.stat();
    var imageSize = imageStat.size;

    if (imageSize > MAX_IMAGE_SIZE) {
      final snackBar =
          SnackBar(content: Text("Image size must not be greater than 500 KB"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  String? convertImageToBase64() {
    if (_selectedImage == null) return null;

    List<int> imageBytes = _selectedImage!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }
}
