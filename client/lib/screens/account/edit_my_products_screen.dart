import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:terratreats/models/product_model.dart';
import 'package:terratreats/services/category_service.dart';
import 'package:terratreats/services/selected_product_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/appbar.dart';

class EditMyProducts extends ConsumerStatefulWidget {
  const EditMyProducts({super.key});

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
          future: getSelectedProduct(11),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final product = snapshot.data!;

            final productNameController =
                TextEditingController(text: product.name);
            final priceController =
                TextEditingController(text: product.price.toString());
            final unitController = TextEditingController(text: product.unit);
            final descriptionController =
                TextEditingController(text: product.description);
            final stockController =
                TextEditingController(text: product.stock.toString());
            final shippingFeeController =
                TextEditingController(text: product.shippingFee.toString());

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
                          productNameFormField(productNameController),
                          const SizedBox(
                            height: 8,
                          ),
                          priceUnitFormField(priceController, unitController),
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
                          descriptionFormField(descriptionController),
                          const SizedBox(
                            height: 16,
                          ),
                          stockFormField(stockController),
                          const SizedBox(
                            height: 16,
                          ),
                          shippingFeeFormField(shippingFeeController),
                          const SizedBox(
                            height: 16,
                          ),
                          categoryFormField(product),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              saveButton(),
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
              value: _selectedCategory ??= product.category,
              items: categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.cardTitle,
                      child: Text(category.cardTitle),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
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

  OutlinedButton saveButton() {
    return OutlinedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
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

  Column shippingFeeFormField(TextEditingController shippingFeeController) {
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
          controller: shippingFeeController,
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
        ),
      ],
    );
  }

  Column stockFormField(TextEditingController stockController) {
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
          controller: stockController,
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
        ),
      ],
    );
  }

  Column descriptionFormField(TextEditingController descriptionController) {
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
          controller: descriptionController,
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
        ),
      ],
    );
  }

  Row priceUnitFormField(TextEditingController priceController,
      TextEditingController unitController) {
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
            controller: priceController,
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
            controller: unitController,
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
          ),
        ),
      ],
    );
  }

  TextFormField productNameFormField(
      TextEditingController _productNameController) {
    return TextFormField(
      controller: _productNameController,
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
}
