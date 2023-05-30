List<T> flatten<T>(List<List<T>> list) {
  List<T> newList = [];
  for (List<T> l in list) {
    for (T elem in l) {
      newList.add(elem);
    }
  }
  return newList;
}
