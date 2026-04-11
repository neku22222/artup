import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models.dart';

// ── Network Image with fallback ──────────────────────────────────────────────

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => Container(color: AppColors.border),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.border,
        child: const Icon(Icons.broken_image_outlined, color: AppColors.muted),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

// ── Story Ring ───────────────────────────────────────────────────────────────

class StoryRing extends StatelessWidget {
  final StoryModel story;

  const StoryRing({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: story.seen
                ? null
                : const LinearGradient(
                    colors: [AppColors.peach, AppColors.amber],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: story.seen ? AppColors.border : null,
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cream,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: story.isOwn
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AppNetworkImage(url: story.avatarUrl, width: 48, height: 48),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: AppColors.peach,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 12),
                          ),
                        ),
                      ],
                    )
                  : AppNetworkImage(url: story.avatarUrl, width: 48, height: 48),
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 56,
          child: Text(
            story.name,
            style: GoogleFonts.dmSans(fontSize: 9, color: AppColors.muted),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Artwork Card ─────────────────────────────────────────────────────────────

class ArtworkCard extends StatelessWidget {
  final ArtworkModel artwork;
  final VoidCallback? onTap;

  const ArtworkCard({super.key, required this.artwork, this.onTap});

  String _formatLikes(int likes) {
    if (likes >= 1000) return '${(likes / 1000).toStringAsFixed(1)}k';
    return likes.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(url: artwork.imageUrl),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, color: Colors.white, size: 10),
                      const SizedBox(width: 3),
                      Text(
                        _formatLikes(artwork.likes),
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xAA140C08)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(artwork.title,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      Text(artwork.authorHandle,
                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 9)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Creator Card ─────────────────────────────────────────────────────────────

class CreatorCard extends StatefulWidget {
  final CreatorModel creator;

  const CreatorCard({super.key, required this.creator});

  @override
  State<CreatorCard> createState() => _CreatorCardState();
}

class _CreatorCardState extends State<CreatorCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ClipOval(
            child: AppNetworkImage(url: widget.creator.avatarUrl, width: 44, height: 44),
          ),
          const SizedBox(height: 6),
          Text(widget.creator.name,
              style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.dark),
              textAlign: TextAlign.center),
          Text('${widget.creator.workCount} works',
              style: GoogleFonts.dmSans(fontSize: 8, color: AppColors.muted)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => widget.creator.isFollowing = !widget.creator.isFollowing),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: widget.creator.isFollowing ? AppColors.peachPale : AppColors.peach,
                borderRadius: BorderRadius.circular(20),
                border: widget.creator.isFollowing
                    ? Border.all(color: AppColors.peachLight)
                    : null,
              ),
              child: Text(
                widget.creator.isFollowing ? 'Following' : 'Follow',
                style: GoogleFonts.dmSans(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: widget.creator.isFollowing ? AppColors.peach : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark)),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(actionLabel!,
                  style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.peach, fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

// ── Trending Tag Card ─────────────────────────────────────────────────────────

class TrendingTagCard extends StatelessWidget {
  final TrendingTagModel tag;
  final VoidCallback? onTap;

  const TrendingTagCard({super.key, required this.tag, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(Color(0x33000000), BlendMode.darken),
                child: AppNetworkImage(url: tag.imageUrl),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xB3140A05)],
                    ),
                  ),
                  child: Text(
                    tag.tag,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search Bar ────────────────────────────────────────────────────────────────

class AppSearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const AppSearchBar({super.key, required this.hint, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.muted, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.dark),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.dmSans(fontSize: 14, color: AppColors.muted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                fillColor: Colors.transparent,
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const AppFilterChip({super.key, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.peach : AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.peach : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
