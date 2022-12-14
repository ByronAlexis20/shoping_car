class ProductsState {
  final String searchTerm;
  final List<ProductItemState> products;

  ProductsState(this.searchTerm, this.products);
}

class ProductItemState {
  final String id;
  final String image;
  final String title;
  final String price;
  final String descripcion;

  ProductItemState(
      this.id, this.image, this.title, this.price, this.descripcion);
}
