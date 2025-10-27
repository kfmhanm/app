import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/shared/widgets/button_widget.dart';

import '../../domain/model/ad_validation_model.dart';

class AdValidationResultScreen extends StatelessWidget {
  final Advertisement? advertisement;

  const AdValidationResultScreen({super.key, this.advertisement});

  @override
  Widget build(BuildContext context) {
    if (advertisement == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('نتيجة التحقق'),
        ),
        body: const Center(
          child: Text('لا توجد بيانات'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة التحقق'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Success Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.green.shade200, width: 2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 60,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'نشط',
                    style: context.headlineSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'حالة الترخيص',
                    style: context.bodyMedium?.copyWith(
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Table
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailCard(
                    context,
                    children: [
                      _buildDetailRow('رقم الترخيص', advertisement!.adLicenseNumber),
                      _buildDetailRow('معتمد عقد الوساطة', advertisement!.advertiserName),
                      _buildDetailRow('تاريخ إصدار الترخيص', advertisement!.creationDate),
                      _buildDetailRow('تاريخ انتهاء الترخيص', advertisement!.endDate),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDetailCard(
                    context,
                    title: 'تفاصيل العقار',
                    children: [
                      _buildDetailRow('نوع العقار', advertisement!.propertyType),
                      _buildDetailRow('نوع الإعلان', advertisement!.advertisementType),
                      _buildDetailRow('مساحة العقار', '${advertisement!.propertyArea} م²'),
                      _buildDetailRow('سعر المتر', '${advertisement!.propertyPrice} ريال'),
                      _buildDetailRow('السعر الإجمالي', '${advertisement!.landTotalPrice} ريال'),
                      _buildDetailRow('الاتجاه', advertisement!.propertyFace),
                      _buildDetailRow('عرض الشارع', '${advertisement!.streetWidth} م'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDetailCard(
                    context,
                    title: 'الموقع',
                    children: [
                      _buildDetailRow('المنطقة', advertisement!.location?.region),
                      _buildDetailRow('المدينة', advertisement!.location?.city),
                      _buildDetailRow('الحي', advertisement!.location?.district),
                      _buildDetailRow('رقم المبنى', advertisement!.location?.buildingNumber),
                      _buildDetailRow('الرمز البريدي', advertisement!.location?.postalCode),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDetailCard(
                    context,
                    title: 'معلومات الصك',
                    children: [
                      _buildDetailRow('رقم الصك', advertisement!.deedNumber),
                      _buildDetailRow('نوع الصك', advertisement!.titleDeedTypeName),
                      _buildDetailRow('رقم المخطط', advertisement!.planNumber),
                      _buildDetailRow('رقم القطعة', advertisement!.landNumber),
                    ],
                  ),
                  if (advertisement!.borders != null) ...[
                    const SizedBox(height: 15),
                    _buildDetailCard(
                      context,
                      title: 'الحدود',
                      children: [
                        _buildDetailRow(
                          'الحد الشمالي',
                          '${advertisement!.borders?.northLimitName ?? ''} ${advertisement!.borders?.northLimitDescription ?? ''} (${advertisement!.borders?.northLimitLengthChar ?? ''})',
                        ),
                        _buildDetailRow(
                          'الحد الجنوبي',
                          '${advertisement!.borders?.southLimitName ?? ''} ${advertisement!.borders?.southLimitDescription ?? ''} (${advertisement!.borders?.southLimitLengthChar ?? ''})',
                        ),
                        _buildDetailRow(
                          'الحد الشرقي',
                          '${advertisement!.borders?.eastLimitName ?? ''} ${advertisement!.borders?.eastLimitDescription ?? ''} (${advertisement!.borders?.eastLimitLengthChar ?? ''})',
                        ),
                        _buildDetailRow(
                          'الحد الغربي',
                          '${advertisement!.borders?.westLimitName ?? ''} ${advertisement!.borders?.westLimitDescription ?? ''} (${advertisement!.borders?.westLimitLengthChar ?? ''})',
                        ),
                      ],
                    ),
                  ],
                  if (advertisement!.propertyUtilities != null &&
                      advertisement!.propertyUtilities!.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    _buildDetailCard(
                      context,
                      title: 'المرافق',
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: advertisement!.propertyUtilities!
                                .map((utility) => Chip(
                                      label: Text(utility),
                                      backgroundColor: context.primaryColor.withOpacity(0.1),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 30),
                  ButtonWidget(
                    title: 'رجوع',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                title,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

