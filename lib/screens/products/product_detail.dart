import 'package:flutter/material.dart';
import 'package:adminpanelapp/screens/cart/cart_view.dart';
import 'package:adminpanelapp/list.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetail extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Details",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            // Cart Badge
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  ).then((_) {
                    setState(() {}); // refresh badge after returning
                  });
                },
                child: badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -10, end: -12),
                  badgeContent: Text(
                    selectedItems.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Product Image
            ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              widget.product['productImage'],
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 250,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  alignment: Alignment.center,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image,
                      size: 80, color: Colors.grey),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Product Name
          Text(
            widget.product['productName'] ?? '',
            style:
            const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // Product Price
          Text(
            "Ghc${widget.product['productPrice'] ?? ''}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 20),

          // Description Header
          const Text(
            "Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),
                  // Product Description
                  Text(
                    widget.product['productDescription'] ??
                        'No description available',
                    style: const TextStyle(
                        fontSize: 16, color: Colors.grey, height: 1.4),
                  ),
                ],
            ),
          ),
        ),

      // Add to Cart Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            int index = selectedItems.indexWhere(
                  (item) => item['productName'] == widget.product['productName'],
            );

            setState(() {
              if (index != -1) {
                // Already in cart → increase quantity
                selectedItems[index]['quantity']++;
              } else {
                // Add new product
                selectedItems.add({
                  'productName': widget.product['productName'],
                  'productPrice': widget.product['productPrice'],
                  'productImage': widget.product['productImage'],
                  'quantity': 1,
                });
              }
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Added to Cart"),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: const Text(
            "Add to Cart",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}