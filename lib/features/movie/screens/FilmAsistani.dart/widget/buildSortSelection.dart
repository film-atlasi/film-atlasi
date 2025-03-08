// import 'package:flutter/material.dart';

// class SortSelectionWidget extends StatefulWidget {
//   @override
//   _SortSelectionWidgetState createState() => _SortSelectionWidgetState();
// }

// class _SortSelectionWidgetState extends State<SortSelectionWidget> {
//   late String selectedSort;

//   Widget _buildSortSelection() {
//     return _buildQuestionPage(
//       icon: Icons.bar_chart,
//       question: "Neye göre sıralansın?",
//       options: {
//         "popularity.desc": "Popülerlik",
//         "release_date.desc": "Yeni Çıkanlar",
//         "vote_count.desc": "En Çok Oy Alanlar",
//         "vote_average.desc": "Puan (Yüksekten Düşüğe)"
//       },
//       onSelect: (value) {
//         setState(() {
//           selectedSort = value;
//         });
//         _nextStep();
//       },
//     );
//   }

//   Widget _buildQuestionPage({
//     required IconData icon,
//     required String question,
//     required Map<String, String> options,
//     required Function(String) onSelect,
//   }) {
//     return Column(
//       children: [
//         Icon(icon),
//         Text(question),
//         ...options.entries.map((entry) {
//           return ListTile(
//             title: Text(entry.value),
//             onTap: () => onSelect(entry.key),
//           );
//         }).toList(),
//       ],
//     );
//   }

//   void _nextStep() {
//     // Implement the next step logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sort Selection'),
//       ),
//       body: _buildSortSelection(),
//     );
//   }
// }
