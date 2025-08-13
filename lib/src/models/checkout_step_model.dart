import 'package:equatable/equatable.dart';

/// Model representing a checkout step in the checkout process
class CheckoutStepModel extends Equatable {
  const CheckoutStepModel({
    required this.id,
    required this.title,
    required this.status,
    this.description,
    this.icon,
    this.order = 0,
    this.isOptional = false,
    this.estimatedTime,
  });

  /// Unique identifier for the step
  final String id;

  /// Title of the checkout step
  final String title;

  /// Current status of the step
  final CheckoutStepStatus status;

  /// Optional description of the step
  final String? description;

  /// Optional icon name or identifier
  final String? icon;

  /// Order/position of the step in the process
  final int order;

  /// Whether this step is optional
  final bool isOptional;

  /// Estimated time to complete this step (in minutes)
  final int? estimatedTime;

  /// Whether the step is completed
  bool get isCompleted => status == CheckoutStepStatus.completed;

  /// Whether the step is currently active
  bool get isActive => status == CheckoutStepStatus.active;

  /// Whether the step is pending
  bool get isPending => status == CheckoutStepStatus.pending;

  /// Create CheckoutStepModel from JSON
  factory CheckoutStepModel.fromJson(Map<String, dynamic> json) =>
      CheckoutStepModel(
        id: json['id'] as String,
        title: json['title'] as String,
        status: CheckoutStepStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => CheckoutStepStatus.pending,
        ),
        description: json['description'] as String?,
        icon: json['icon'] as String?,
        order: json['order'] as int? ?? 0,
        isOptional: json['isOptional'] as bool? ?? false,
        estimatedTime: json['estimatedTime'] as int?,
      );

  /// Convert CheckoutStepModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status.toString().split('.').last,
        'description': description,
        'icon': icon,
        'order': order,
        'isOptional': isOptional,
        'estimatedTime': estimatedTime,
      };

  /// Create a copy with modified properties
  CheckoutStepModel copyWith({
    String? id,
    String? title,
    CheckoutStepStatus? status,
    String? description,
    String? icon,
    int? order,
    bool? isOptional,
    int? estimatedTime,
  }) =>
      CheckoutStepModel(
        id: id ?? this.id,
        title: title ?? this.title,
        status: status ?? this.status,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        order: order ?? this.order,
        isOptional: isOptional ?? this.isOptional,
        estimatedTime: estimatedTime ?? this.estimatedTime,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        status,
        description,
        icon,
        order,
        isOptional,
        estimatedTime,
      ];
}

/// Status of a checkout step
enum CheckoutStepStatus {
  pending, // Not yet started
  active, // Currently active/in progress
  completed, // Successfully completed
  error, // Error occurred
  skipped, // Skipped (for optional steps)
}

/// Predefined checkout steps
class CheckoutSteps {
  static const CheckoutStepModel cart = CheckoutStepModel(
    id: 'cart',
    title: 'Cart Review',
    status: CheckoutStepStatus.pending,
    description: 'Review items in your cart',
    icon: 'shopping_cart',
    order: 1,
    estimatedTime: 2,
  );

  static const CheckoutStepModel shipping = CheckoutStepModel(
    id: 'shipping',
    title: 'Shipping Information',
    status: CheckoutStepStatus.pending,
    description: 'Enter your shipping address',
    icon: 'local_shipping',
    order: 2,
    estimatedTime: 3,
  );

  static const CheckoutStepModel payment = CheckoutStepModel(
    id: 'payment',
    title: 'Payment Method',
    status: CheckoutStepStatus.pending,
    description: 'Choose your payment method',
    icon: 'payment',
    order: 3,
    estimatedTime: 2,
  );

  static const CheckoutStepModel review = CheckoutStepModel(
    id: 'review',
    title: 'Order Review',
    status: CheckoutStepStatus.pending,
    description: 'Review your order details',
    icon: 'receipt',
    order: 4,
    estimatedTime: 1,
  );

  static const CheckoutStepModel confirmation = CheckoutStepModel(
    id: 'confirmation',
    title: 'Order Confirmation',
    status: CheckoutStepStatus.pending,
    description: 'Your order has been placed',
    icon: 'check_circle',
    order: 5,
    estimatedTime: 1,
  );

  static const List<CheckoutStepModel> defaultSteps = [
    cart,
    shipping,
    payment,
    review,
    confirmation,
  ];
}
