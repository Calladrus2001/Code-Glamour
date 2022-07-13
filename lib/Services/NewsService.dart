import 'package:code_glamour/Models/NewsModel.dart';
import 'package:code_glamour/secrets.dart';
import 'package:http/http.dart' as http;

class NewsService {
  Future<News?> getNews() async {
    final String url =
        "https://newsapi.org/v2/everything?q=Fast Fashion&from=2022-06-20&sortBy=popularity&apiKey=${NEWS_API_KEY}&language=en&pageSize=15&excludeDomains=androidcentral.com";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return newsFromJson(response.body);
    } else {
      return null;
    }
  }
}
