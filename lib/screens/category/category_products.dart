import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adminpanelapp/screens/products/product_detail.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final CollectionReference products =
    FirebaseFirestore.instance.collection('products');

    final Stream<QuerySnapshot> stream = (category == "All")
        ? products.snapshots()
        : products.where('category', isEqualTo: category).snapshots();

    // Determine number of columns based on screen width
    int crossAxisCount = MediaQuery.of(context).size.width > 1000
        ? 4
        : MediaQuery.of(context).size.width > 600
        ? 3
        : 2;

    double childAspectRatio = MediaQuery.of(context).size.width > 1000
        ? 0.65
        : MediaQuery.of(context).size.width > 600
        ? 0.7
        : 0.7;

    return Scaffold(
        appBar: AppBar(
          title: Text(category == "All" ? "All Products" : "$category Products"),
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading products"));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No products found"));
              }

              return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data!.docs[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetail(
                              product: item.data() as Map<String, dynamic>,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                          ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        item['productImage'] ?? '',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(
                            child: Icon(Icons.image_not_supported, size: 50)),
                      ),
                    ),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['productName'] ?? "Unnamed Product",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Ghc${item['productPrice']}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                              ],
                          ),
                      ),
                    );
                  },
              );
            },
        ),
    );
  }
}