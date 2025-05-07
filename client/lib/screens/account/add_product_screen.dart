import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:terratreats/services/category_service.dart';
import 'package:terratreats/services/seller/my_products_service.dart';
import 'package:terratreats/utils/app_theme.dart';

import 'package:terratreats/widgets/appbar.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  File? _selectedImage;
  String? _defaultCategory;

  final _formKey = GlobalKey<FormState>();

  String? _formValidator(String? value) {
    if (value!.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.customAppBar(
          title: ref.watch(_formChangeNotifierProvider).productName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productImageView(context),
            Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productNameFormField(),
                    const SizedBox(
                      height: 8,
                    ),
                    priceUnitFormField(),
                    const SizedBox(
                      height: 8,
                    ),
                    descriptionFormField(),
                    const SizedBox(
                      height: 8,
                    ),
                    stockFormField(),
                    const SizedBox(
                      height: 8,
                    ),
                    shippingFeeFormField(),
                    const SizedBox(
                      height: 8,
                    ),
                    categoryFormField(),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        saveButton(context),
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
      ),
    );
  }

  Stack productImageView(BuildContext context) {
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
    const MAX_IMAGE_SIZE = 2097152;

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

  TextFormField productNameFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Name",
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
        ref.read(_formChangeNotifierProvider.notifier).updateProductName(value);
      },
    );
  }

  Row priceUnitFormField() {
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
            decoration: InputDecoration(
              labelText: "Price",
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
                  .read(_formChangeNotifierProvider.notifier)
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
            decoration: InputDecoration(
              labelText: "Unit",
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
              ref.read(_formChangeNotifierProvider.notifier).updateUnit(value);
            },
          ),
        ),
      ],
    );
  }

  Column descriptionFormField() {
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
                .read(_formChangeNotifierProvider.notifier)
                .updateDescription(value);
          },
        ),
      ],
    );
  }

  Column stockFormField() {
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
                .read(_formChangeNotifierProvider.notifier)
                .updateStock(int.parse(value));
          },
        ),
      ],
    );
  }

  Column shippingFeeFormField() {
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
                .read(_formChangeNotifierProvider.notifier)
                .updateShippingFee(double.parse(value));
          },
        ),
      ],
    );
  }

  Row categoryFormField() {
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
            _defaultCategory = categories[0].cardTitle;
            return DropdownButton(
              style: TextStyle(
                color: AppTheme.secondary,
              ),
              value: ref.watch(_formChangeNotifierProvider).category.isEmpty
                  ? _defaultCategory
                  : ref.watch(_formChangeNotifierProvider).category,
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
                    .read(_formChangeNotifierProvider.notifier)
                    .updateCategory(value.toString());
              },
            );
          },
        )
      ],
    );
  }

  OutlinedButton saveButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }

        if (_selectedImage == null) {
          final snackBar = SnackBar(content: Text("Please choose an image"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        final watcher = ref.watch(_formChangeNotifierProvider);

        await addMyProduct(
          productName: watcher.productName,
          price: watcher.price,
          unit: watcher.unit,
          image: convertImageToBase64()!,
          description: watcher.description,
          stock: watcher.stock,
          shippingFee: watcher.shippingFee,
          category:
              watcher.category.isEmpty ? _defaultCategory! : watcher.category,
        );

        final snackBar = SnackBar(content: Text("Successfully added product"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context);
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
}

class _FormChangeNotifier extends ChangeNotifier {
  String productName = "";
  double price = 0;
  String unit = "";
  String description = "";
  int stock = 0;
  double shippingFee = 0;
  String category = "";

  void updateProductName(String p) {
    productName = p;
    notifyListeners();
  }

  void updatePrice(double p) {
    price = p;
    notifyListeners();
  }

  void updateUnit(String u) {
    unit = u;
    notifyListeners();
  }

  void updateDescription(String d) {
    description = d;
    notifyListeners();
  }

  void updateStock(int s) {
    stock = s;
    notifyListeners();
  }

  void updateShippingFee(double sf) {
    shippingFee = sf;
    notifyListeners();
  }

  void updateCategory(String c) {
    category = c;
    notifyListeners();
  }
}

final _formChangeNotifierProvider =
    ChangeNotifierProvider((ref) => _FormChangeNotifier());
