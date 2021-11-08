import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../common/constants.dart';
import '../services/services.dart';
import 'entities/blog.dart';

class BlogModel with ChangeNotifier {
  List<Blog>? blogList = [];

  final _service = Services();

  bool isFetching = false;
  bool? isEnd;
  dynamic categoryId;
  String? categoryName;
  String? errMsg;

  // Future<List<Blog>?> fetchBlogLayout(config, lang) async {
  //   return _service.fetchBlogLayout(config: config, lang: lang);
  //   // return Future.value();
  // }

  void setBlogNewsList(List<Blog>? blogs) {
    blogList = blogs ?? [];
    isFetching = false;
    isEnd = false;
    // notifyListeners();
  }

  void fetchBlogsByCategory({categoryId, categoryName}) {
    this.categoryId = categoryId;
    this.categoryName = categoryName;
    // notifyListeners();
  }

  Future<void> saveBlogs(Map<String, dynamic> data) async {
    final storage = LocalStorage('fstore');
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem(kLocalKey['home']!, data);
      }
    } catch (err) {
      printLog(err);
    }
  }

  Future<void> getBlogsList(
      {categoryId, minPrice, maxPrice, orderBy, order, lang, page}) async {
    try {
      printLog(categoryId);
      if (categoryId != null) {
        this.categoryId = categoryId;
      }
      isFetching = true;
      isEnd = false;
      // notifyListeners();

      final blogs = await _service.api.fetchBlogsByCategory(
          categoryId: categoryId, lang: lang, page: page, order: order);
      if (blogs.isEmpty) {
        isEnd = true;
      }

      if (page == 0 || page == 1) {
        blogList = blogs;
      } else {
        blogList = [...blogList!, ...blogs];
      }
      isFetching = false;
      notifyListeners();
    } catch (err) {
      errMsg = err.toString();
      isFetching = false;
      notifyListeners();
    }
  }

  void setBlogsList(List<Blog> blogs) {
    blogList = blogs;
    isFetching = false;
    isEnd = false;
    // notifyListeners();
  }
}
