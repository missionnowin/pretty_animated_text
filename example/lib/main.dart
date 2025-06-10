import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

const _loremText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
const _style = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
);
const letterAnimationDuration = Duration(milliseconds: 200);
const wordAnimationDuration = Duration(milliseconds: 1000);

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeWidget(),
    ),
  );
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  final Map<String, AnimatedTextController> _controllers = {};
  final PageController letterPageController = PageController();
  final PageController wordPageController = PageController();
  final pageTransitionDuration = const Duration(milliseconds: 200);
  final curve = Curves.easeInOut;
  int selectedValue = 0;
  final int length = 6;

  @override
  void dispose() {
    letterPageController.dispose();
    wordPageController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void _previousPage() {
    if (selectedValue == 0) {
      letterPageController.previousPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    } else {
      wordPageController.previousPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    }
  }

  void _nextPage() {
    if (selectedValue == 0) {
      letterPageController.nextPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    } else {
      wordPageController.nextPage(
        duration: pageTransitionDuration,
        curve: curve,
      );
    }
  }

  int get currentLetterPage => letterPageController.page?.round() ?? 0;
  int get currentWordPage => wordPageController.page?.round() ?? 0;

  void _setController(String key, AnimatedTextController controller) {
    _controllers[key] = controller;
  }

  void _handlePlay() {
    for (final controller in _controllers.values) {
      controller.play();
    }
  }

  void _handlePause() {
    for (final controller in _controllers.values) {
      controller.pause();
    }
  }

  void _handleRepeat() {
    for (final controller in _controllers.values) {
      controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pretty Animated Text',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              key: const ValueKey('pub.dev'),
              onPressed: () => _launchUrl(
                'https://pub.dev/packages/pretty_animated_text',
              ),
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset('assets/pub.png'),
              ),
            ),
            IconButton(
              key: const ValueKey('github'),
              onPressed: () => _launchUrl(
                'https://github.com/YeLwinOo-Steve/pretty_animated_text',
              ),
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset('assets/github.png'),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildControlButton(
                icon: Icons.refresh,
                label: 'Repeat',
                onPressed: _handleRepeat,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              _buildControlButton(
                icon: Icons.pause,
                label: 'Pause',
                onPressed: _handlePause,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              _buildControlButton(
                icon: Icons.play_arrow,
                label: 'Play',
                onPressed: _handlePlay,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildSegmentedControl(colorScheme),
                  const SizedBox(height: 24),
                  if (selectedValue == 0) ...[
                    Expanded(
                      flex: 9,
                      child: PageView(
                        controller: letterPageController,
                        children: [
                          _buildAnimationShowcase(
                            title: 'Scale Animation',
                            child: ScaleTextDemo(
                              onControllerCreated: (controller) =>
                                  _setController('scale_letter', controller),
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Slide Animation',
                            child: SlideTextDemo(
                              onControllerCreated: (controller) =>
                                  _setController('slide_letter', controller),
                              slideType: SlideAnimationType.leftRight,
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Rotate Animation',
                            child: RotateTextDemo(
                              onControllerCreated: (controller) =>
                                  _setController('rotate_letter', controller),
                              direction: RotateAnimationType.clockwise,
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Chime Bell Animation',
                            child: ChimeBellDemo(
                              onControllerCreated: (controller) =>
                                  _setController('chime_letter', controller),
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Spring Animation',
                            child: SpringDemo(
                              onControllerCreated: (controller) =>
                                  _setController('spring_letter', controller),
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Blur Animation',
                            child: BlurTextDemo(
                              onControllerCreated: (controller) =>
                                  _setController('blur_letter', controller),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPageControls(letterPageController, colorScheme),
                  ] else ...[
                    Expanded(
                      flex: 9,
                      child: PageView(
                        controller: wordPageController,
                        children: [
                          _buildAnimationShowcase(
                            title: 'Scale Animation',
                            child: ScaleTextDemo(
                              type: AnimationType.word,
                              duration: wordAnimationDuration,
                              onControllerCreated: (controller) =>
                                  _setController('scale_word', controller),
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Slide Animation',
                            child: SlideTextDemo(
                              type: AnimationType.word,
                              duration: wordAnimationDuration,
                              onControllerCreated: (controller) =>
                                  _setController('slide_word', controller),
                              slideType: SlideAnimationType.leftRight,
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Rotate Animation',
                            child: RotateTextDemo(
                              type: AnimationType.word,
                              duration: wordAnimationDuration,
                              onControllerCreated: (controller) =>
                                  _setController('rotate_word', controller),
                              direction: RotateAnimationType.clockwise,
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Chime Bell Animation',
                            child: ChimeBellDemo(
                              type: AnimationType.word,
                              duration: wordAnimationDuration,
                              onControllerCreated: (controller) =>
                                  _setController('chime_word', controller),
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Spring Animation',
                            child: SpringDemo(
                              type: AnimationType.word,
                              duration: wordAnimationDuration,
                              onControllerCreated: (controller) =>
                                  _setController('spring_word', controller),
                            ),
                          ),
                          _buildAnimationShowcase(
                            title: 'Blur Animation',
                            child: BlurTextDemo(
                              type: AnimationType.word,
                              duration: wordAnimationDuration,
                              onControllerCreated: (controller) =>
                                  _setController('blur_word', controller),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPageControls(wordPageController, colorScheme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          child: Icon(icon),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl(ColorScheme colorScheme) {
    return CupertinoSlidingSegmentedControl<int>(
      backgroundColor: colorScheme.primaryContainer,
      children: {
        0: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
          child: Text(
            'Letters',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        1: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
          child: Text(
            'Words',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      },
      groupValue: selectedValue,
      onValueChanged: (int? value) {
        setState(() {
          selectedValue = value!;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selectedValue == 0) {
            letterPageController.jumpToPage(0);
            for (final controller in _controllers.values) {
              controller.restart();
            }
          } else {
            wordPageController.jumpToPage(0);
            for (final controller in _controllers.values) {
              controller.restart();
            }
          }
        });
      },
    );
  }

  Widget _buildAnimationShowcase({
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius:
                  const BorderRadius.all(Radius.circular(16)),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildPageControls(
      PageController controller, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: controller,
            count: length,
            effect: ExpandingDotsEffect(
              activeDotColor: colorScheme.primary,
              dotColor: colorScheme.primary.withOpacity(0.2),
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
              expansionFactor: 4,
            ),
            onDotClicked: (index) {
              controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavigationButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: _previousPage,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 24),
              _buildNavigationButton(
                icon: Icons.arrow_forward_ios,
                onPressed: _nextPage,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
  }) {
    return Material(
      color: colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class ChimeBellDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final GlobalKey? chimbellTextKey;
  final void Function(AnimatedTextController)? onControllerCreated;
  const ChimeBellDemo({
    super.key,
    this.chimbellTextKey,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChimeBellText(
        key: chimbellTextKey,
        text: _loremText,
        style: _style,
        textAlign: TextAlign.start,
        config: AnimationConfig(
          type: type,
          duration: duration,
          repeat: true,
          repeatCount: 3,
          repeatDelay: const Duration(milliseconds: 500),
          onPlay: (controller) {
            print('$runtimeType is played!');
          },
          onPause: (controller) {
            print('$runtimeType is paused!');
          },
          onRepeat: (controller) {
            print('$runtimeType is repeated!');
          },
          onComplete: (controller) {
            print('$runtimeType is completed!');
          },
          onDismissed: (controller) {
            print('$runtimeType is dismissed!');
          },
        ),
        onControllerCreated: onControllerCreated,
      ),
    );
  }
}

class SpringDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;
  const SpringDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpringText(
        text: _loremText,
        style: _style,
        textAlign: TextAlign.start,
        config: AnimationConfig(
          type: type,
          duration: duration,
          repeat: true,
          repeatCount: 3,
          repeatDelay: const Duration(milliseconds: 500),
          onPlay: (controller) {
            print('$runtimeType is played!');
          },
          onPause: (controller) {
            print('$runtimeType is paused!');
          },
          onRepeat: (controller) {
            print('$runtimeType is repeated!');
          },
          onComplete: (controller) {
            print('$runtimeType is completed!');
          },
          onDismissed: (controller) {
            print('$runtimeType is dismissed!');
          },
        ),
        onControllerCreated: onControllerCreated,
      ),
    );
  }
}

class ScaleTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final GlobalKey? scaleTextKey;
  final void Function(AnimatedTextController)? onControllerCreated;
  const ScaleTextDemo({
    super.key,
    this.scaleTextKey,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleText(
        key: scaleTextKey,
        text: _loremText,
        style: _style,
        textAlign: TextAlign.start,
        config: AnimationConfig(
          type: type,
          duration: duration,
          repeat: true,
          repeatCount: 3,
          // reverse: true,
          repeatDelay: const Duration(milliseconds: 500),
          onPlay: (controller) {
            print('$runtimeType is played!');
          },
          onPause: (controller) {
            print('$runtimeType is paused!');
          },
          onRepeat: (controller) {
            print('$runtimeType is repeated!');
          },
          onComplete: (controller) {
            print('$runtimeType is completed!');
          },
          onDismissed: (controller) {
            print('$runtimeType is dismissed!');
          },
        ),
        onControllerCreated: onControllerCreated,
      ),
    );
  }
}

class RotateTextDemo extends StatelessWidget {
  final AnimationType type;
  final GlobalKey? rotateTextKey;
  final RotateAnimationType direction;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;
  const RotateTextDemo({
    super.key,
    this.rotateTextKey,
    this.direction = RotateAnimationType.clockwise,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotateText(
        key: rotateTextKey,
        text: _loremText,
        style: _style,
        textAlign: TextAlign.start,
        direction: direction,
        config: AnimationConfig(
          type: type,
          duration: duration,
          repeat: true,
          repeatCount: 3,
          repeatDelay: const Duration(milliseconds: 500),
          onPlay: (controller) {
            print('$runtimeType is played!');
          },
          onPause: (controller) {
            print('$runtimeType is paused!');
          },
          onRepeat: (controller) {
            print('$runtimeType is repeated!');
          },
          onComplete: (controller) {
            print('$runtimeType is completed!');
          },
          onDismissed: (controller) {
            print('$runtimeType is dismissed!');
          },
        ),
        onControllerCreated: onControllerCreated,
      ),
    );
  }
}

class BlurTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;
  const BlurTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurText(
        text: _loremText,
        style: _style,
        textAlign: TextAlign.start,
        config: AnimationConfig(
          type: type,
          duration: duration,
          repeat: true,
          repeatCount: 3,
          repeatDelay: const Duration(milliseconds: 500),
          onPlay: (controller) {
            print('$runtimeType is played!');
          },
          onPause: (controller) {
            print('$runtimeType is paused!');
          },
          onRepeat: (controller) {
            print('$runtimeType is repeated!');
          },
          onComplete: (controller) {
            print('$runtimeType is completed!');
          },
          onDismissed: (controller) {
            print('$runtimeType is dismissed!');
          },
        ),
        onControllerCreated: onControllerCreated,
      ),
    );
  }
}

class SlideTextDemo extends StatelessWidget {
  final GlobalKey? slideTextKey;
  final AnimationType type;
  final SlideAnimationType slideType;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;
  const SlideTextDemo({
    super.key,
    this.slideTextKey,
    this.type = AnimationType.letter,
    this.slideType = SlideAnimationType.topBottom,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideText(
        key: slideTextKey,
        text: _loremText,
        style: _style,
        textAlign: TextAlign.start,
        slideType: slideType,
        config: AnimationConfig(
          type: type,
          duration: duration,
          repeat: true,
          repeatCount: 3,
          repeatDelay: const Duration(milliseconds: 500),
          onPlay: (controller) {
            print('$runtimeType is played!');
          },
          onPause: (controller) {
            print('$runtimeType is paused!');
          },
          onRepeat: (controller) {
            print('$runtimeType is repeated!');
          },
          onComplete: (controller) {
            print('$runtimeType is completed!');
          },
          onDismissed: (controller) {
            print('$runtimeType is dismissed!');
          },
        ),
        onControllerCreated: onControllerCreated,
      ),
    );
  }
}
