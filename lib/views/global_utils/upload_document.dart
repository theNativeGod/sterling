import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sterling/services/services.dart';

import 'global_export.dart';

class UploadDocument extends StatelessWidget {
  UploadDocument({
    required this.tripId,
    super.key,
  });

  var tripId;

  pickImage(String img) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (img == '1') {
      image1 = image;
    } else if (img == '2') {
      image2 = image;
    } else {
      image3 = image;
    }
    return image!.name;
  }

  Services services = Services();
  XFile? image1, image2, image3;

  TextEditingController img1 = TextEditingController();
  TextEditingController img2 = TextEditingController();
  TextEditingController img3 = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CloseButtonWidget(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Upload Document',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Color(0xffe9e9e9),
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ChooseFileWidget(
                      fileName: 'File 1',
                      imageController: img1,
                      pickImage: pickImage,
                    ),
                    const SizedBox(height: 15),
                    ChooseFileWidget(
                      fileName: 'File 2',
                      imageController: img2,
                      pickImage: pickImage,
                    ),
                    const SizedBox(height: 15),
                    ChooseFileWidget(
                      fileName: 'File 3',
                      imageController: img3,
                      pickImage: pickImage,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 100,
              color: const Color(0xfff3f3f3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  ThemeButton(
                    buttonText: 'Upload',
                    width: 100,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        FormData formData = FormData.fromMap({
                          'riderequest_id': tripId,
                          'imageFiles[0]': await MultipartFile.fromFile(
                              image1!.path,
                              filename: image1!.name),
                          'imageFiles[1]': image2 != null
                              ? await MultipartFile.fromFile(image2!.path,
                                  filename: image2!.name)
                              : null,
                          'imageFiles[2]': image3 != null
                              ? await MultipartFile.fromFile(image3!.path,
                                  filename: image3!.name)
                              : null,
                        });
                        var responseData =
                            await services.documentUpload(formData);

                        if (responseData['status'] == true) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              content: Center(
                                child: Text(
                                  responseData['message'],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              content: Center(
                                child: Text(
                                  'Something went wrong',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseFileWidget extends StatelessWidget {
  ChooseFileWidget({
    required this.fileName,
    required this.imageController,
    required this.pickImage,
    super.key,
  });

  final String fileName;
  TextEditingController imageController = TextEditingController();
  var pickImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fileName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: imageController,
          readOnly: true,
          onTap: () async {
            if (fileName == 'File 1') {
              imageController.text = await pickImage('1');
            } else if (fileName == 'File 2') {
              imageController.text = await pickImage('2');
            } else if (fileName == 'File 3') {
              imageController.text = await pickImage('3');
            }
          },
          validator: (value) {
            if (fileName == 'File 1') {
              if (value == null || value.isEmpty) {
                return 'Please upload an image';
              }
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: 'Choose File',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
            suffixIcon: Icon(Icons.upload),
            contentPadding: const EdgeInsets.all(16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
