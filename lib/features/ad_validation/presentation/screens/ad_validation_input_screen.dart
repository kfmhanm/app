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
        idType: 2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdValidationCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التحقق من الإعلان'),
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
                      'التحقق من ترخيص الإعلان',
                      style: context.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'أدخل رقم ترخيص ورقم الهوية للتحقق',
                      style: context.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Ad License Number Field
                    TextFormFieldWidget(
                      controller: adLicenseController,
                      label: 'رقم الترخيص الإعلاني',
                      hintText: 'أدخل رقم الترخيص الإعلاني',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Advertiser ID Field
                    TextFormFieldWidget(
                      controller: advertiserIdController,
                      label: 'رقم الهوية / السجل التجاري',
                      hintText: 'أدخل رقم الهوية / السجل التجاري',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    // Check Button
                    ButtonWidget(
                      title: state is AdValidationLoading ? 'جاري التحقق...' : 'التحقق',
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

