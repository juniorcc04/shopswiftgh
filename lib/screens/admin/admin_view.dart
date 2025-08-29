// ignore_for_file: use_build_context_synchronously
import 'package:adminpanelapp/components/button/button.dart';
import 'package:adminpanelapp/components/loginField/loginfield.dart';
import 'package:adminpanelapp/screens/login/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController productName = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productDescription = TextEditingController();
  final TextEditingController productImageUrl = TextEditingController();

  final CollectionReference firestore =
  FirebaseFirestore.instance.collection('products');
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? editingProductId;
  String selectedCategory = 'Uncategorized';

  final List<String> categories = [
    'Uncategorized',
    'Electronics',
    'Fashion',
    'Home',
    'Books',
    'Beauty',
  ];

  saveProduct() async {
    if (productName.text.isEmpty ||
        productPrice.text.isEmpty ||
        productDescription.text.isEmpty ||
        productImageUrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required')));
      return;
    }

    try {
      if (editingProductId != null) {
        await firestore.doc(editingProductId).update({
          'productName': productName.text,
          'productPrice': productPrice.text,
          'productDescription': productDescription.text,
          'productImage': productImageUrl.text,
          'category': selectedCategory,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product Updated Successfully')));
      } else {
        await firestore.add({
          'productName': productName.text,
          'productPrice': productPrice.text,
          'productDescription': productDescription.text,
          'productImage': productImageUrl.text,
          'category': selectedCategory,
          'createdAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product Added Successfully')));
      }
      cancelEdit();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  deleteProduct(String id) async {
    try {
      await firestore.doc(id).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  editProduct(DocumentSnapshot product) {
    final data = product.data() as Map<String, dynamic>;
    setState(() {
      productName.text = data['productName'];
      productPrice.text = data['productPrice'];
      productDescription.text = data['productDescription'];
      productImageUrl.text = data['productImage'];
      selectedCategory = data['category'] ?? 'Uncategorized';
      editingProductId = product.id;
    });
  }

  cancelEdit() {
    setState(() {
      editingProductId = null;
      productName.clear();
      productPrice.clear();
      productDescription.clear();
      productImageUrl.clear();
      selectedCategory = 'Uncategorized';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive columns: 1 mobile, 2 tablet, 3 small desktop, 4 large desktop
    int gridColumns = 1;
    if (screenWidth > 1200) {
      gridColumns = 4;
    } else if (screenWidth > 900) {
      gridColumns = 3;
    } else if (screenWidth > 600) {
      gridColumns = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color(0xff4157FF),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Product Form ---
            Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    LoginField(
                        controller: productName,
                        title: 'Product Name',
                        fieldName: 'Enter Product Name'),
                    LoginField(
                        controller: productPrice,
                        title: 'Product Price',
                        fieldName: 'Enter Product Price'),
                    LoginField(
                        controller: productDescription,
                        title: 'Product Description',
                        fieldName: 'Enter Product Description'),
                    LoginField(
                        controller: productImageUrl,
                        title: 'Product Image URL',
                        fieldName: 'Enter Product Image URL'),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories
                          .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCategory = val!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Select Category",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          onpressed: saveProduct,
                          buttonText: Text(
                            editingProductId != null
                                ? 'Update Product'
                                : 'Add Product',
                            style: const TextStyle(color: Colors.white),
                          ),
                          height: 45,
                          width: 150,
                          color: Colors.blue[700],
                        ),
                        if (editingProductId != null) ...[
                          const SizedBox(width: 10),
                          Button(
                            onpressed: cancelEdit,
                            buttonText: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            height: 45,
                            width: 100,
                            color: Colors.red[400],
                          )
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- Products Grid ---
            StreamBuilder<QuerySnapshot>(
              stream:
              firestore.orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text('No products added yet.'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = docs[index];
                    final data = product.data() as Map<String, dynamic>;
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Image.network(
                                data['productImage'],
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                    child:
                                    Icon(Icons.image_not_supported)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['productName'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ghc ${data['productPrice']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data['category'] ?? 'Uncategorized',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.orange),
                                        onPressed: () => editProduct(product),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteProduct(product.id),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

