import 'package:web_scraper/web_scraper.dart';

Future<List> getAnimalSumUpData(String animalLink) async {
  final webScraper = WebScraper('https://terms.naver.com');
  final String temp_link =
      '/entry.naver?docId=1107856&cid=40942&categoryId=32624';

  late List<String> sumup_keys; //요약정보 key
  late List<String> sumup_values; //요약정보 value
  late List<String> sumup_keys_changed = []; //요약정보 value
  late List<String> sumup_values_changed = []; //요약정보 value
  late List<Map> result = [];

  if (await webScraper.loadWebPage(temp_link)) {
    sumup_keys = webScraper.getElementTitle('tbody > tr > th > span');
    sumup_values = webScraper.getElementTitle('tbody > tr > td');
  }

  for (String key in sumup_keys) {
    if (key != '소리듣기') {
      sumup_keys_changed.add(key.trim());
    }
  }
  // print(sumup_keys_changed)
  for (String value in sumup_values) {
    if (value != '') {
      sumup_values_changed.add(value.trim());
    }
  }
  for (int i = 0; i < sumup_keys_changed.length; i++) {
    result.add({sumup_keys_changed[i]: sumup_values_changed[i]});
  }
  // print(result.toString());
  return result;
}

Future<List> getAnimalDesc(String animalLink) async {
  final webScraper = WebScraper('https://terms.naver.com');
  final String temp_link =
      '/entry.naver?docId=1070874&cid=40942&categoryId=32626';
  late List<Map> desc; //동물 상세정보
  late List result = [];
  if (await webScraper.loadWebPage(temp_link)) {
    desc = webScraper.getElement('p', ['class']);
  }

  for (dynamic temp in desc) {
    if (temp['title'] != '' && temp['attributes']['class'] == 'txt') {
      result.add(temp['title'].toString().trim().split('.'));
    }
  }
  for (dynamic temp in result) {
    print(temp);
  }
  // print(result);
  return result;
}

Future<List> getAnimalInfo(String animalName) async {
  late List animalInfo = [];
  // get animal link here from firestore
  String animalLink = '';
  animalInfo.add(await getAnimalSumUpData(animalLink));
  animalInfo.add(await getAnimalDesc(animalLink));

  return animalInfo;
}
