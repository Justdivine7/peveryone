import 'dart:io';

 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/global_providers.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_form_field.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static const routeName = '/edit-profile';
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  File? _profileImage;


void pickImage()async{
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if(image != null){
    ref.read(profileImageProvider.notifier).state = File(image.path);
  }
}
  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserProvider).value;
    if (user != null) {
      _emailController.text = user.email;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(appUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: appUser.when(
            data:
                (user) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height(context, 0.01)),

                    GestureDetector(
                      onTap: pickImage
                     
                      ,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : (user!.photoUrl != null &&
                                                user.photoUrl!.isNotEmpty
                                            ? NetworkImage(user.photoUrl!)
                                            : const AssetImage(
                                              'assets/images/dummy.png',
                                            ))
                                        as ImageProvider,
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).hoverColor,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height(context, 0.01)),

                    Text(
                      '${user!.firstName.capitalize()} ${user.lastName.capitalize()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(user.email.capitalize()),
                    SizedBox(height: height(context, 0.03)),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        SizedBox(height: height(context, 0.015)),

                        AppTextFormField(
                          obscure: false,
                          hintText: user.email,
                          textController: _emailController,
                        ),

                        SizedBox(height: height(context, 0.015)),
                        Text(
                          'First Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        SizedBox(height: height(context, 0.015)),

                        AppTextFormField(
                          obscure: false,
                          textController: _firstNameController,
                          hintText: user.firstName,
                        ),
                        SizedBox(height: height(context, 0.015)),
                        Text(
                          'Last Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        SizedBox(height: height(context, 0.015)),
                        AppTextFormField(
                          obscure: false,
                          textController: _lastNameController,
                          hintText: user.lastName,
                        ),
                        SizedBox(height: height(context, 0.03)),
                        AppBigButton(label: 'Save'),
                      ],
                    ),
                  ],
                ),
            error:
                (e, stackTrace) => ErrorScreen(error: 'Something went wrong'),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
