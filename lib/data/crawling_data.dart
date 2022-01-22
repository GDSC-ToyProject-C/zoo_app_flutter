import 'package:web_scraper/web_scraper.dart';

Future<List> getAnimalSumUpData(String animalLink) async {
  final webScraper = WebScraper('https://terms.naver.com');
  late List<String> sumup_keys; //요약정보 key
  late List<String> sumup_values; //요약정보 value
  late List<String> sumup_keys_changed = []; //요약정보 value
  late List<String> sumup_values_changed = []; //요약정보 value
  late List<Map> result = [];

  if (await webScraper.loadWebPage(animalLink)) {
    sumup_keys = webScraper.getElementTitle('tbody > tr > th > span');
    sumup_values = webScraper.getElementTitle('tbody > tr > td');
  }

  for (String key in sumup_keys) {
    if (key != '소리듣기') {
      sumup_keys_changed.add(key.trim());
    }
  }
  for (String value in sumup_values) {
    if (value != '') {
      sumup_values_changed.add(value.trim());
    }
  }
  for (int i = 0; i < sumup_keys_changed.length; i++) {
    result.add({sumup_keys_changed[i]: sumup_values_changed[i]});
  }
  return result;
}

Future<List> getAnimalDesc(String animalLink) async {
  final webScraper = WebScraper('https://terms.naver.com');
  late List<Map> desc; //동물 상세정보
  late List result = [];
  if (await webScraper.loadWebPage(animalLink)) {
    desc = webScraper.getElement('p', ['class']);
  }

  for (dynamic temp in desc) {
    if (temp['title'] != '' && temp['attributes']['class'] == 'txt') {
      result.add(temp['title'].toString().trim().split('.'));
    }
  }
  return result;
}
