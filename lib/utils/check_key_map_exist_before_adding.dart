bool checkKeyMapExistBeforeAdding(Map<String, dynamic> map, String key) {
  if (map.containsKey(key)) {
    return true;
  } else {
    return false;
  }
}
