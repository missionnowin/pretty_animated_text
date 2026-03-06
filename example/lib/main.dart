import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

const _loremText = 'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.';
const _style = TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.w800,
  color: Color(0xFF1E293B),
  height: 1.2,
  letterSpacing: -0.5,
);

const letterAnimationDuration = Duration(milliseconds: 400);
const wordAnimationDuration = Duration(milliseconds: 1000);

void main() {
  runApp(const PrettyAnimatedTextApp());
}

class PrettyAnimatedTextApp extends StatelessWidget {
  const PrettyAnimatedTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pretty Animated Text',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo
          surface: const Color(0xFFF8FAFC), // Slate 50
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  AnimatedTextController? _currentController;
  final PageController _pageController = PageController();
  final Duration _pageTransitionDuration = const Duration(milliseconds: 400);
  final Curve _curve = Curves.fastOutSlowIn;

  bool _isWordMode = false;
  int _currentPage = 0;

  late final List<AnimationDemoItem> _demos;

  @override
  void initState() {
    super.initState();
    _demos = [
      AnimationDemoItem(
          title: 'Scale',
          buildLetter: (onCreated) =>
              ScaleTextDemo(onControllerCreated: onCreated),
          buildWord: (onCreated) => ScaleTextDemo(
              type: AnimationType.word,
              duration: wordAnimationDuration,
              onControllerCreated: onCreated)),
      AnimationDemoItem(
          title: 'Slide',
          buildLetter: (onCreated) => SlideTextDemo(
              slideType: SlideAnimationType.leftRight,
              onControllerCreated: onCreated),
          buildWord: (onCreated) => SlideTextDemo(
              type: AnimationType.word,
              duration: wordAnimationDuration,
              slideType: SlideAnimationType.leftRight,
              onControllerCreated: onCreated)),
      AnimationDemoItem(
          title: 'Rotate',
          buildLetter: (onCreated) => RotateTextDemo(
              direction: RotateAnimationType.clockwise,
              onControllerCreated: onCreated),
          buildWord: (onCreated) => RotateTextDemo(
              type: AnimationType.word,
              duration: wordAnimationDuration,
              direction: RotateAnimationType.clockwise,
              onControllerCreated: onCreated)),
      AnimationDemoItem(
          title: 'Chime Bell',
          buildLetter: (onCreated) =>
              ChimeBellDemo(onControllerCreated: onCreated),
          buildWord: (onCreated) => ChimeBellDemo(
              type: AnimationType.word,
              duration: wordAnimationDuration,
              onControllerCreated: onCreated)),
      AnimationDemoItem(
          title: 'Spring',
          buildLetter: (onCreated) =>
              SpringDemo(onControllerCreated: onCreated),
          buildWord: (onCreated) => SpringDemo(
              type: AnimationType.word,
              duration: wordAnimationDuration,
              onControllerCreated: onCreated)),
      AnimationDemoItem(
          title: 'Blur',
          buildLetter: (onCreated) =>
              BlurTextDemo(onControllerCreated: onCreated),
          buildWord: (onCreated) => BlurTextDemo(
              type: AnimationType.word,
              duration: wordAnimationDuration,
              onControllerCreated: onCreated)),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentController?.dispose();
    super.dispose();
  }

  void _handlePlay() => _currentController?.play();
  void _handlePause() => _currentController?.pause();
  void _handleRepeat() => _currentController?.repeat();

  void _onModeChanged(bool isWord) {
    if (_isWordMode == isWord) return;
    setState(() {
      _isWordMode = isWord;
    });
    // Give time for widget to build and controller to be registered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRepeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return SelectionArea(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 48.0 : 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    Header(colorScheme: colorScheme),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isDesktop) ...[
                            Expanded(
                                flex: 1,
                                child: _buildSideNavigation(colorScheme)),
                            const SizedBox(width: 32),
                          ],
                          Expanded(
                            flex: 3,
                            child: _buildMainContent(colorScheme, isDesktop),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideNavigation(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Animations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _demos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final isSelected = _currentPage == index;
                return InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: _pageTransitionDuration,
                      curve: _curve,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _demos[index].title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.arrow_forward_ios,
                              size: 14, color: colorScheme.primary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(ColorScheme colorScheme, bool isDesktop) {
    return Column(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _demos[_currentPage].title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      ModeToggleRound(
                        isWordMode: _isWordMode,
                        onChanged: _onModeChanged,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _handleRepeat();
                      });
                    },
                    itemCount: _demos.length,
                    itemBuilder: (context, index) {
                      final demo = _demos[index];
                      final isCurrentPage = index == _currentPage;

                      void onControllerCreated(AnimatedTextController c) {
                        if (isCurrentPage) {
                          _currentController = c;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(48, 0, 48, 48),
                        child: Center(
                          key: ValueKey(
                              '${demo.title}_${_isWordMode}_$isCurrentPage'),
                          child: _isWordMode
                              ? demo.buildWord(onControllerCreated)
                              : demo.buildLetter(onControllerCreated),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildBottomControls(colorScheme, isDesktop),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(ColorScheme colorScheme, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isDesktop) ...[
          SmoothPageIndicator(
            controller: _pageController,
            count: _demos.length,
            effect: ExpandingDotsEffect(
              activeDotColor: colorScheme.primary,
              dotColor: colorScheme.outlineVariant,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
            onDotClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: _pageTransitionDuration,
                curve: _curve,
              );
            },
          ),
        ] else
          const SizedBox.shrink(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ControlButton(
                icon: Icons.refresh_rounded,
                tooltip: 'Repeat',
                onPressed: _handleRepeat,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              ControlButton(
                icon: Icons.pause_rounded,
                tooltip: 'Pause',
                onPressed: _handlePause,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              ControlButton(
                icon: Icons.play_arrow_rounded,
                tooltip: 'Play',
                onPressed: _handlePlay,
                colorScheme: colorScheme,
                isPrimary: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimationDemoItem {
  final String title;
  final Widget Function(void Function(AnimatedTextController)) buildLetter;
  final Widget Function(void Function(AnimatedTextController)) buildWord;

  AnimationDemoItem({
    required this.title,
    required this.buildLetter,
    required this.buildWord,
  });
}

// ---------------------------------------------------------
// Reusable UI Widgets
// ---------------------------------------------------------

class Header extends StatelessWidget {
  final ColorScheme colorScheme;
  const Header({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.text_fields_rounded,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Text(
              'Pretty Animated Text',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const Row(
          children: [
            _SocialButton(
              url: 'https://pub.dev/packages/pretty_animated_text',
              assetPath: 'assets/pub.png',
              tooltip: 'Pub.dev',
            ),
            SizedBox(width: 12),
            _SocialButton(
              url: 'https://github.com/YeLwinOo-Steve/pretty_animated_text',
              assetPath: 'assets/github.png',
              tooltip: 'GitHub',
            ),
          ],
        )
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String url;
  final String assetPath;
  final String tooltip;

  const _SocialButton(
      {required this.url, required this.assetPath, required this.tooltip});

  Future<void> _launch() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw Exception('Could not launch $url');
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: _launch,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.5)),
          ),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }
}

class ModeToggleRound extends StatelessWidget {
  final bool isWordMode;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;

  const ModeToggleRound({
    super.key,
    required this.isWordMode,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleItem(
            text: 'Letters',
            isSelected: !isWordMode,
            onTap: () => onChanged(false),
            colorScheme: colorScheme,
          ),
          _ToggleItem(
            text: 'Words',
            isSelected: isWordMode,
            onTap: () => onChanged(true),
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _ToggleItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color:
                isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;
  final bool isPrimary;

  const ControlButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.colorScheme,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPrimary ? colorScheme.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isPrimary ? colorScheme.onPrimary : colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Animation Demo Component Wrappers
// ---------------------------------------------------------

AnimationConfig _buildConfig(
  AnimationType type,
  Duration duration,
  void Function(AnimatedTextController)? onCreated,
) {
  return AnimationConfig(
    type: type,
    duration: duration,
    repeat: false, // We control repeat via buttons now
    onPlay: (c) => debugPrint('${type.name} animation played!'),
    onPause: (c) => debugPrint('${type.name} animation paused!'),
    onComplete: (c) => debugPrint('${type.name} animation completed!'),
    repeatCount: 3,
    onRepeat: (c) => debugPrint('${type.name} animation repeated!'),
    onDismissed: (c) => debugPrint('${type.name} animation dismissed!'),
  );
}

class ChimeBellDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;

  const ChimeBellDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => ChimeBellText(
        text: _loremText,
        style: _style,
        config: _buildConfig(type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
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
  Widget build(BuildContext context) => SpringText(
        text: _loremText,
        style: _style,
        config: _buildConfig(type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class ScaleTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;

  const ScaleTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => ScaleText(
        text: _loremText,
        style: _style,
        config: _buildConfig(type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class RotateTextDemo extends StatelessWidget {
  final AnimationType type;
  final RotateAnimationType direction;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;

  const RotateTextDemo({
    super.key,
    this.direction = RotateAnimationType.clockwise,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => RotateText(
        text: _loremText,
        style: _style,
        direction: direction,
        config: _buildConfig(type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
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
  Widget build(BuildContext context) => BlurText(
        text: _loremText,
        style: _style,
        config: _buildConfig(type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class SlideTextDemo extends StatelessWidget {
  final AnimationType type;
  final SlideAnimationType slideType;
  final Duration duration;
  final void Function(AnimatedTextController)? onControllerCreated;

  const SlideTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.slideType = SlideAnimationType.topBottom,
    this.duration = letterAnimationDuration,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => SlideText(
        text: _loremText,
        style: _style,
        slideType: slideType,
        config: _buildConfig(type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}
