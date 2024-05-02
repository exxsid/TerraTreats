import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:ionicons/ionicons.dart";
import "package:terratreats/services/recommended_product_service.dart";
import "package:terratreats/services/search_service.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/utils/preferences.dart";
import "package:terratreats/widgets/product_card.dart";

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  bool _isSearch = false;

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Kamote",
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _isSearch = false;
              });
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await SearchHistory.addSearchHistory(_searchController.text);
              setState(() {
                _isSearch = true;
              });
            },
            icon: Icon(Ionicons.search_outline),
            color: AppTheme.primary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (_isSearch ? searchedProducts() : searchHistory()),
      ),
    );
  }

  Column searchedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Results",
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: populateSearchedProducts(),
        ),
      ],
    );
  }

  FutureBuilder populateSearchedProducts() {
    return FutureBuilder(
        future: getSearchedProducts(_searchController.text),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final recommendedProducts = snapshot.data!;
          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            children: List.generate(recommendedProducts.length, (index) {
              final prod = recommendedProducts[index];
              return IntrinsicHeight(
                child: ProductCard(
                  id: prod.productId,
                  name: prod.name,
                  price: prod.price,
                  unit: prod.unit,
                  rating: prod.rating,
                  seller: prod.seller,
                  imgUrl: prod.imgUrl,
                ),
              );
            }),
          );
        });
  }

  Future<List<String>> getSearchHistory() async {
    return SearchHistory.getSearchHistory();
  }

  Column searchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "History",
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Expanded(
          child: FutureBuilder(
            future: getSearchHistory(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.hasError) {
                return Center(
                  child: Text("No search history"),
                );
              }
              final history = snapshot.data!;
              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.highlight,
                      side: BorderSide(
                        color: AppTheme.secondary,
                        width: 1.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.text = history[index];
                      _isSearch = true;
                      });
                    },
                    child: Text(
                      history[index],
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
