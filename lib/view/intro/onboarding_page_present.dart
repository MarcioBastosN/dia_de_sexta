import 'package:dia_de_sexta/controller/controller_intro_screen.dart';
import 'package:dia_de_sexta/model/onboarding_page_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  ControllerIntroScreen splashController = ControllerIntroScreen();

  @override
  void initState() {
    splashController.getLoadSplash();

    if (splashController.loadSplash.value) {
      widget.onFinish?.call();
    }

    super.initState();
  }

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[splashController.currentPage.value].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    splashController.updateCurrentPage(page: idx);
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            // child: Image.network(item.imageUrl),
                            child: Lottie.asset(item.imageUrl),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  item.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: item.textColor,
                                      ),
                                ),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: item.textColor),
                                ),
                              )
                            ]))
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              GetX<ControllerIntroScreen>(
                init: splashController,
                builder: (_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.pages
                        .map((item) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: splashController.currentPage.value ==
                                      widget.pages.indexOf(item)
                                  ? 30
                                  : 8,
                              height: 8,
                              margin: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          splashController.updateLoadSplash(newValue: true);
                          widget.onSkip?.call();
                        },
                        child: const Text("pular")),
                    TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: () {
                        if (splashController.currentPage.value ==
                            widget.pages.length - 1) {
                          splashController.updateLoadSplash(newValue: true);
                          widget.onFinish?.call();
                        } else {
                          _pageController.animateToPage(
                              splashController.currentPage.value + 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 250));
                        }
                      },
                      child: GetX<ControllerIntroScreen>(
                        init: splashController,
                        builder: (_) {
                          return Row(
                            children: [
                              Text(
                                splashController.currentPage.value ==
                                        widget.pages.length - 1
                                    ? "Finish"
                                    : "proximo",
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                splashController.currentPage.value ==
                                        widget.pages.length - 1
                                    ? Icons.done
                                    : Icons.arrow_forward,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
