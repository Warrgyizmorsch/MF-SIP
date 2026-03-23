import 'package:flutter/material.dart';

Future<String?> showSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> items,
  String? selectedValue,
  required TextEditingController controller,
  bool search = true,
  List<String>? imgLogo,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      String selected = selectedValue ?? '';
      final searchController = TextEditingController();

      // 1. Create a "Source of Truth" list that pairs names with logos
      List<Map<String, String>> combinedSource = [];
      for (int i = 0; i < items.length; i++) {
        combinedSource.add({
          'name': items[i],
          'logo': (imgLogo != null && i < imgLogo.length) ? imgLogo[i] : '',
        });
      }

      void selectItem(String value) {
        controller.text = value;
        Navigator.pop(context, value); // Return the value
      }

      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          // Use this list for the UI - it starts as a copy of the source
          List<Map<String, String>> filteredData = List.from(combinedSource);

          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Drag handle
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // SEARCH BOX
                    if (search)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              // 2. Filter the combined list
                              filteredData = combinedSource
                                  .where(
                                    (e) => e['name']!.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ),
                                  )
                                  .toList();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color(0xFFF4F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // List
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: filteredData.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade300),
                          itemBuilder: (context, index) {
                            // 3. Extract the data from the filtered map
                            final bankName = filteredData[index]['name']!;
                            final bankLogo = filteredData[index]['logo']!;

                            return ListTile(
                              leading: bankLogo.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(bankLogo),
                                    )
                                  : null,
                              title: Text(bankName),
                              trailing: Radio<String>(
                                value: bankName,
                                groupValue: selected,
                                onChanged: (value) {
                                  setState(() => selected = value!);
                                  selectItem(value!);
                                },
                              ),
                              onTap: () {
                                setState(() => selected = bankName);
                                selectItem(bankName);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

// Future<String?> showSelectionBottomSheet({
//   required BuildContext context,
//   required String title,
//   required List<String> items,
//   String? selectedValue,
//   required TextEditingController controller,
//   bool search = true,
//   List<String>? imgLogo,
// }) {
//   return showModalBottomSheet<String>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) {
//       String selected = selectedValue ?? '';

//       // Create a combined list to filter both simultaneously
//       List<Map<String, String>> combinedList = [];
//       for (int i = 0; i < items.length; i++) {
//         combinedList.add({
//           'name': items[i],
//           'logo': (imgLogo != null && i < imgLogo.length) ? imgLogo[i] : '',
//         });
//       }

//       List<Map<String, String>> filteredData = List.from(combinedList);

//       List<String> filteredItems = List.from(items);
//       final searchController = TextEditingController();
//       void selectItem(String value) {
//         controller.text = value;
//         Navigator.pop(context);
//       }

//       return DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         minChildSize: 0.4,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (context, scrollController) {
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 12),

//                     // Drag handle
//                     Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Title
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     // 🔍 SEARCH BOX
//                     search
//                         ? Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: TextField(
//                               controller: searchController,
//                               // onChanged: (value) {
//                               //   setState(() {
//                               //     filteredItems = items
//                               //         .where(
//                               //           (e) => e.toLowerCase().contains(
//                               //             value.toLowerCase(),
//                               //           ),
//                               //         )
//                               //         .toList();
//                               //   });
//                               // },
//                               onChanged: (value) {
//                                 setState(() {
//                                   filteredData = combinedList
//                                       .where(
//                                         (e) => e['name']!
//                                             .toLowerCase()
//                                             .contains(value.toLowerCase()),
//                                       )
//                                       .toList();
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 hintText: 'Search',
//                                 prefixIcon: const Icon(Icons.search),
//                                 filled: true,
//                                 fillColor: const Color(0xFFF4F7FB),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 0,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                           )
//                         : SizedBox.shrink(),

//                     const SizedBox(height: 12),

//                     // List
//                     Expanded(
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF4F7FB),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: ListView.separated(
//                           controller: scrollController,
//                           itemCount: filteredItems.length,
//                           separatorBuilder: (_, __) =>
//                               Divider(height: 1, color: Colors.grey.shade300),

//                           // itemBuilder: (context, index) {
//                           //   final item = filteredItems[index];
//                           //   // final img = imgLogo![index];

//                           //   return ListTile(
//                           //     leading:
//                           //         (imgLogo != null && index < imgLogo.length)
//                           //         ? CircleAvatar(
//                           //             backgroundImage: NetworkImage(
//                           //               imgLogo[index],
//                           //             ),
//                           //           )
//                           //         : null,
//                           //     // leading:
//                           //     //     (imgLogo != null && imgLogo.length > index)
//                           //     //     ? CircleAvatar(
//                           //     //         backgroundImage: NetworkImage(
//                           //     //           imgLogo[index],
//                           //     //         ),
//                           //     //       )
//                           //     //     : null,
//                           //     // CircleAvatar(
//                           //     //   backgroundImage: NetworkImage(img),
//                           //     // ),
//                           //     // titleAlignment: ListTileTitleAlignment.threeLine,
//                           //     title: Text(item),
//                           //     trailing: Radio<String>(
//                           //       value: item,

//                           //       groupValue: selected,
//                           //       onChanged: (value) {
//                           //         setState(() => selected = value!);
//                           //         selectItem(value!);
//                           //       },
//                           //     ),
//                           //     onTap: () {
//                           //       setState(() => selected = item);
//                           //       // Navigator.pop(context, item);
//                           //       selectItem(item);
//                           //     },
//                           //   );
//                           // },
//                           itemBuilder: (context, index) {
//                             final item = filteredData[index]; // Get the map
//                             final name = item['name']!;
//                             final logo = item['logo']!;

//                             return ListTile(
//                               leading: logo.isNotEmpty
//                                   ? CircleAvatar(
//                                       backgroundImage: NetworkImage(logo),
//                                     )
//                                   : null,
//                               title: Text(name),
//                               trailing: Radio<String>(
//                                 value: name,
//                                 groupValue: selected,
//                                 onChanged: (value) {
//                                   setState(() => selected = value!);
//                                   selectItem(value!);
//                                 },
//                               ),
//                               onTap: () {
//                                 setState(() => selected = name);
//                                 selectItem(name);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }
