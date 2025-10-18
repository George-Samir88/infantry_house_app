import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_elevated_button.dart';
import 'package:infantry_house_app/views/widgets/help_view/show_contact_dialog.dart';
import '../../../generated/l10n.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import 'build_faq_item.dart';
import 'build_section_title.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBarEditingView(
          onPressed: () => Navigator.pop(context),
          title: loc.Help,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          buildSectionTitle(context, loc.FAQs),
          buildFaqItem(
            question: loc.HowToEditUserInfoQ,
            answer: loc.HowToEditUserInfoA,
          ),
          buildFaqItem(
            question: loc.HowCanIResetPasswordQ,
            answer: loc.HowCanIResetPasswordA,
          ),
          buildFaqItem(
            question: loc.HowCanIContactSupportQ,
            answer: loc.HowCanIContactSupportA,
          ),
          buildFaqItem(
            question: loc.HowToChangeLanguageQ,
            answer: loc.HowToChangeLanguageA,
          ),
          SizedBox(height: 20.h),
          CustomElevatedButtonWithIcon(
            label: S.of(context).ContactSupport,
            icon: Icons.support_agent_outlined,
            backGroundColor: Colors.brown.shade400,
            onPressed: () {
              showContactDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
