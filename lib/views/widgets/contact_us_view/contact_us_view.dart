import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infantry_house_app/generated/l10n.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/custom_appbar_editing_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_card_item.dart';

class AppContactUsView extends StatefulWidget {
  const AppContactUsView({super.key});

  @override
  State<AppContactUsView> createState() => _AppContactUsViewState();
}

class _AppContactUsViewState extends State<AppContactUsView> {
  final List<bool> _visibleList = List.generate(6, (_) => false);

  @override
  void initState() {
    super.initState();
    _animateSequentially();
  }

  Future<void> _animateSequentially() async {
    for (int i = 0; i < _visibleList.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() => _visibleList[i] = true);
      }
    }
  }

  Future<void> _launchUrl({
    required String url,
    required BuildContext context,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        showSnackBar(
          context: context,
          message: S.of(context).cannotLaunchUrl,
          backgroundColor: Colors.redAccent,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(
        context: context,
        message: "${S.of(context).cannotLaunchUrl} : ${e.toString()}",
        backgroundColor: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: CustomAppBarEditingView(
          title: s.ContactUs,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactCardItem(
              index: 0,
              visible: _visibleList[0],
              icon: FontAwesomeIcons.facebook,
              title: s.Facebook,
              subtitle: 'facebook.com/InfantryHouse',
              color: Colors.blueAccent,
              onTap:
                  () => _launchUrl(
                    context: context,
                    url: "https://www.facebook.com/infantryhouse/",
                  ),
            ),
            ContactCardItem(
              index: 1,
              visible: _visibleList[1],
              icon: FontAwesomeIcons.instagram,
              title: s.instagram,
              subtitle: 'instagram.com/darelmoshah',
              color: const Color(0xFFE1306C),
              onTap:
                  () => _launchUrl(
                    context: context,
                    url: 'https://www.instagram.com/darelmoshah/',
                  ),
            ),
            ContactCardItem(
              index: 2,
              visible: _visibleList[2],
              icon: FontAwesomeIcons.whatsapp,
              title: s.WhatsApp,
              subtitle: '+20 103 382 7332',
              color: Colors.green,
              onTap:
                  () => _launchUrl(
                    context: context,
                    url: 'https://wa.me/201033827332',
                  ),
            ),
            ContactCardItem(
              index: 3,
              visible: _visibleList[3],
              icon: Icons.email_rounded,
              title: s.Email,
              subtitle: 'savory267@gmail.com',
              color: Colors.redAccent,
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'savory267@gmail.com',
                );
                await _launchUrl(
                  context: context,
                  url: emailLaunchUri.toString(),
                );
              },
            ),
            ContactCardItem(
              index: 4,
              visible: _visibleList[4],
              icon: Icons.phone_rounded,
              title: s.CallUs,
              subtitle: '+20 103 382 7332',
              color: Colors.brown,
              onTap:
                  () => _launchUrl(url: 'tel:+201033827332', context: context),
            ),
            ContactCardItem(
              index: 5,
              visible: _visibleList[5],
              icon: Icons.location_on_rounded,
              title: s.VisitUs,
              subtitle: s.locationSubtitle,
              color: Colors.orange,
              onTap:
                  () => _launchUrl(
                    context: context,
                    url: 'https://maps.app.goo.gl/6zUPBt7sp2juNLqo7?g_st=aw',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
