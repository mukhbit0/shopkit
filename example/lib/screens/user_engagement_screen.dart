import 'package:flutter/material.dart';

class UserEngagementScreen extends StatefulWidget {
  const UserEngagementScreen({
    super.key,
    required this.themeStyle,
  });

  final String themeStyle;

  @override
  State<UserEngagementScreen> createState() => _UserEngagementScreenState();
}

class _UserEngagementScreenState extends State<UserEngagementScreen> {
  bool _isWishlisted = false;
  int _rating = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('User Engagement - ${widget.themeStyle.toUpperCase()}'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Wishlist Button'),
            const SizedBox(height: 16),
            
            _buildWishlistDemo(),
            const SizedBox(height: 24),
            
            _buildSectionHeader('Rating & Reviews'),
            const SizedBox(height: 16),
            
            _buildRatingDemo(),
            const SizedBox(height: 24),
            
            _buildSectionHeader('Trust Badges'),
            const SizedBox(height: 16),
            
            _buildTrustBadgesDemo(),
            const SizedBox(height: 24),
            
            _buildSectionHeader('User Feedback'),
            const SizedBox(height: 16),
            
            _buildFeedbackDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wishlist Interaction',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _isWishlisted = !_isWishlisted),
                  icon: Icon(
                    _isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: _isWishlisted ? Colors.red : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(_isWishlisted ? 'Remove from Wishlist' : 'Add to Wishlist'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Rating',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setState(() => _rating = index + 1),
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  );
                }),
              ],
            ),
            Text('Rating: $_rating/5 stars'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadgesDemo() {
    return Column(
      children: [
        _buildTrustBadge('SSL Secured', Icons.security, 'Your data is protected'),
        const SizedBox(height: 12),
        _buildTrustBadge('Free Shipping', Icons.local_shipping, 'On orders over \$50'),
        const SizedBox(height: 12),
        _buildTrustBadge('Money Back', Icons.attach_money, '30-day guarantee'),
      ],
    );
  }

  Widget _buildTrustBadge(String title, IconData icon, String description) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(
          widget.themeStyle == 'neumorphism' ? 16 : 8,
        ),
        border: widget.themeStyle == 'glassmorphism' 
          ? Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3))
          : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Feedback',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildReviewItem(
              'John Doe',
              'Amazing product! Fast delivery and great quality.',
              5,
              '2 days ago',
            ),
            const SizedBox(height: 12),
            _buildReviewItem(
              'Sarah Smith',
              'Good value for money. Would recommend to others.',
              4,
              '1 week ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String name, String review, int rating, String time) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                time,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
