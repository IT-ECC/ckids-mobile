import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/util/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  // {"name": e.name, "selected": e.selected, "id": e.id, "isJoin": e.isJoin}

  final List<Map<String, dynamic>> items;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final String? label;

  const CustomCheckbox({
    Key? key,
    this.items = const [],
    required this.onChanged,
    this.label,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: widget.items.length,
          padding: EdgeInsets.zero,
          itemBuilder: (ctx, index) {
            final String id = widget.items[index]['id'];
            final String name = widget.items[index]['name'];
            final bool isJoin = widget.items[index]['isJoin'] as bool;
            final bool selected = widget.items[index]['selected'] as bool;

            return CustomCheckboxItem(
              isJoin: isJoin,
              value: selected,
              onChanged: (val) {
                setState(() {
                  widget.onChanged({"name": name, "selected": val ?? false, "id": id});
                });
              },
              name: (isJoin) ? "${name} (already joined)" : "${name}",
            );
          },
        )
      ],
    );
  }
}

class CustomCheckboxItem extends StatelessWidget {
  final bool value;
  final bool isJoin;
  final String name;
  final ValueChanged onChanged;

  const CustomCheckboxItem({
    Key? key,
    required this.name,
    required this.isJoin,
    required this.value,
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
            child: Checkbox(
              value: value,
              onChanged: (isJoin) ? null : onChanged,
              activeColor: AppColors.cadmiumOrange,
            ),
          ),
        ),
        const SizedBox(width: 10,),
        InkWell(
          onTap: (isJoin) ? null : () {
            onChanged((value) ? false : true);
          },
          child: Text(name, style: const TextStyle(color: Colors.black)),
        )
      ],
    );
  }
}

class CustomCheckboxPrivacy extends StatelessWidget {
  final bool value;
  final ValueChanged onChanged;

  const CustomCheckboxPrivacy({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Theme(
            data: ThemeData(unselectedWidgetColor: AppColors.cadmiumOrange),
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.cadmiumOrange,
            ),
          ),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: InkWell(
            onTap: () {
              onChanged((value) ? false : true);
            },
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                  children: [
                    TextSpan(
                        text: 'Terms of Conditions ',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(context, webViewScreen,
                              arguments: {'url': 'https://ckids.eccchurch.app/terms-of-conditions', 'title': 'Terms of Conditions'}),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        )),
                    TextSpan(text: 'and '),
                    TextSpan(
                        text: 'Privacy Policy',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(context, webViewScreen,
                              arguments: {'url': 'https://ckids.eccchurch.app/privacy-policy', 'title': 'Privacy Policy'}),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ))
                  ]),
            ),
          ),
        )
      ],
    );
  }
}