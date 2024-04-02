import 'package:global_gallery/views/components/animations/lottie_animation_view.dart';
import 'package:global_gallery/views/components/animations/models/lottie_animations.dart';

class ErrorAnimationView extends LottieAnimationView {
  const ErrorAnimationView({super.key})
      : super(animation: LottieAnimation.error);
}
