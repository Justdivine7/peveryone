import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/auth_loader.dart';
import 'package:peveryone/presentation/providers/general_providers/global_providers.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';
import 'package:peveryone/presentation/widgets/app_text_form_field.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';
import 'package:peveryone/presentation/widgets/loading_overlay.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static const routeName = '/edit-profile';
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(profileImageProvider.notifier).state = File(image.path);
      debugPrint(image.path);
      debugPrint('image picked');
      debugPrint(ref.read(profileImageProvider.notifier).state.toString());
    } else {
      debugPrint('image not found');
    }
  }

  void saveDetails({required File? profileImage}) async {
    final user = ref.read(appUserProvider).value;
    if (user == null) return;
    final loadingState = ref.read(AuthLoader.updatingProfileProvider.notifier);
    loadingState.state = true;
    final profileRepo = ref.read(userProfileProvider);
    String? photoUrl;

    if (profileImage != null) {
      photoUrl = await profileRepo.uploadProfilePhoto(profileImage, user.uid);
    }

    await profileRepo.updateUserProfile(
      uid: user.uid,
      firstName:
          _firstNameController.text.trim().isEmpty
              ? null
              : _firstNameController.text.trim(),
      lastName:
          _lastNameController.text.trim().isEmpty
              ? null
              : _lastNameController.text.trim(),

      photoUrl: photoUrl,
    );
    loadingState.state = false;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserProvider).value;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(appUserProvider);
    final profileImage = ref.watch(profileImageProvider);
final isLoading = ref.watch(AuthLoader.updatingProfileProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'), centerTitle: true),
        body: LoadingOverlay(
          isLoading: isLoading,
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: appUser.when(
              data:
                  (user) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height(context, 0.01)),

                      GestureDetector(
                        onTap: pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  profileImage != null
                                      ? FileImage(profileImage)
                                      : (user!.photoUrl != null &&
                                                  user.photoUrl!.isNotEmpty
                                              ? CachedNetworkImageProvider(
                                                user.photoUrl!,
                                              )
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
                            hintText: '',
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
                            hintText: '',
                          ),
                          SizedBox(height: height(context, 0.03)),
                          AppBigButton(
                            label: 'Save',
                            onPressed: () async {
                              saveDetails(profileImage: profileImage);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
              error:
                  (e, stackTrace) => ErrorScreen(error: 'Something went wrong'),
              loading:
                  () => Center(
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
