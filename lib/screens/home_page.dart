import 'dart:js';

import 'package:flutter/material.dart';
import 'package:responsi/models/category_model.dart';
import 'package:responsi/screens/meals_screen.dart';
import 'package:responsi/services/api_data_source.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: ApiDataSource.instance.LoadCategory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            CategoryModel categories = CategoryModel.fromJson(snapshot.data!);
            return _buildCategories(categories);
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildCategories(CategoryModel categories) {
    return ListView.builder(
      itemCount: categories.categories!.length,
      itemBuilder: (context, index) {
        var item = categories.categories![index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MealsPage(
                        CategoryName: item.strCategory!,
                      )),
            );
          },
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              leading: Image.network(item.strCategoryThumb!),
              title: Text(item.strCategory!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              subtitle: Text(
                item.strCategoryDescription!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )),
        );
      },
    );
  }
}
