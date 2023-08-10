class ProductListData {
  ProductListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.product,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? product;
  int kacl;

  static List<ProductListData> tabIconsList = <ProductListData>[
    ProductListData(
      imagePath: 'assets/comprame_inventory/breakfast.png',
      titleTxt: 'Breakfast',
      kacl: 525,
      product: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    ProductListData(
      imagePath: 'assets/comprame_inventory/lunch.png',
      titleTxt: 'Lunch',
      kacl: 602,
      product: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    ProductListData(
      imagePath: 'assets/comprame_inventory/snack.png',
      titleTxt: 'Snack',
      kacl: 0,
      product: <String>['Recommend:', '800 kcal'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    ProductListData(
      imagePath: 'assets/comprame_inventory/dinner.png',
      titleTxt: 'Dinner',
      kacl: 0,
      product: <String>['Recommend:', '703 kcal'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
}
