import 'package:easy_localization/easy_localization.dart';
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
          title: Text('ad_validation.result_title'.tr()),
        ),
        body: Center(
          child: Text('ad_validation.no_data'.tr()),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ad_validation.result_title'.tr()),
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
                    'ad_validation.active_status'.tr(),
                    style: context.headlineSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'ad_validation.license_status'.tr(),
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
                      _buildDetailRow('ad_validation.license_number'.tr(), advertisement!.adLicenseNumber),
                      _buildDetailRow('ad_validation.license_holder'.tr(), advertisement!.advertiserName),
                      _buildDetailRow('ad_validation.creation_date'.tr(), advertisement!.creationDate),
                      _buildDetailRow('ad_validation.end_date'.tr(), advertisement!.endDate),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDetailCard(
                    context,
                    title: 'ad_validation.property_details'.tr(),
                    children: [
                      _buildDetailRow('ad_validation.property_type'.tr(), advertisement!.propertyType),
                      _buildDetailRow('ad_validation.ad_type'.tr(), advertisement!.advertisementType),
                      _buildDetailRow('ad_validation.property_area'.tr(), '${advertisement!.propertyArea} ${'ad_validation.square_meter'.tr()}'),
                      _buildDetailRow('ad_validation.price_per_meter'.tr(), '${advertisement!.propertyPrice} ${'ad_validation.riyal'.tr()}'),
                      _buildDetailRow('ad_validation.total_price'.tr(), '${advertisement!.landTotalPrice} ${'ad_validation.riyal'.tr()}'),
                      _buildDetailRow('ad_validation.direction'.tr(), advertisement!.propertyFace),
                      _buildDetailRow('ad_validation.street_width'.tr(), '${advertisement!.streetWidth} ${'ad_validation.meter'.tr()}'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDetailCard(
                    context,
                    title: 'ad_validation.location'.tr(),
                    children: [
                      _buildDetailRow('ad_validation.region'.tr(), advertisement!.location?.region),
                      _buildDetailRow('ad_validation.city'.tr(), advertisement!.location?.city),
                      _buildDetailRow('ad_validation.district'.tr(), advertisement!.location?.district),
                      _buildDetailRow('ad_validation.building_number'.tr(), advertisement!.location?.buildingNumber),
                      _buildDetailRow('ad_validation.postal_code'.tr(), advertisement!.location?.postalCode),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDetailCard(
                    context,
                    title: 'ad_validation.deed_info'.tr(),
                    children: [
                      _buildDetailRow('ad_validation.deed_number'.tr(), advertisement!.deedNumber),
                      _buildDetailRow('ad_validation.deed_type'.tr(), advertisement!.titleDeedTypeName),
                      _buildDetailRow('ad_validation.plan_number'.tr(), advertisement!.planNumber),
                      _buildDetailRow('ad_validation.land_number'.tr(), advertisement!.landNumber),
                    ],
                  ),
                  if (advertisement!.borders != null) ...[
                    const SizedBox(height: 15),
                    _buildDetailCard(
                      context,
                      title: 'ad_validation.borders'.tr(),
                      children: [
                        _buildDetailRow(
                          'ad_validation.north_border'.tr(),
                          '${advertisement!.borders?.northLimitName ?? ''} ${advertisement!.borders?.northLimitDescription ?? ''} (${advertisement!.borders?.northLimitLengthChar ?? ''})',
                        ),
                        _buildDetailRow(
                          'ad_validation.south_border'.tr(),
                          '${advertisement!.borders?.southLimitName ?? ''} ${advertisement!.borders?.southLimitDescription ?? ''} (${advertisement!.borders?.southLimitLengthChar ?? ''})',
                        ),
                        _buildDetailRow(
                          'ad_validation.east_border'.tr(),
                          '${advertisement!.borders?.eastLimitName ?? ''} ${advertisement!.borders?.eastLimitDescription ?? ''} (${advertisement!.borders?.eastLimitLengthChar ?? ''})',
                        ),
                        _buildDetailRow(
                          'ad_validation.west_border'.tr(),
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
                      title: 'ad_validation.utilities'.tr(),
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
                    title: 'ad_validation.back_button'.tr(),
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


