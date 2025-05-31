import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RippleScreen extends StatefulWidget {
  const RippleScreen({Key? key}) : super(key: key);

  @override
  _RippleScreenState createState() => _RippleScreenState();
}

class _RippleScreenState extends State<RippleScreen> 
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showCreateButton = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final show = _scrollController.position.pixels <= 100;
    if (show != _showCreateButton) {
      setState(() => _showCreateButton = show);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildCreateButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Ripple', style: Theme.of(context).textTheme.titleLarge),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Following'),
          Tab(text: 'Trending'),
          Tab(text: 'Nearby'),
        ],
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildFeedList(),
        _buildTrendingContent(),
        _buildNearbyContent(),
      ],
    );
  }

  Widget _buildFeedList() {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) => _RipplePostCard(index: index),
      ),
    );
  }

  Widget _buildCreateButton() {
    return AnimatedScale(
      scale: _showCreateButton ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: FloatingActionButton(
        onPressed: () => _showCreatePostModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  autofocus: true,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "What's happening?",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RipplePostCard extends StatefulWidget {
  final int index;

  const _RipplePostCard({required this.index});

  @override
  State<_RipplePostCard> createState() => _RipplePostCardState();
}

class _RipplePostCardState extends State<_RipplePostCard> {
  bool _isLiked = false;
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Text(
              'Just completed my 30-day meditation challenge! '
              'The difference in my focus and clarity is amazing. '
              'Who wants to join me for the next round?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://source.unsplash.com/random/600x400/?meditation'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sarah Johnson',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 2),
            Text('2h ago · Public',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    )),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_outline,
            color: _isLiked ? Colors.red : null,
          ),
          onPressed: () => setState(() => _isLiked = !_isLiked),
        ),
        Text('24', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 16),
        const Icon(Icons.mode_comment_outlined, size: 20),
        const SizedBox(width: 8),
        Text('5', style: Theme.of(context).textTheme.bodySmall),
        const Spacer(),
        IconButton(
          icon: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
          ),
          onPressed: () => setState(() => _isBookmarked = !_isBookmarked),
        ),
      ],
    );
  }
}