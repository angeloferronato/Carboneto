import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/authentication/controllers/position_selector/position_selector_controller.dart';
import 'package:carboneto/features/authentication/controllers/signup/signup_controller.dart';
import 'package:carboneto/features/authentication/screens/signup/widgets/position_selector.dart';
import 'package:carboneto/features/personalization/controllers/edit_profile/edit_profile_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/widgets/country_selector.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:carboneto/utils/validators/validation.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    final editProfileController = Get.put(EditProfileController());
    editProfileController.nameController.text = UserController.instance.user.value.name;
    editProfileController.descriptionController.text = UserController.instance.user.value.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = screenWidth * 0.21;
    final userController = Get.put(UserController());
    final positionSelectorController = Get.put(PositionSelectorController());
    final editProfileController = Get.put(EditProfileController());
    positionSelectorController.dropDownValue = userController.user.value.position;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Editar Perfil",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: CbSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CbColors.primary,
                  ),
                  child: Obx(
                    () => !userController.profileLoading.value ? (userController.user.value.profilePicture != '' ? CbRoundedImage(imageUrl: userController.user.value.profilePicture, isNetworkImage: true, borderRadius: avatarRadius, width: 180, height: 180,) : CbRoundedImage(imageUrl: CbImages.userDefault, borderRadius: avatarRadius, width: 180,)) : CbShimmerEffects(width: 180, height: 180, radius: avatarRadius,),
                  ),
                ),
              ),
              Form(
                key: editProfileController.editProfileFormKey,
                child: Column(
                  spacing: 20,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Nome',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Obx(
                          () {
                            if (userController.profileLoading.value) {
                              return CbShimmerEffects(width: 200, height: 60);
                              
                            } else {
                              return FocusedTextField(
                                controller: editProfileController.nameController,
                                validator: (value) => CbValidator.validateEmptyText('Nome', value),
                                hintText: 'Nome',
                                paddingH: 20,
                              );
                            }
                          }  
                           
                          
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Descrição',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Obx(
                          () {
                            if (userController.profileLoading.value ) {
                              return CbShimmerEffects(width: double.infinity, height: 60);
                            } else {
                              return FocusedTextField(
                                controller: editProfileController.descriptionController,
                                hintText: 'Descrição',
                                maxLines: 2,
                                paddingH: 20,
                              );
                            }
                          } 
                         
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Posição Favorita',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        PositionSelector(width: double.infinity,),
                      ],
                    ),
                    CbCountrySelector(),
                    SizedBox(),
                    ElevatedButton(
                      onPressed: () => editProfileController.updateUserDetails(),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      child: Text(
                        'Salvar Alterações',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

