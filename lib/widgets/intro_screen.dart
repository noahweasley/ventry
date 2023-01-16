import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry/blocs/intro_screen_bloc/intro_screen_bloc.dart';
import 'package:ventry/blocs/theme_bloc/theme_bloc.dart';
import 'package:ventry/localization/strings.dart';

class IntroScreen extends StatefulWidget {
  final ThemeBloc themeBloc;

  const IntroScreen({super.key, required this.themeBloc});

  @override
  State<IntroScreen> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  // widget.themeBloc.isDarkThemeEnabled ?? false
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  final List<Widget> _introPageWidgetList = const <Widget>[
    Center(
      child: PageWidget(text: 'Page 1'),
    ),
    Center(
      child: PageWidget(text: 'Page 2'),
    ),
    Center(
      child: PageWidget(text: 'Page 3'),
    ),
    Center(
      child: PageWidget(text: 'Page 4'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IntroScreenBloc>();

    return LayoutBuilder(
      builder: ((context, boxConstraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Skip'),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) => _onPageChanged(pagePosition: value, bloc: bloc),
                children: _introPageWidgetList,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<IntroScreenBloc, int>(
                    builder: ((context, state) {
                      debugPrint('Bloc state: $state');
                      //  _pageController.animateToPage(
                      //    state,
                      //    duration: const Duration(seconds: 1),
                      //    curve: standardEasing,
                      //  );
                      return ElevatedButton(
                        onPressed: () {
                          bloc.add(ButtonSwitchPageEvent(numOfPages: _introPageWidgetList.length));
                        },
                        child: Text(state < _introPageWidgetList.length ? Strings.next : Strings.finish),
                      );
                    }),
                  ),
                )
              ],
            )
          ],
        );
      }),
    );
  }

  void _onPageChanged({int? pagePosition, Bloc? bloc}) {
    //  bloc?.add(
    //    SwipeSwitchPageEvent(
    //      numOfPages: _introPageWidgetList.length,
    //      currentIndex: pagePosition ?? 0,
    //    ),
    //  );
  }
}

class PageWidget extends StatelessWidget {
  final String text;

  const PageWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const FlutterLogo(
            size: 300.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
