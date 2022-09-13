class ProductListMainRes {
  dynamic status;
  String message;
  dynamic totalRecord;
  dynamic totalPage;
  List<ProductList> data;

  ProductListMainRes(
      {this.status, this.message, this.totalRecord, this.totalPage, this.data});

  ProductListMainRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalRecord = json['totalRecord'];
    totalPage = json['totalPage'];
    if (json['data'] != null) {
      data = <ProductList>[];
      json['data'].forEach((v) {
        data.add( ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['totalRecord'] = totalRecord;
    data['totalPage'] = totalPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  dynamic id;
  String slug;
  String title;
  String description;
  dynamic price;
  String featuredImage;
  String status;
  String createdAt;

  ProductList(
      {this.id,
        this.slug,
        this.title,
        this.description,
        this.price,
        this.featuredImage,
        this.status,
        this.createdAt});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    featuredImage = json['featured_image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['featured_image'] = featuredImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'price': price,
      'featuredImage': featuredImage,
      'status': status,
      'created_at': createdAt
    };
  }
  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      id: map['id']?.toInt() ?? 0,
      slug: map['slug'] ?? '',
      title: map['title']??'',
      description: map['title']??'',
      price: map['price']??'',
      featuredImage: map['featuredImage']??'',
      status: map['status']??'',
      createdAt:  map['created_at']??'',
    );
  }
}