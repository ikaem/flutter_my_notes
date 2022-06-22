extension Filter<T> on Stream<List<T>> {
  // so this returkls a stream of list of type
  // we are defining a function here
  // TODO we caould specify type and name of variable, or we dont have to specify name of argument inside the Function def for typedef
  // Stream<List<T>> filter(bool Function(T) where) {
  Stream<List<T>> filter(bool Function(T item) where) {
    // map here will return a Stream of some type that we specify to it
    final filteredStream = map<List<T>>((items) => items.where(where).toList());

    return filteredStream;
  }
}
