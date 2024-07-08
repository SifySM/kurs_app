import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurs_app/startup/app_color.dart';

import '../../../../../common/domain/models/category_feed.dart';
import '../../components/description_text.dart';
import '../../notifier/book_details_notifier.dart';

@RoutePage()
class BookDetailsScreen extends ConsumerStatefulWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;

  const BookDetailsScreen({
    super.key,
    required this.entry,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
  });

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final autoRouteTopRoute = context.watchRouter.currentChild;
    final canPop = context.router.canPop();

    return Scaffold(
      appBar: AppBar(
        leading: !canPop && autoRouteTopRoute?.name == 'BookDetailsRoute'
            ? CloseButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,

      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 10.0),
          _BookDescriptionSection(
            entry: widget.entry,
            authorTag: widget.authorTag,
            imgTag: widget.imgTag,
            titleTag: widget.titleTag,
          ),
          const SizedBox(height: 30.0),
          const _SectionTitle(title: 'Book Description'),
          const CustomDivider(),
          const SizedBox(height: 10.0),
          DescriptionTextWidget(text: '${widget.entry.summary!.t}'),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColor.base);
  }
}

class BookDescriptionSection extends StatelessWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;

  const BookDescriptionSection({
    required this.entry,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag: imgTag,
          child: CachedNetworkImage(
            imageUrl: '${entry.link![1].href}',
            placeholder: (context, url) => const SizedBox(
              height: 200.0,
              width: 130.0,
              child: SizedBox(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.assessment_outlined),
            fit: BoxFit.cover,
            height: 200.0,
            width: 130.0,
          ),
        ),
        const SizedBox(width: 20.0),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5.0),
              Hero(
                tag: titleTag,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    entry.title!.t!.replaceAll(r'\', ''),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Hero(
                tag: authorTag,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    '${entry.author!.name!.t}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColor.base,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _MoreBooksFromAuthor extends ConsumerStatefulWidget {
  final String authorUrl;
  final Entry entry;

  const _MoreBooksFromAuthor({
    required this.authorUrl,
    required this.entry,
  });

  @override
  ConsumerState<_MoreBooksFromAuthor> createState() =>
      _MoreBooksFromAuthorState();
}

class _MoreBooksFromAuthorState extends ConsumerState<_MoreBooksFromAuthor> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookDetailsNotifierProvider(widget.authorUrl).notifier).fetch();
    });
  }

  @override
  void didUpdateWidget(covariant _MoreBooksFromAuthor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authorUrl != widget.authorUrl) {
      _fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(bookDetailsNotifierProvider(widget.authorUrl)).maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const SizedBox(),
          data: (related) {
            if (related.feed!.entry == null || related.feed!.entry!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Empty',
                  ),
                ),
              );
            }
            final entries = related.feed!.entry!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: related.feed!.entry!.length,
              itemBuilder: (BuildContext context, int index) {
                final entry = entries[index];
                final isSingleEntry = entries.length == 1;
                if (entry.id!.t == widget.entry.id!.t && isSingleEntry) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Text(
                        "oops, there's no other book from this author available",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (entry.id!.t == widget.entry.id!.t) {
                  return const SizedBox
                      .shrink();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SizedBox()
                      // BookListItem(entry: entry),
                  );
                }
              },
            );
          },
          error: (_, __) {
            return const Text('Error');
          },
        );
  }
}
