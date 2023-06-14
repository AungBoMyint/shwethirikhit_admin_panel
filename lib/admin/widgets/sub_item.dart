import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/rbpoint.dart';
import '../controller/admin_ui_controller.dart';

class SubItem extends GetView<AdminUiController> {
  const SubItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return /* Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ */
        ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 12,
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.white,
        child: CircleAvatar(
            radius: 10,
            backgroundColor: isSelected ? Colors.white : Colors.black,
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  isSelected ? Theme.of(context).primaryColor : Colors.white,
            )),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: controller.rbPoint.value!
                  .getOrElse(() => RBPoint.xl())
                  .map(
                      xl: (_) => 19,
                      desktop: (_) => 16,
                      tablet: (_) => 14,
                      mobile: (_) => 12),
              color: isSelected
                  ? Theme.of(context).iconTheme.color
                  : Colors.grey.shade600,
            ),
      ),
    );
    /* RadioListTile<ProductPageType>(
      value: value,
      groupValue: groupValue,
      onChanged: (_) => onPressed!(),
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: controller.rbPoint.value!
                  .getOrElse(() => RBPoint.xl())
                  .map(
                      xl: (_) => 19,
                      desktop: (_) => 16,
                      tablet: (_) => 14,
                      mobile: (_) => 12),
              color: value == groupValue
                  ? Theme.of(context).iconTheme.color
                  : Colors.grey.shade600,
            ),
      ),
    ); */
    /* const SizedBox(
              width: 35,
            ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 18,
                      color: isSelected
                          ? Colors.grey.shade900
                          : Colors.grey.shade600,
                    ),
              ),
            ),
            const SizedBox(), 
          ],
        ),
      ),
    );*/
  }
}
