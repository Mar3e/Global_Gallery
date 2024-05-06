import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:global_gallery/views/components/animations/error_animation_view.dart';
import 'package:global_gallery/views/components/animations/loading_animation_view.dart';
import 'package:video_player/video_player.dart';
import 'package:global_gallery/state/posts/models/post.dart';

class PostVideoView extends HookWidget {
  final Post post;
  const PostVideoView(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(post.fileUrl),
    );

    final isVideoPlayerReady = useState(false);

    useEffect(() {
      controller.initialize().then((value) {
        isVideoPlayerReady.value = true;
        controller.setLooping(true);
        controller.play();
      });
      return controller.dispose;
    }, [controller]);

    switch (isVideoPlayerReady.value) {
      case true:
        return AspectRatio(
          aspectRatio: post.aspectRatio,
          child: VideoPlayer(controller),
        );
      case false:
        return const LoadingAnimationView();

      default:

        ///this should not be called case there is usually the case are only two
        ///but for in case
        return const ErrorAnimationView();
    }

    return const Placeholder();
  }
}
