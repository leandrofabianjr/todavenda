import 'package:flutter/material.dart';
import 'package:todavenda/products/products.dart';

class CartListTile extends StatelessWidget {
  const CartListTile({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdded,
    required this.onRemoved,
  });

  final Product product;
  final int quantity;
  final void Function() onAdded;
  final void Function() onRemoved;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: quantity > 0 ? onRemoved : null,
        icon: const Icon(Icons.remove),
        color: Colors.red,
      ),
      trailing: IconButton(
        onPressed: onAdded,
        icon: const Icon(Icons.add),
        color: Colors.green,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(product.description)),
          if (quantity > 0) ...[
            const SizedBox(width: 8),
            Text(quantity.toString())
          ],
        ],
      ),
      subtitle: Text(
        product.formattedPrice,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
