import 'package:lucis/domain/entities/feed.dart';
import 'package:lucis/domain/entities/feed_stream.dart';
import 'package:lucis/domain/entities/location.dart';

class FeedStreamModel extends FeedStream {
  FeedStreamModel({
    required Stream<List<Feed>> feedStream,
    required Location center,
    required double radius,
  }) : super(
          feedStream: feedStream,
          center: center,
          radius: radius,
        );
}
