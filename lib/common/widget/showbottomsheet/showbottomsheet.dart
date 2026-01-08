import 'package:flutter/material.dart';

Future<String?> showSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> items,
  String? selectedValue,
  required TextEditingController controller,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      String selected = selectedValue ?? '';
      List<String> filteredItems = List.from(items);
      final searchController = TextEditingController();
      void selectItem(String value) {
        controller.text = value; 
        Navigator.pop(context);
      }

      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
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

                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 🔍 SEARCH BOX
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            filteredItems = items
                                .where(
                                  (e) => e.toLowerCase().contains(
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
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
                          itemCount: filteredItems.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade300),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];

                            return ListTile(
                              title: Text(item),
                              trailing: Radio<String>(
                                value: item,
                                groupValue: selected,
                                onChanged: (value) {
                                  setState(() => selected = value!);
                                  selectItem(value!);
                                },
                              ),
                              onTap: () {
                                setState(() => selected = item);
                                // Navigator.pop(context, item);
                                selectItem(item);
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
