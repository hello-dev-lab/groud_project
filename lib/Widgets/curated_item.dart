import 'package:firstapp/api/api_path.dart';
import 'package:firstapp/models/product_model.dart';
import 'package:flutter/material.dart';

class CuratedItem extends StatelessWidget {
  final Products eCommerceItems;
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
          tag: eCommerceItems.id.toString(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(
                  ApiPath.Image + (eCommerceItems.imageUrl.toString()),
                ),
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

        SizedBox(
          width: size.width * 0.5,
          child: Text(
            eCommerceItems.name.toString(),
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
        SizedBox(
          width: size.width * 0.5,
          child: Text(
            eCommerceItems.description.toString(),
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
              "₭ ${eCommerceItems.price.toString()}00",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 1.5,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text("₭${eCommerceItems.originalPrice.toString()}.000", style: TextStyle(color: Colors.white),),
          ],
        ),
      ],
    );
  }
}
