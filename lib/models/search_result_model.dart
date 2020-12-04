class SearchResultModel {
  List titles;
  int pageIndex;
  int pagePos;
  String screenShot;
  SearchResultModel(Map<String, dynamic> data) {
    titles = data['formatedTitles'];
    pageIndex = data['pageIndex'];
    pagePos = data['position'];
    screenShot = data['screenshotURL'];
  }
}