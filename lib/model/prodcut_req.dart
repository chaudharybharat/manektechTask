class ProductReq{
String page="";
String perPage="";

ProductReq();

  ProductReq.fromJson(Map<String, dynamic> json) {
  page = json['page'];
  perPage = json['perPage'];
}
Map<String, dynamic> toJson() {
  final Map<String, dynamic> data =  <String, dynamic>{};
  data['page'] = page;
  data['perPage'] = perPage;

  return data;
}
}