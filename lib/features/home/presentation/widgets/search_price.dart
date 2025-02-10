import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/edit_text_widget.dart';

class SearchPrice extends StatefulWidget {
  const SearchPrice({super.key, required this.result, this.min, this.max});
  final void Function(String? min, String? max) result;
  final double? min;
  final double? max;
  @override
  State<SearchPrice> createState() => _SearchPriceState();
}

class _SearchPriceState extends State<SearchPrice> {
  double _startValue = 0;
  double _endValue = Utils.max_price.toDouble();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startValue = widget.min ?? 0;
    _endValue = widget.max ?? Utils.max_price.toDouble();
    _minController.text = widget.min?.toString() ?? "0";
    _maxController.text = widget.max?.toString() ?? Utils.max_price;
  }

  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          ),
          28.ph,
          Row(
            children: [
              CustomText(
                LocaleKeys.home_keys_price.tr(),
                weight: FontWeight.w700,
                fontSize: 16,
              ),
            ],
          ),
          28.ph,
          Row(
            children: [
              Expanded(
                child: TextFormFieldWidget(
                  controller: _minController,
                  hintText: LocaleKeys.home_keys_minimum_price.tr(),
                  borderRadius: 10,
                  activeBorderColor: LightThemeColors.textHint,
                  type: TextInputType.number,
                ),
              ),
              12.pw,
              Expanded(
                child: TextFormFieldWidget(
                    controller: _maxController,
                    hintText: LocaleKeys.home_keys_maximum_price.tr(),
                    borderRadius: 10,
                    activeBorderColor: LightThemeColors.textHint,
                    type: TextInputType.numberWithOptions()),
              ),
            ],
          ),
          12.ph,
          RangeSlider(
            values: RangeValues(_startValue, _endValue),
            min: 0,
            max: Utils.max_price.toDouble(),
            divisions: 100,
            labels: RangeLabels(
              _startValue.round().toString(),
              _endValue.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _startValue = values.start;
                _endValue = values.end;
                _minController.text = _startValue.round().toString();
                _maxController.text = _endValue.round().toString();
              });
            },
          ),
          12.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _startValue = 0;
                    _minController.text = "0";
                    _endValue = 10000;
                    _maxController.text = "10000";
                  });
                  widget.result(_startValue.round().toString(),
                      _endValue.round().toString());
                  Navigator.pop(context);
                },
                child: CustomText(
                  LocaleKeys.home_keys_clear.tr(),
                  color: Color(0xffFF0000),
                ),
              ),
              ButtonWidget(
                title: LocaleKeys.home_keys_confirm.tr(),
                width: 100,
                radius: 10,
                height: 40,
                onTap: () {
                  _startValue = double.parse(_minController.text);
                  _endValue = double.parse(_maxController.text);
                  widget.result(_startValue.round().toString(),
                      _endValue.round().toString());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          12.ph,
        ],
      ),
    );
  }
}
