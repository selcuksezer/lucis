import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/models/location.dart';

class FeedStream {
  final Stream<List<Feed>> feedStream;
  final Location center;
  final double radius;

  FeedStream({
    required this.feedStream,
    required this.center,
    required this.radius,
  });
}
