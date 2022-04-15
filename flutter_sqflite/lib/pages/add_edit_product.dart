import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite/models/products_model.dart';
import 'package:flutter_sqflite/pages/home_page.dart';
import 'package:flutter_sqflite/services/db_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({
    Key? key,
    this.model,
    this.isEditMode = false,
  }) : super(key: key);

  final ProductModel? model;
  final bool isEditMode;

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late ProductModel model;
  List<dynamic> categories = [];
  late DBService dbService;
  @override
  void initState() {
    super.initState();
    dbService = DBService();
    model = ProductModel(productName: "", categoryId: -1);

    if (widget.isEditMode) {
      model = widget.model!;
    }
    categories.add({"id": 1, "name": "T-Shirts"});
    categories.add({"id": 2, "name": "Shirts"});
    categories.add({"id": 3, "name": "Jeans"});
    categories.add({"id": 4, "name": "Trousers"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? "Edit Product" : "Add Product"),
      ),
      body: Form(
        key: globalKey,
        child: _formUI(),
      ),
      bottomNavigationBar: SizedBox(
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormHelper.submitButton(
                "Save",
                () {
                  if (validateAndSave()) {
                    print(model.toJson());
                    if (widget.isEditMode) {
                      dbService.updateProduct(model).then((value) {
                        FormHelper.showSimpleAlertDialog(context, "SQFlite",
                            "Data modified Successfully", 'Ok', () {
                          Navigator.pop(context);
                        });
                      });
                    } else {
                      dbService.addProduct(model).then((value) {
                        FormHelper.showSimpleAlertDialog(
                            context, "SQFlite", "Data Added Successfully", 'Ok',
                            () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomePage()));
                        });
                      });
                    }
                  }
                },
                borderRadius: 10,
                btnColor: Colors.green,
                borderColor: Colors.green,
              ),
              FormHelper.submitButton(
                "Cancel",
                () {},
                borderRadius: 10,
                btnColor: Colors.grey,
                borderColor: Colors.grey,
              ),
            ],
          )),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "productName",
              "Product Name",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                model.productName = onSaved.toString().trim();
              },
              initialValue: model.productName,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.text_fields),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: FormHelper.inputFieldWidgetWithLabel(
                    context,
                    "productPrice",
                    "Product Price",
                    "",
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return "* Required";
                      }
                      return null;
                    },
                    (onSaved) {
                      model.price = double.parse(onSaved.trim());
                    },
                    initialValue:
                        model.price != null ? model.price.toString() : "",
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.currency_pound_rounded),
                    borderRadius: 10,
                    contentPadding: 15,
                    fontSize: 14,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    prefixIconPaddingLeft: 10,
                    isNumeric: true,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FormHelper.dropDownWidgetWithLabel(
                    context,
                    "Product Category",
                    "--Select--",
                    model.categoryId,
                    categories,
                    (onChanged) {
                      model.categoryId = int.parse(onChanged);
                    },
                    (onValidate) {},
                    borderRadius: 10,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    hintFontSize: 14,
                    prefixIcon: const Icon(Icons.category),
                    showPrefixIcon: true,
                    prefixIconPaddingLeft: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "productDesc",
              "Product Description",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                model.productDesc = onSaved.toString().trim();
              },
              initialValue: model.productDesc ?? "",
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
              isMultiline: true,
              multilineRows: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            _pickPicker(model.productPic ?? "", (file) {
              setState(() {
                model.productPic = file.path;
              });
            })
          ],
        ),
      ),
    );
  }

  _pickPicker(
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();
    return Column(
      children: [
        fileName != ""
            ? Image.file(
                File(fileName),
                width: 300,
                height: 300,
              )
            : SizedBox(
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      const SizedBox(child: CircularProgressIndicator()),
                  imageUrl: "https://picsum.photos/250?image=9",
                  fit: BoxFit.scaleDown,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 35,
              height: 35,
              child: IconButton(
                  onPressed: () {
                    _imageFile = _picker.pickImage(source: ImageSource.gallery);
                    _imageFile.then((file) async {
                      onFilePicked(file);
                    });
                  },
                  icon: const Icon(Icons.image, size: 35)),
            ),
            SizedBox(
              width: 35,
              height: 35,
              child: IconButton(
                  onPressed: () {
                    _imageFile = _picker.pickImage(source: ImageSource.camera);
                    _imageFile.then((file) async {
                      onFilePicked(file);
                    });
                  },
                  icon: const Icon(Icons.camera, size: 35)),
            )
          ],
        )
      ],
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
