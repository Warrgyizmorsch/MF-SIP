import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/features/dashboard/screen/comparison_screen.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/images.dart';

class NomineeDetailsScreen extends StatelessWidget {
  NomineeDetailsScreen({super.key});
  final TextEditingController relationController = TextEditingController();
  final TextEditingController documnetController = TextEditingController();
  final List<String> relations = [
    'Aunt',
    'Brother-In-Law',
    'Brother',
    'Daughter',
    'Daughter-In-Law',
    'Father',
    'Father-In-Law',
    'Grand Daughter',
    'Grand Father',
    'Grand Mother',
    'Mother',
    'Mother-In-Law',
    'Son',
    'Spouse',
    'Testing',
  ];
  final List<String> document = [
    'Aadhar',
    'PAN',
    'Driving License',
    'Passport',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Nominee Detail'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),

              //Profile
              ProfileHeader(
                left: 0,
                bottom: 0,
                img: UImages.avatar,
                subtitle: 'Change Photo',
                icon: Iconsax.export,
                onTap: () {},
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Details
                  SmallHeading(
                    smallheading: 'Full Name',
                    fontWeight: FontWeight.w600,
                    // color: Colors.black87,
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'Enter nominees full name',
                    // controller: TextEditingController(text: 'Pr'),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    smallheading: 'Date of Birth',
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'DD/MM/YYYY',
                    sufixIcon: Icons.calendar_month,
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Email',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.mail_outline,
                    hintText: 'Enter nominees email ID',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Phone Number(Optional)',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: '+91 Enter nominnes mobile no.',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Document type',
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      // _documnetMenu(context); // no keyboard
                      showRelationBottomSheet(
                        context,
                        document,
                        documnetController,
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        controller: documnetController,
                        prefixIcon: Iconsax.document,
                        hintText: 'Aadhar / PAN / DL',
                        sufixIcon: Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Document Number',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.document_scanner_outlined,
                    hintText: '542191187840',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Relation',
                  ),
                  const SizedBox(height: 5),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      FocusScope.of(context).unfocus(); // no keyboard
                      // _showRelationMenu(context);
                      // _showRelationBottomSheet(context);
                      showRelationBottomSheet(
                        context,
                        relations,
                        relationController,
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        sufixIcon: Icons.arrow_drop_down,
                        controller: relationController,
                        prefixIcon: Iconsax.user,
                        hintText: 'Select Relation',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Address',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.location_on_outlined,
                    hintText: 'Enter your Full Address',
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomBarButton(
          firstButton: 'Cancel',
          secondButton: 'Save Changes',
        ),
      ),
    );
  }

  void showRelationBottomSheet(
    BuildContext context,
    List list,
    TextEditingController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 750),
      ),
      builder: (_) {
        String selected = controller.text;

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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Drag Handle
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Select Nominee Relation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Text('Search'),

                      // List container
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7FB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.separated(
                            controller: scrollController,
                            // itemCount: relations.length,
                            itemCount: list.length,
                            separatorBuilder: (_, __) =>
                                Divider(color: Colors.grey.shade300, height: 1),
                            itemBuilder: (context, index) {
                              final item = list[index];

                              return ListTile(
                                title: Text(item),
                                trailing: Radio<String>(
                                  value: item,
                                  groupValue: selected,
                                  onChanged: (value) {
                                    setState(() => selected = value!);
                                    controller.text = value!;
                                    Navigator.pop(context);
                                  },
                                ),
                                onTap: () {
                                  setState(() => selected = item);
                                  controller.text = item;
                                  Navigator.pop(context);
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
}
