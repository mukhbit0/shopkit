/// ShopKit - Modern E-commerce UI Library for Flutter
/// 
/// A comprehensive collection of modern, customizable e-commerce widgets
/// built on top of shadcn/ui design system for Flutter applications.

library;

// Export third-party packages (shadcn design system)
export 'package:shadcn_ui/shadcn_ui.dart';
export 'package:shadcn_flutter/shadcn_flutter.dart' hide LucideIcons, TreeView;

// Export theme system
export 'src/theme/shopkit_theme.dart';

// Export controllers
export 'src/controllers/cart_controller.dart';
export 'src/controllers/product_controller.dart';
export 'src/controllers/wishlist_controller.dart';

// Export models
export 'src/models/address_model.dart';
export 'src/models/announcement_model.dart';
export 'src/models/badge_model.dart';
export 'src/models/cart_model.dart';
export 'src/models/category_model.dart';
export 'src/models/checkout_step_model.dart';
export 'src/models/currency_model.dart';
export 'src/models/filter_model.dart';
export 'src/models/image_model.dart';
export 'src/models/menu_item_model.dart';
export 'src/models/notification_model.dart';
export 'src/models/order_model.dart';
export 'src/models/payment_model.dart';
export 'src/models/popup_model.dart';
export 'src/models/product_detail_model.dart';
export 'src/models/product_model.dart';
export 'src/models/review_model.dart';
export 'src/models/search_model.dart';
export 'src/models/share_model.dart';
export 'src/models/user_model.dart';
export 'src/models/variant_model.dart';
export 'src/models/wishlist_model.dart';

// Export widgets (Product Discovery)
export 'src/widgets/product_discovery/product_card.dart';
export 'src/widgets/product_discovery/search_bar.dart';
export 'src/widgets/product_discovery/product_grid.dart';

// Export widgets (Cart Management)
export 'src/widgets/cart_management/cart_item.dart';
export 'src/widgets/cart_management/add_to_cart_button.dart';
