String arNum(num value) {
  const en = '0123456789.';
  const ar = '٠١٢٣٤٥٦٧٨٩٫';
  return value.toString().split('').map((c) {
    final i = en.indexOf(c);
    return i < 0 ? c : ar[i];
  }).join();
}
