import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:gis_disaster_flutter/base/base_mixin.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker(
      {super.key,
      required this.onChange,
      this.initDate,
      required this.title,
      this.marginTop = 10,
      this.minimumDate});

  final Function(String date) onChange;
  final String? initDate;
  final String? title;
  final double marginTop;
  final DateTime? minimumDate;
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with BaseMixin {
  String initDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String dateChanged = '';
  DateTime _initDateTime = DateTime.now();

  @override
  void initState() {
    dateChanged = widget.initDate ?? initDate;
    _handleInitDate();
    super.initState();
  }

  void _handleInitDate() {
    if (widget.initDate != null) {
      initDate = widget.initDate!;
      _initDateTime = DateFormat('dd/MM/yyyy').parse(initDate);
    }
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initDate != widget.initDate) {
      initDate = widget.initDate ?? initDate;
      if (initDate.isNotEmpty) {
        _initDateTime = DateFormat('dd/MM/yyyy').parse(initDate);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.marginTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(widget.title ?? '',
                    style: textStyle.semiBold(size: 12)),
              ),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _showPicker,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: Get.width,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: color.white,
                  border: Border.all(color: color.greyTextColor, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(initDate,
                      style: textStyle.semiBold(color: color.black, size: 14)),
                  Center(
                    child: Icon(Icons.keyboard_arrow_down_outlined,
                        size: 28, color: color.greyTextColor),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onDone,
                child: Container(
                  height: 50,
                  width: Get.width,
                  color: Colors.grey.shade200,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Chọn',
                      style:
                          textStyle.semiBold(color: color.mainColor, size: 14)),
                ),
              ),
              Container(
                height: Get.height * 0.3,
                color: color.white,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: (value) {
                    dateChanged = DateFormat('dd/MM/yyyy').format(value);
                  },
                  initialDateTime: _initDateTime,
                  minimumYear: 2010,
                  minimumDate: widget.minimumDate ?? DateTime(2010, 1, 1),
                  maximumYear: DateTime.now().year.toInt(),
                ),
              ),
            ],
          );
        });
  }

  void _onDone() {
    Get.back();
    widget.onChange(dateChanged);
  }
}
