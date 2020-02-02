String getStringFromList(List<dynamic> list) {
  String result = '';

  list.forEach((e) {
    result = result + e.toString();
  });

  return result;
}
