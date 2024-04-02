import 'package:global_gallery/views/components/animations/lottie_animation_view.dart';
import 'package:global_gallery/views/components/animations/models/lottie_animations.dart';

class DataNotFoundAnimationView extends LottieAnimationView {
  const DataNotFoundAnimationView({super.key})
      : super(
          animation: LottieAnimation.dataNotFound,
        );
}
