import 'package:firstapp/models/fashion.dart';
import 'package:flutter/material.dart';

class CuratedItem extends StatelessWidget {
  final AppModel eCommerceItems;
  final Size size;
  const CuratedItem({
    super.key,
    required this.eCommerceItems,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: eCommerceItems.image,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(eCommerceItems.image),
                fit: BoxFit.cover,
              ),
            ),
            height: size.height * 0.25,
            width: size.width * 0.5,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: Colors.pink),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Text(
              "Digital Mart ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Icon(Icons.star, color: Colors.amber, size: 17),
            Text(
              eCommerceItems.rating.toString(),
              style: const TextStyle(color: Colors.amber),
            ),
            Text(
              "{${eCommerceItems.rewiews}}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(
          width: size.width * 0.5,
          child: Text(
            eCommerceItems.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "₭ ${eCommerceItems.prince.toString()}.00",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 1.5,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            if (eCommerceItems.isCheck == true)
              Text(
                "₭ ${eCommerceItems.prince + 100000}.00",
                style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.red,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
