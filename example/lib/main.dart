import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:pretty_animated_text/src/animated_text_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

const _loremText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
const _style = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
);
const letterAnimationDuration = Duration(milliseconds: 3000);
const wordAnimationDuration = Duration(milliseconds: 3000);

void main() {
  runApp(
    const MaterialApp(
      home: HomeWidget(),
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
  AnimatedTextController? letterController;
  AnimatedTextController? wordController;

  final PageController letterPageController = PageController();
  final PageController wordPageController = PageController();
  final pageTransitionDuration = const Duration(milliseconds: 200);
  final curve = Curves.easeInOut;
  int selectedValue = 0;
  final int length = 12;

  @override
  void dispose() {
    letterPageController.dispose();
    wordPageController.dispose();
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

  void _setLetterController(AnimatedTextController controller) {
    letterController = controller;
  }

  void _setWordController(AnimatedTextController controller) {
    wordController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pretty Animated Text'),
          actions: [
            IconButton(
              key: const ValueKey('pub.dev'),
              onPressed: () => _launchUrl(
                'https://pub.dev/packages/pretty_animated_text',
              ),
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/pub.png')),
            ),
            const SizedBox(height: 8),
            IconButton(
              key: const ValueKey('github'),
              onPressed: () => _launchUrl(
                'https://github.com/YeLwinOo-Steve/pretty_animated_text',
              ),
              icon: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/github.png')),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  key: const ValueKey('repeat'),
                  onPressed: () {
                    letterController?.repeat();
                    wordController?.repeat();
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 4),
                FloatingActionButton(
                  key: const ValueKey('pause'),
                  onPressed: () {
                    letterController?.pause();
                    wordController?.pause();
                  },
                  child: const Icon(Icons.pause),
                ),
                const SizedBox(height: 4),
                FloatingActionButton(
                  key: const ValueKey('play'),
                  onPressed: () {
                    letterController?.play();
                    wordController?.play();
                  },
                  child: const Icon(Icons.play_arrow),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _tabs(),
              if (selectedValue == 0) ...[
                Expanded(
                  flex: 9,
                  child: PageView(
                    controller: letterPageController,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          ScaleTextDemo(
                            onControllerCreated: _setLetterController,
                          ),
                          ScaleTextDemo(
                            onControllerCreated: _setWordController,
                            type: AnimationType.word,
                            duration: wordAnimationDuration,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _pageIndicator(letterPageController),
              ] else ...[
                Expanded(
                  flex: 9,
                  child: PageView(
                    controller: wordPageController,
                    children: const [
                      ScaleTextDemo(
                        type: AnimationType.word,
                        duration: wordAnimationDuration,
                      ),
                    ],
                  ),
                ),
                _pageIndicator(wordPageController),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageIndicator(PageController controller) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SmoothPageIndicator(
              controller: controller,
              count: length,
              effect: ScrollingDotsEffect(
                activeDotColor: Colors.indigo,
                dotColor: Colors.indigo.withValues(alpha: 0.42),
                dotHeight: 8,
                dotWidth: 8,
              ),
              onDotClicked: (index) {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                key: const ValueKey('previous'),
                onPressed: _previousPage,
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                key: const ValueKey('next'),
                onPressed: _nextPage,
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _tabs() {
    return SizedBox(
      width: double.maxFinite,
      child: CupertinoSegmentedControl<int>(
        children: const {
          0: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text('Letters'),
          ),
          1: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text('Words'),
          ),
        },
        groupValue: selectedValue,
        onValueChanged: (int value) {
          setState(() {
            selectedValue = value;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selectedValue == 0) {
              letterPageController.jumpToPage(0);
              letterController?.restart();
            } else {
              wordPageController.jumpToPage(0);
              wordController?.restart();
            }
          });
        },
      ),
    );
  }
}

class ChimeBellDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final GlobalKey? chimbellTextKey;
  const ChimeBellDemo({
    super.key,
    this.chimbellTextKey,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChimeBellText(
        key: chimbellTextKey,
        text: _loremText,
        duration: duration,
        type: type,
        textStyle: _style,
      ),
    );
  }
}

class SpringDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final void Function(AnimationController)? builder;
  const SpringDemo({
    super.key,
    this.builder,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpringText(
        text: _loremText,
        duration: duration,
        type: type,
        textStyle: _style,
        onRepeat: (_) {
          print('$runtimeType is repeated');
        },
        onPause: (_) {
          print('$runtimeType is paused!');
        },
        onPlay: (_) {
          print('$runtimeType is played!');
        },
        builder: builder,
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
      child: AnimatedTextBase(
        key: scaleTextKey,
        text: _loremText,
        style: _style,
        textAlign: TextAlign.start,
        config: AnimationConfig(
          type: type,
          duration: duration,
          repeat: true,
          repeatCount: 3,
          reverse: true,
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
        builder: (context, animations, segments) {
          return Wrap(
            alignment: WrapAlignment.start,
            children: List.generate(segments.length, (index) {
              return Transform.scale(
                scale: animations[index].value,
                alignment: Alignment.center,
                child: Text(
                  segments[index],
                  style: _style,
                ),
              );
            }),
          );
        },
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
  const RotateTextDemo({
    super.key,
    this.rotateTextKey,
    this.direction = RotateAnimationType.clockwise,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotateText(
        key: rotateTextKey,
        text: _loremText,
        direction: direction,
        duration: duration,
        type: type,
        textStyle: _style,
      ),
    );
  }
}

class BlurTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  const BlurTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurText(
        type: type,
        duration: duration,
        text: _loremText,
        textStyle: _style,
      ),
    );
  }
}

class OffsetTextDemo extends StatelessWidget {
  final GlobalKey? offsetTextKey;
  final AnimationType type;
  final SlideAnimationType slideType;
  final Duration duration;
  const OffsetTextDemo({
    super.key,
    this.offsetTextKey,
    this.type = AnimationType.letter,
    this.slideType = SlideAnimationType.topBottom,
    this.duration = letterAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OffsetText(
        key: offsetTextKey,
        text: _loremText,
        duration: duration,
        type: type,
        slideType: slideType,
        textStyle: _style,
      ),
    );
  }
}
