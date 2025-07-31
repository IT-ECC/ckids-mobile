import 'package:eccmobile/component/app_colors.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final List<Widget> items;
  final int value;
  final ValueChanged<int> onChanged;
  final String label;
  final bool isPopupStyle;

  const CustomRadioButton({
    Key? key,
    this.items = const [],
    this.value = 0,
    required this.onChanged,
    required this.label,
    this.isPopupStyle = false
  }) : super(key: key);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  late int selectedValue;

  @override
  void initState() {
    selectedValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isPopupStyle) ? buildPopupStyle() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.label,
        //   style: const TextStyle(
        //     fontWeight: FontWeight.w300,
        //     color: Colors.black,
        //   ),
        // ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: widget.items.length,
          padding: EdgeInsets.zero,
          itemBuilder: (ctx, index) => CustomRadioItem(
            value: index,
            onChanged: (val) {
              setState(() {
                selectedValue = val;
                widget.onChanged(selectedValue);
              });
            },
            groupValue: selectedValue,
            item: widget.items[index],
          ),
        )
      ],
    );
  }

  Widget buildPopupStyle() {
    return (widget.items.isEmpty) ? const Text('Data Tidak Ditemukan', textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black)) : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.items.map((e) {
        return Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black26))
          ),
          padding: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: e,
                    onTap: () {
                      setState(() {
                        selectedValue = widget.items.indexWhere((element) => element == e);
                        widget.onChanged(selectedValue);
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.black,
                    ),
                    child: Radio(
                      value: widget.items.indexWhere((element) => element == e),
                      groupValue: selectedValue,
                      onChanged: (val) {
                        setState(() {
                          selectedValue = val as int;
                          widget.onChanged(selectedValue);
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomRadioItem extends StatelessWidget {
  final int value;
  final Widget item;
  final int groupValue;
  final ValueChanged onChanged;

  const CustomRadioItem({
    Key? key,
    required this.item,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Theme(
            data: ThemeData(unselectedWidgetColor: AppColors.cadmiumOrange),
            child: Radio(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.cadmiumOrange,
            ),
          ),
        ),
        const SizedBox(width: 10,),
        item,
      ],
    );
  }
}
