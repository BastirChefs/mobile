import 'package:bastirchef/pages/search_output.dart';
import 'package:flutter/material.dart';

import 'drop_down.dart';

class DropDownTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String? title;
  final String hint;
  final Map<int, String> options;
  final String buttonText;
  final List<int>? selectedOptions;
  final Function(List<int>?)? onChanged;
  final bool multiple;

  //optional parameters
  final InputDecoration? decoration;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final int? maxLines;
  final int? minLines;

  /// [isSearchVisible] flag use to manage the search widget visibility
  /// by default it is [True] so widget will be visible.
  final bool isSearchVisible;

  const DropDownTextField({
    required this.textEditingController,
    this.title,
    required this.hint,
    required this.options,
    required this.buttonText,
    this.selectedOptions,
    this.onChanged,
    this.multiple = false,
    Key? key,

    /// optional parameters
    this.decoration,
    this.textCapitalization,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign,
    this.textAlignVertical,
    this.maxLines,
    this.minLines,
    this.isSearchVisible = true,
  }) : super(key: key);

  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  // final TextEditingController _searchTextEditingController = TextEditingController();

  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          widget.title ?? '',
          style: widget.style ??
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
        ),
        submitButtonChild: Text(
          widget.buttonText,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD75912)),
        ),
        options: widget.options,
        buttonText: widget.buttonText,
        selectedOptions: widget.selectedOptions,
        selectedItems: (List<dynamic> selectedList) {
          widget.textEditingController.text =
              tmpImplode(widget.options, selectedList);
          widget.onChanged?.call(List<int>.from(selectedList));
        },
        enableMultipleSelection: widget.multiple,
        isSearchVisible: widget.isSearchVisible,
        onSearch: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchOutput(),
            ),
          );
        },
      ),
    ).showModal(context);
  }

  @override
  void initState() {
    if (!['', null, false, 0].contains(widget.selectedOptions)) {
      widget.textEditingController.text =
          tmpImplode(widget.options, widget.selectedOptions!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.none,
          showCursor: false,
          readOnly: true,
          onTap: () {
            FocusScope.of(context).unfocus();
            onTextFieldTap();
          },
          // Optional
          decoration: widget.decoration ??
              InputDecoration(
                // filled: true,
                labelText: widget.title,
                hintText: widget.hint,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    style: ['', null].contains(widget.title)
                        ? BorderStyle.none
                        : BorderStyle.solid,
                  ),
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(), // add padding to adjust icon
                  child: Icon(Icons.search, color: Color(0xFFD75912), size: 40),
                ),
              ),

          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          textInputAction: widget.textInputAction,
          style: widget.style,
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign ?? TextAlign.start,
          textAlignVertical: widget.textAlignVertical,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines,
        ),
      ],
    );
  }

  // Comma separated values of options
  String tmpImplode(Map<int, String> options, List<dynamic> tmpSelectedList) {
    Map<int, String> tmpOptions = Map<int, String>.from(options);

    tmpOptions.removeWhere((id, value) => !tmpSelectedList.contains(id));
    return tmpOptions.values.join(',');
  }
}
