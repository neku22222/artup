class ArtworkModel {
  final String id;
  final String title;
  final String author;
  final String authorHandle;
  final String imageUrl;
  final int likes;
  final String tag;
  final String authorAvatarUrl;

  const ArtworkModel({
    required this.id,
    required this.title,
    required this.author,
    required this.authorHandle,
    required this.imageUrl,
    required this.likes,
    required this.tag,
    required this.authorAvatarUrl,
  });
}

class CreatorModel {
  final String id;
  final String name;
  final String handle;
  final String avatarUrl;
  final int workCount;
  bool isFollowing;

  CreatorModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.workCount,
    this.isFollowing = false,
  });
}

class StoryModel {
  final String id;
  final String name;
  final String avatarUrl;
  final bool seen;
  final bool isOwn;

  const StoryModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.seen = false,
    this.isOwn = false,
  });
}

class ChatModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String preview;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const ChatModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.preview,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class TrendingTagModel {
  final String tag;
  final String imageUrl;

  const TrendingTagModel({required this.tag, required this.imageUrl});
}

// ── Sample Data ──

class SampleData {
  static const List<StoryModel> stories = [
    StoryModel(id: '0', name: 'Your Story', avatarUrl: 'https://i.pravatar.cc/52?img=60', isOwn: true),
    StoryModel(id: '1', name: 'yuki_art', avatarUrl: 'https://i.pravatar.cc/52?img=22'),
    StoryModel(id: '2', name: 'marco_v', avatarUrl: 'https://i.pravatar.cc/52?img=33', seen: true),
    StoryModel(id: '3', name: 'aisha.k', avatarUrl: 'https://i.pravatar.cc/52?img=44'),
    StoryModel(id: '4', name: 'lena_draws', avatarUrl: 'https://i.pravatar.cc/52?img=55', seen: true),
    StoryModel(id: '5', name: 'diego_r', avatarUrl: 'https://i.pravatar.cc/52?img=17'),
  ];

  static const List<ArtworkModel> recommended = [
    ArtworkModel(
      id: '1', title: 'Starry Depths', author: 'Yuki Tanaka', authorHandle: '@yuki_art',
      imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=300&q=70',
      likes: 2400, tag: '#2D', authorAvatarUrl: 'https://i.pravatar.cc/32?img=22',
    ),
    ArtworkModel(
      id: '2', title: 'Neon Circuit', author: 'Marco Silva', authorHandle: '@marco_v',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=300&q=70',
      likes: 841, tag: '#3D', authorAvatarUrl: 'https://i.pravatar.cc/32?img=33',
    ),
    ArtworkModel(
      id: '3', title: 'Oil Study', author: 'Aisha Kone', authorHandle: '@aisha.k',
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&q=70',
      likes: 1100, tag: '#Oil', authorAvatarUrl: 'https://i.pravatar.cc/32?img=44',
    ),
    ArtworkModel(
      id: '4', title: 'Pose Study', author: 'Lena Park', authorHandle: '@lena_draws',
      imageUrl: 'https://images.unsplash.com/photo-1549490349-8643362247b5?w=300&q=70',
      likes: 553, tag: '#Sketch', authorAvatarUrl: 'https://i.pravatar.cc/32?img=55',
    ),
    ArtworkModel(
      id: '5', title: 'Pixel Dreams', author: 'pixel.works', authorHandle: '@pixel.works',
      imageUrl: 'https://images.unsplash.com/photo-1636622433525-127afdf3662d?w=300&q=70',
      likes: 3200, tag: '#Digital', authorAvatarUrl: 'https://i.pravatar.cc/32?img=11',
    ),
    ArtworkModel(
      id: '6', title: 'Arch Study', author: 'arch_eye', authorHandle: '@arch_eye',
      imageUrl: 'https://images.unsplash.com/photo-1493397212122-2b85dda8106b?w=300&q=70',
      likes: 908, tag: '#Photo', authorAvatarUrl: 'https://i.pravatar.cc/32?img=7',
    ),
  ];

  static List<CreatorModel> creators = [
    CreatorModel(id: '1', name: 'Diego R.', handle: '@diego_r', avatarUrl: 'https://i.pravatar.cc/44?img=5', workCount: 148),
    CreatorModel(id: '2', name: 'Priya S.', handle: '@priya_s', avatarUrl: 'https://i.pravatar.cc/44?img=15', workCount: 93),
    CreatorModel(id: '3', name: 'Tom H.', handle: '@tom_h', avatarUrl: 'https://i.pravatar.cc/44?img=25', workCount: 212),
    CreatorModel(id: '4', name: 'Mei L.', handle: '@mei_l', avatarUrl: 'https://i.pravatar.cc/44?img=35', workCount: 67),
    CreatorModel(id: '5', name: 'Sam W.', handle: '@sam_w', avatarUrl: 'https://i.pravatar.cc/44?img=45', workCount: 189),
  ];

  static const List<TrendingTagModel> trendingTags = [
    TrendingTagModel(tag: '#Renaissance', imageUrl: 'https://images.unsplash.com/photo-1617791160505-6f00504e3519?w=200&q=70'),
    TrendingTagModel(tag: '#Landscape', imageUrl: 'https://images.unsplash.com/photo-1508193638397-1c4234db14d8?w=200&q=70'),
    TrendingTagModel(tag: '#WaterColour', imageUrl: 'https://images.unsplash.com/photo-1549490349-8643362247b5?w=200&q=70'),
    TrendingTagModel(tag: '#Architecture', imageUrl: 'https://images.unsplash.com/photo-1493397212122-2b85dda8106b?w=200&q=70'),
    TrendingTagModel(tag: '#Sketch', imageUrl: 'https://images.unsplash.com/photo-1582201957428-5d25c01a6d53?w=200&q=70'),
    TrendingTagModel(tag: '#LifeDrawing', imageUrl: 'https://images.unsplash.com/photo-1601459427108-47e20d579a35?w=200&q=70'),
  ];

  static const List<ChatModel> chats = [
    ChatModel(id: '1', name: 'Yuki Tanaka', avatarUrl: 'https://i.pravatar.cc/46?img=22', preview: 'Loved your latest piece! The colours are 🔥', time: '2m', unreadCount: 3, isOnline: true),
    ChatModel(id: '2', name: 'Marco Silva', avatarUrl: 'https://i.pravatar.cc/46?img=33', preview: 'Can we collab on the next piece?', time: '1h', unreadCount: 1, isOnline: true),
    ChatModel(id: '3', name: 'Aisha Kone', avatarUrl: 'https://i.pravatar.cc/46?img=44', preview: 'Commission slots open — interested?', time: '2d'),
    ChatModel(id: '4', name: 'Lena Park', avatarUrl: 'https://i.pravatar.cc/46?img=55', preview: 'Thanks for the follow! Really appreciate it.', time: '3d'),
    ChatModel(id: '5', name: 'Diego Ruiz', avatarUrl: 'https://i.pravatar.cc/46?img=17', preview: 'Hey, saw your sketch study — brilliant!', time: '5d'),
    ChatModel(id: '6', name: 'Priya Sharma', avatarUrl: 'https://i.pravatar.cc/46?img=15', preview: 'Shared your oil study in our group!', time: '1w'),
  ];
}
