import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../common/constants.dart';
import 'entities/blog.dart';

class BlogWishListModel extends ChangeNotifier {
  BlogWishListModel() {
    getLocalWishlist();
  }

  List<Blog> blogs = [];

  List<Blog> getWishList() => blogs;

  final keyData = LocalStorageKey.blogWishList;

  final storage = LocalStorage('fstore');

  void addToWishlist(Blog blog) {
    blogs.add(blog);
    saveWishlist(blogs);
    notifyListeners();
  }

  void removeToWishlist(Blog blog) {
    blogs.removeWhere((item) => item.id == blog.id);
    saveWishlist(blogs);
    notifyListeners();
  }

  void saveWishlist(List<Blog> blogs) async {
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem(keyData, blogs);
      }
    } catch (err) {
      printLog(err);
    }
  }

  void getLocalWishlist() async {
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem(keyData);

        if (json != null) {
          var list = <Blog>[];
          for (var item in json) {
            list.add(Blog.fromJson(item));
          }

          blogs = list;
        }
      }
    } catch (err) {
      printLog(err);
    }
  }
}
