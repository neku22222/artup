import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models.dart';
import '../services/supabase_service.dart';
import '../widgets/common_widgets.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostModel? _post;
  List<CommentModel> _comments = [];
  bool _loading = true;
  bool _likeLoading = false;
  final _commentCtrl = TextEditingController();
  bool _sendingComment = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        postService.getPost(widget.postId),
        commentService.getComments(widget.postId),
      ]);
      if (mounted) setState(() {
        _post     = results[0] as PostModel?;
        _comments = results[1] as List<CommentModel>;
        _loading  = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleLike() async {
    if (_post == null || _likeLoading) return;
    final wasLiked = _post!.isLiked;
    setState(() {
      _likeLoading = true;
      _post!.isLiked = !wasLiked;
      _post!.likesCount += wasLiked ? -1 : 1;
    });
    try {
      if (wasLiked) await postService.unlikePost(_post!.id);
      else await postService.likePost(_post!.id);
    } catch (_) {
      setState(() {
        _post!.isLiked = wasLiked;
        _post!.likesCount += wasLiked ? 1 : -1;
      });
    } finally {
      if (mounted) setState(() => _likeLoading = false);
    }
  }

  Future<void> _sendComment() async {
    final body = _commentCtrl.text.trim();
    if (body.isEmpty || _sendingComment) return;
    setState(() => _sendingComment = true);
    try {
      await commentService.addComment(widget.postId, body);
      _commentCtrl.clear();
      final comments = await commentService.getComments(widget.postId);
      if (mounted) setState(() => _comments = comments);
    } catch (_) {} finally {
      if (mounted) setState(() => _sendingComment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.dark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Post', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.dark)),
        actions: [
          if (_post != null && _post!.authorId == authService.currentUserId)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.peach))
          : _post == null
              ? const EmptyState(emoji: '😕', title: 'Post not found', subtitle: 'It may have been deleted')
              : Column(children: [
                  Expanded(child: _buildBody()),
                  _buildCommentInput(),
                ]),
    );
  }

  Widget _buildBody() {
    final post = _post!;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image
        AspectRatio(
          aspectRatio: 1,
          child: AppNetworkImage(url: post.imageUrl),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Author row
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileScreen(userId: post.authorId))),
              child: Row(children: [
                UserAvatar(url: post.authorAvatar ?? '', size: 36),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(post.authorName ?? post.authorHandle ?? '',
                      style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark)),
                  Text('@${post.authorHandle ?? ''}',
                      style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                ]),
                const Spacer(),
                Text(timeago.format(post.createdAt),
                    style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
              ]),
            ),
            const SizedBox(height: 14),

            // Title
            Text(post.title,
                style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.dark)),
            const SizedBox(height: 6),

            // Category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.peachPale,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.peachLight),
              ),
              child: Text(post.category,
                  style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.brown, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 10),

            // Description
            if (post.description.isNotEmpty) ...[
              Text(post.description, style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.muted, height: 1.6)),
              const SizedBox(height: 10),
            ],

            // Tags
            if (post.tags.isNotEmpty)
              Wrap(spacing: 6, runSpacing: 6, children: post.tags.map((t) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      // Could navigate to search with tag
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.peachPale,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.peach)),
                    ),
                  )).toList()),
            const SizedBox(height: 16),

            // Like button
            Row(children: [
              GestureDetector(
                onTap: _toggleLike,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: post.isLiked ? AppColors.peach : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: post.isLiked ? AppColors.peach : AppColors.border, width: 1.5),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? Colors.white : AppColors.muted, size: 16),
                    const SizedBox(width: 6),
                    Text('${post.likesCount}',
                        style: GoogleFonts.dmSans(
                            fontSize: 13, fontWeight: FontWeight.w600,
                            color: post.isLiked ? Colors.white : AppColors.muted)),
                  ]),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.chat_bubble_outline, color: AppColors.muted, size: 16),
                  const SizedBox(width: 6),
                  Text('${_comments.length}',
                      style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted)),
                ]),
              ),
            ]),

            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 10),

            // Comments
            Text('Comments', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
            const SizedBox(height: 12),

            if (_comments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('No comments yet. Be the first!',
                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted)),
              )
            else
              ..._comments.map((c) => _CommentTile(comment: c)),

            const SizedBox(height: 80),
          ]),
        ),
      ]),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 12, top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      decoration: const BoxDecoration(
        color: AppColors.warmWhite,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _commentCtrl,
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.dark),
            decoration: const InputDecoration(
              hintText: 'Add a comment…',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
            maxLines: null,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _sendComment,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36, height: 36,
            decoration: const BoxDecoration(color: AppColors.peach, shape: BoxShape.circle),
            child: _sendingComment
                ? const Padding(padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ),
        ),
      ]),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete post?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await postService.deletePost(widget.postId);
      if (mounted) Navigator.of(context).pop();
    }
  }
}

class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UserAvatar(url: comment.authorAvatar ?? '', size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('@${comment.authorHandle ?? 'user'}',
                  style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.dark)),
              const SizedBox(width: 8),
              Text(timeago.format(comment.createdAt),
                  style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.muted)),
            ]),
            const SizedBox(height: 3),
            Text(comment.body, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted, height: 1.5)),
          ]),
        ),
      ]),
    );
  }
}
