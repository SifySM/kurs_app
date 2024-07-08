import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/data/remote/app_dio.dart';
import '../../../../common/data/repositories/book/book_repository.dart';

class BookDetailsRepository extends BookRepository {
  BookDetailsRepository(super.httpClient);

  Future<BookRepositoryData> getRelatedFeed(String url) {
    final String stripedUrl = url.replaceAll('https://catalog.feedbooks.com', '');
    final successOrFailure = getCategory(stripedUrl);
    return successOrFailure;
  }
}

final bookDetailsRepositoryProvider =
    Provider.autoDispose<BookDetailsRepository>((ref) {
  final dio = ref.watch(Provider<Dio>((ref) => AppDio.getInstance()));
  return BookDetailsRepository(dio);
});
