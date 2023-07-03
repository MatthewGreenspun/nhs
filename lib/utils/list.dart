List<T> flatten<T>(List<List<T>> list) {
  List<T> newList = [];
  for (List<T> l in list) {
    for (T elem in l) {
      newList.add(elem);
    }
  }
  return newList;
}

List<R> idxMap<T, R>(List<T> list, R Function(T, int) fn) {
  List<R> newList = [];
  for (int i = 0; i < list.length; i++) {
    newList.add(fn(list[i], i));
  }
  return newList;
}
