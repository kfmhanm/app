import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/shared/widgets/button_widget.dart';
import 'package:pride/shared/widgets/edit_text_widget.dart';

import '../../cubit/ad_validation_cubit.dart';
import '../../cubit/ad_validation_states.dart';
import 'ad_validation_result_screen.dart';
import 'ad_validation_error_screen.dart';

class AdValidationInputScreen extends StatefulWidget {
  const AdValidationInputScreen({super.key});

  @override
  State<AdValidationInputScreen> createState() =>
      _AdValidationInputScreenState();
}

class _AdValidationInputScreenState extends State<AdValidationInputScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController adLicenseController = TextEditingController();
  final TextEditingController advertiserIdController = TextEditingController();
  
  // ID Type: 1 = رقم الهوية, 2 = الرقم الموحد
  int selectedIdType = 2;

  @override
  void dispose() {
    adLicenseController.dispose();
    advertiserIdController.dispose();
    super.dispose();
  }

  void _validateAd(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final cubit = context.read<AdValidationCubit>();
      cubit.validateAd(
        adLicenseNumber: adLicenseController.text.trim(),
        advertiserId: advertiserIdController.text.trim(),
        idType: selectedIdType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdValidationCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ad_validation.title'.tr()),
          centerTitle: true,
        ),
        body: BlocConsumer<AdValidationCubit, AdValidationStates>(
          listener: (context, state) {
            final cubit = context.read<AdValidationCubit>();
            
            if (state is AdValidationSuccess) {
              // Store the data before navigation
              final advertisement = cubit.validationResponse?.body?.result?.advertisement;
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdValidationResultScreen(
                    advertisement: advertisement,
                  ),
                ),
              );
            } else if (state is AdValidationFailed) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdValidationErrorScreen(
                    errorMessage: state.errorMessage,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Logo or Icon
                    Icon(
                      Icons.verified_outlined,
                      size: 80,
                      color: context.primaryColor,
                    ),
                    const SizedBox(height: 30),
                    // Title
                    Text(
                      'ad_validation.page_title'.tr(),
                      style: context.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'ad_validation.page_subtitle'.tr(),
                      style: context.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Ad License Number Field
                    TextFormFieldWidget(
                      controller: adLicenseController,
                      label: 'ad_validation.ad_license_label'.tr(),
                      hintText: 'ad_validation.ad_license_hint'.tr(),
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ad_validation.required_field'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // ID Type Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ad_validation.id_type_label'.tr(),
                          style: context.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<int>(
                                value: 1,
                                groupValue: selectedIdType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedIdType = value!;
                                  });
                                },
                                title: Text(
                                  'ad_validation.national_id'.tr(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                activeColor: context.primaryColor,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<int>(
                                value: 2,
                                groupValue: selectedIdType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedIdType = value!;
                                  });
                                },
                                title: Text(
                                  'ad_validation.unified_number'.tr(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                contentPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                activeColor: context.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Advertiser ID Field
                    TextFormFieldWidget(
                      controller: advertiserIdController,
                      label: selectedIdType == 1
                          ? 'ad_validation.national_id'.tr()
                          : 'ad_validation.unified_number'.tr(),
                      hintText: selectedIdType == 1
                          ? 'أدخل ${'ad_validation.national_id'.tr()}'
                          : 'أدخل ${'ad_validation.unified_number'.tr()}',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ad_validation.required_field'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    // Check Button
                    ButtonWidget(
                      title: state is AdValidationLoading
                          ? 'ad_validation.verifying'.tr()
                          : 'ad_validation.verify_button'.tr(),
                      onTap: state is AdValidationLoading
                          ? null
                          : () => _validateAd(context),
                      height: 55,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

