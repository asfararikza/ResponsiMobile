import 'package:flutter/material.dart';
import 'package:responsi/models/meals_model.dart';
import 'package:responsi/screens/detail_meal_screen.dart';
import 'package:responsi/services/api_data_source.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key, required this.CategoryName});
  final String CategoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CategoryName),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
        future: ApiDataSource.instance.LoadMealsByCategory(CategoryName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            MealsModel meals = MealsModel.fromJson(snapshot.data!);
            return _buildMeals(meals);
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error Loading Data'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildMeals(MealsModel meals) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: meals.meals!.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DetailMealPage(
                        idMeal: meals.meals![index].idMeal!,
                      )),
            );
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    meals.meals![index].strMealThumb!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    meals.meals![index].strMeal!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
