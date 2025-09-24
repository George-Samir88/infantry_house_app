import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animations/animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/complaints_model.dart';

class FeedbackList extends StatefulWidget {
  final List<ComplaintModel> complaints;

  const FeedbackList({super.key, required this.complaints});

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.complaints.length,
      itemBuilder: (context, index) {
        final complaint = widget.complaints[index];
        return _AnimatedFeedbackCard(complaint: complaint, index: index);
      },
    );
  }
}

class _AnimatedFeedbackCard extends StatefulWidget {
  final ComplaintModel complaint;
  final int index;

  const _AnimatedFeedbackCard({required this.complaint, required this.index});

  @override
  State<_AnimatedFeedbackCard> createState() => _AnimatedFeedbackCardState();
}

class _AnimatedFeedbackCardState extends State<_AnimatedFeedbackCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  final Color baseBrown = const Color(0xFF6D3A2D); // بني غامق
  final Color softBrown = const Color(0xFF7B4F3E); // بني فاتح أهدأ
  final Color amber = const Color(0xFFFFA000); // Amber غامق للشكاوى

  @override
  Widget build(BuildContext context) {
    final c = widget.complaint;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                baseBrown.withValues(alpha: 0.95),
                softBrown.withValues(alpha:0.6), // gradient خفيف جدًا
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: baseBrown.withValues(alpha:0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: amber,
                    child: Text(
                      c.userName.isNotEmpty ? c.userName[0].toUpperCase() : "?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: baseBrown,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      c.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, HH:mm').format(c.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha:0.75),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Complaints chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: c.complaints.map((comp) {
                  return Chip(
                    label: Text(
                      comp.replaceAll("_", " ").toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: amber.withValues(alpha:0.85), // واضح ومريح
                    avatar: const Icon(
                      FontAwesomeIcons.triangleExclamation,
                      size: 14,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),

              // Expandable part
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (c.note.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        c.note,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                    if (c.imageUrl != null && c.imageUrl!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      OpenContainer(
                        closedElevation: 0,
                        closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        closedColor: Colors.transparent,
                        openBuilder: (context, _) => Scaffold(
                          appBar: AppBar(
                            backgroundColor: baseBrown,
                            iconTheme:
                            const IconThemeData(color: Colors.white),
                          ),
                          body: Center(
                            child: Hero(
                              tag: c.imageUrl!,
                              child: ComplaintImageViewer(
                                imageUrl: c.imageUrl!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        closedBuilder: (context, open) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Hero(
                            tag: c.imageUrl!,
                            child: ComplaintImageViewer(
                              imageUrl: c.imageUrl!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComplaintImageViewer extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const ComplaintImageViewer({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  bool _isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const Icon(
        Icons.image_not_supported,
        size: 60,
        color: Colors.grey,
      );
    }

    return _isNetworkImage(imageUrl)
        ? Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image,
            size: 60, color: Colors.red);
      },
    )
        : Image.file(
      File(imageUrl),
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image,
            size: 60, color: Colors.red);
      },
    );
  }
}
