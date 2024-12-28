// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as htmlParser;
// import 'package:html/dom.dart';

// Future<void> scrapeWebsite() async {
//   // print("object");
//   final url = 'https://mjbma.com'; // Replace with your target website
//   // final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     // Parse the HTML document
//     var document = htmlParser.parse(response.body);

//     // Example: Get all elements with a specific class name
//     List<Element> table = document.querySelectorAll('.rate-table tbody tr td');
//     final goldprice = table[2].text;
//     final silverprice = table[5].text;
//     var updatedDatetime =
//         document.querySelector('.rate-table + div')!.text.split(" ");

//     final updateddate = updatedDatetime[2];
//     final updatedtime = updatedDatetime[3] + updatedDatetime[4];
//     print(updateddate);
//     print(updatedtime);

//     // for (var element in elements) {
//     //   // Extract text or attribute from each element
//     //   print(element.text); // or element.attributes['href']
//     // }
//   } else {
//     print('Failed to load website');
//   }
// }
