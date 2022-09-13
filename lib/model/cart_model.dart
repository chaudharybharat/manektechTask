class CartModel{
  dynamic id;
  String title;
  String description;
  String featuredImage;
  dynamic price;
  int quantity;

  CartModel(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.featuredImage,
        this.quantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    featuredImage = json['featured_image'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['featured_image'] = featuredImage;
    return data;
  }
  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'title': title,
      'description': description,
      'price': price,
      'featuredImage': featuredImage,
    };
  }
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id']?.toInt() ?? 0,
      quantity: map['quantity'] ?? 0,
      title: map['title']??'',
      description: map['title']??'',
      price: map['price']??'',
      featuredImage: map['featuredImage']??'',
    );
  }
}