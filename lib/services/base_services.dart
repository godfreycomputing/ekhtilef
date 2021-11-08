import 'dart:async';
import 'dart:convert';

import 'package:http_auth/http_auth.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../models/comment.dart';
import '../models/entities/brand.dart';
import '../models/entities/listing_booking.dart';
import '../models/entities/order_delivery_date.dart';
import '../models/entities/paging_response.dart';
import '../models/entities/prediction.dart';
import '../models/entities/vacation_settings.dart';
import '../models/index.dart';
import '../models/vendor/store_model.dart';
import 'wordpress/blognews_api.dart';

export '../models/entities/paging_response.dart';

abstract class BaseServices {
  final BlogNewsApi blogApi;

  final String domain;

  BaseServices({
    required this.domain,
    String? blogDomain,
  }) : blogApi = BlogNewsApi(blogDomain ?? domain);

  Future<List<Category>?>? getCategories({lang}) async => const <Category>[];

  Future<List<Product>>? getProducts({userId}) => null;

  Future<List<Product>?> fetchProductsLayout(
          {required config, lang, userId}) async =>
      const <Product>[];

  Future<List<Product>?> fetchProductsByCategory({
    categoryId,
    tagId,
    required page,
    minPrice,
    maxPrice,
    orderBy,
    lang,
    order,
    featured,
    onSale,
    attribute,
    attributeTerm,
    listingLocation,
    userId,
  }) async =>
      const <Product>[];

  Future<User?>? loginFacebook({String? token}) => null;

  Future<User>? loginSMS({String? token}) => null;

  Future<bool> isUserExisted({String? phone, String? username}) async => true;

  Future<User?>? loginApple({String? token}) => null;

  Future<User?>? loginGoogle({String? token}) => null;

  Future<List<Review>>? getReviews(productId) => null;

  Future<List<ProductVariation>?>? getProductVariations(Product product,
          {String? lang}) =>
      null;

  Future<List<ShippingMethod>>? getShippingMethods(
          {CartModel? cartModel,
          String? token,
          String? checkoutId,
          Store? store}) =>
      null;

  Future<List<PaymentMethod>>? getPaymentMethods({
    CartModel? cartModel,
    ShippingMethod? shippingMethod,
    String? token,
  }) =>
      null;

  Future<Order>? createOrder({
    CartModel? cartModel,
    UserModel? user,
    bool? paid,
    String? transactionId,
  }) =>
      null;

  Future<PagingResponse<Order>>? getMyOrders({
    User? user,
    dynamic cursor,
  }) =>
      null;

  Future? updateOrder(orderId, {status, required token}) => null;

  Future<Order?>? cancelOrder({
    required Order? order,
    required String? userCookie,
  }) =>
      null;

  Future<PagingResponse<Product>>? searchProducts({
    name,
    categoryId,
    categoryName,
    tag,
    attribute,
    attributeId,
    required page,
    lang,
    listingLocation,
    userId,
  }) =>
      null;

  Future<User?>? getUserInfo(cookie) => null;

  Future<User?>? createUser({
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    String? phoneNumber,
    bool isVendor = false,
  }) =>
      null;

  Future<Map<String, dynamic>?>? updateUserInfo(
          Map<String, dynamic> json, String? token) =>
      null;

  Future<User?>? login({
    username,
    password,
  }) =>
      null;

  Future<Product?>? getProduct(id, {lang}) => null;

  Future<Coupons>? getCoupons({int page = 1}) => null;

  Future<List<OrderNote>>? getOrderNote({
    String? userId,
    String? orderId,
  }) =>
      null;

  Future? createReview(
          {String? productId, Map<String, dynamic>? data, String? token}) =>
      null;

  Future<Map<String, dynamic>?>? getHomeCache(String? lang) => null;

  Future<List<Blog>?> fetchBlogLayout({required config, lang}) async {
    try {
      var list = <Blog>[];
      var endPoint = 'posts?_embed';
      if (kAdvanceConfig['isMultiLanguages'] ?? false) {
        endPoint += '&lang=$lang';
      }
      if (config.containsKey('category')) {
        endPoint += "&categories=${config["category"]}";
      }
      if (config.containsKey('limit')) {
        endPoint += "&per_page=${config["limit"] ?? 20}";
      }
      if (config.containsKey('page')) {
        endPoint += "&page=${config["page"]}";
      }

      var response = await blogApi.getAsync(endPoint);

      if (response != null) {
        for (var item in response) {
          list.add(Blog.fromJson(item));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<Blog> getPageById(int? pageId) async {
    var response = await blogApi.getAsync('pages/$pageId?_embed');
    return Blog.fromJson(response);
  }

  Future? getCategoryWithCache() => null;

  Future<List<FilterAttribute>>? getFilterAttributes() => null;

  Future<List<SubAttribute>>? getSubAttributes({int? id}) => null;

  Future<List<FilterTag>>? getFilterTags() => null;

  Future<String>? getCheckoutUrl(Map<String, dynamic> params, String? lang) =>
      null;

  Future<String?>? submitForgotPassword({
    String? forgotPwLink,
    Map<String, dynamic>? data,
  }) =>
      null;

  Future? logout() => null;

  Future? checkoutWithCreditCard(String? vaultId, CartModel cartModel,
      Address address, PaymentSettingsModel paymentSettingsModel) {
    return null;
  }

  Future<PaymentSettings>? getPaymentSettings() {
    return null;
  }

  Future<PaymentSettings>? addCreditCard(
      PaymentSettingsModel paymentSettingsModel,
      CreditCardModel creditCardModel) {
    return null;
  }

  Future<Map<String, dynamic>?>? getCurrencyRate() => null;

  Future<List<dynamic>?>? getCartInfo(String? token) => null;

  Future? syncCartToWebsite(CartModel cartModel, User? user) => null;

  Future<Map<String, dynamic>>? getCustomerInfo(String? id) => null;

  Future<Map<String, dynamic>?>? getTaxes(CartModel cartModel) => null;

  Future<Map<String, Tag>>? getTags({String? lang}) => null;

  Future? getCountries() => null;

  Future? getStatesByCountryId(countryId) => null;

  Future<Point?>? getMyPoint(String? token) => null;

  Future? updatePoints(String? token, Order? order) => null;

  //For vendor
  Future<Store?>? getStoreInfo(storeId) => null;

  Future<bool>? pushNotification(
    cookie, {
    receiverEmail,
    senderName,
    message,
  }) =>
      null;

  Future<List<Review>>? getReviewsStore({storeId, page, perPage}) => null;

  Future<List<Product>>? getProductsByStore(
          {storeId,
          int? page,
          int? perPage,
          int? catId,
          bool? onSale,
          String? order,
          String? orderBy,
          String? searchTerm,
          String lang = 'en'}) =>
      null;

  Future<List<Store>>? searchStores({
    String? keyword,
    int? page,
  }) =>
      null;

  Future<List<Store>>? getFeaturedStores() => null;

  Future<PagingResponse<Order>>? getVendorOrders({
    required User user,
    dynamic cursor,
  }) =>
      null;

  Future<Product>? createProduct(String? cookie, Map<String, dynamic> data) =>
      null;

  Future<List<Product>>? getOwnProducts(
    String? cookie, {
    int? page,
    int? perPage,
  }) =>
      null;

  Future<dynamic>? uploadImage(dynamic data, String? token) => null;

  Future<List<Prediction>>? getAutoCompletePlaces(
          String term, String? sessionToken) =>
      null;

  Future<Prediction>? getPlaceDetail(
          Prediction prediction, String? sessionToken) =>
      null;

  Future<List<Store>>? getNearbyStores(Prediction prediction,
          {int page = 1, int perPage = 10, int radius = 10, String? name}) =>
      null;

  Future<Product?> getProductByPermalink(String productPermalink) async {}

  Future<Category?> getProductCategoryByPermalink(
      String productCategoryPermalink) async {}

  Future<Store?> getStoreByPermalink(String storePermaLink) async {}

  Future<Blog?> getBlogByPermalink(String blogPermaLink) async {}

  Future<List<Brand>?> getBrands() async => null;

  Future<List<Product>?> fetchProductsByBrand(
          {dynamic page, String? lang, String? brandId}) async =>
      null;

  ///----FLUXSTORE LISTING----///
  Future<dynamic>? bookService({userId, value, message}) => null;

  Future<List<Product>>? getProductNearest(location) => null;

  Future<List<ListingBooking>>? getBooking({userId, page, perPage}) => null;

  Future<Map<String, dynamic>?>? checkBookingAvailability({data}) => null;

  Future<List<dynamic>>? getLocations() => null;

  /// BOOKING FEATURE
  Future<bool>? createBooking(dynamic bookingInfo) => null;

  Future<List<dynamic>>? getListStaff(String? idProduct) => null;

  Future<List<String>>? getSlotBooking(
          String? idProduct, String idStaff, String date) =>
      null;

  Future<PagingResponse<Blog>>? getBlogs(dynamic cursor) async {
    try {
      final param = '_embed&page=$cursor';
      final response =
          await httpGet('${blogApi.url}/wp-json/wp/v2/posts?$param'.toUri()!);
      if (response.statusCode != 200) {
        return const PagingResponse();
      }
      List data = jsonDecode(response.body);
      return PagingResponse(data: data.map((e) => Blog.fromJson(e)).toList());
    } on Exception catch (_) {
      return const PagingResponse();
    }
  }

  /// RAZORPAY PAYMENT
  Future<String?> createRazorpayOrder(params) async {
    try {
      var client = BasicAuthClient(
          kRazorpayConfig['keyId'], kRazorpayConfig['keySecret']);
      final response = await client
          .post('https://api.razorpay.com/v1/orders'.toUri()!, body: params);
      final responseJson = jsonDecode(response.body);
      if (responseJson != null && responseJson['id'] != null) {
        return responseJson['id'];
      } else if (responseJson['message'] != null) {
        throw responseJson['message'];
      } else {
        throw "Can't create order for Razorpay";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderIdForRazorpay(paymentId, orderId) async {
    try {
      final token = base64.encode(latin1.encode(
          '${kRazorpayConfig['keyId']}:${kRazorpayConfig['keySecret']}'));

      final body = {
        'notes': {'woocommerce_order_id': orderId}
      };
      await httpPatch(
          'https://api.razorpay.com/v1/payments/$paymentId'.toUri()!,
          headers: {
            'Authorization': 'Basic ' + token.trim(),
            'Content-Type': 'application/json'
          },
          body: json.encode(body));
    } catch (e) {
      return;
    }
  }

  Future<List<Blog>> searchBlog({required String name}) async => const <Blog>[];

  Future<List<Blog>> fetchBlogsByCategory(
          {categoryId, page, lang, order = 'desc'}) async =>
      <Blog>[];

  Future<List<Comment>?> getCommentsByPostId({postId}) async {}

  Future<Blog> getBlogById(dynamic id) async {
    final response =
        await httpGet('${blogApi.url}/wp-json/wp/v2/posts/$id?_embed'.toUri()!);
    return jsonDecode(response.body);
  }

  Future<List<Category>> getCategoriesByPage(
          {lang, page, limit, storeId}) async =>
      [];

  Future<List<OrderDeliveryDate>> getListDeliveryDates() async =>
      <OrderDeliveryDate>[];

  Future<Category?> getProductCategoryById(
          {required String categoryId}) async =>
      null;
  Future<VacationSettings?> getVacationSettings(String storeId) async => null;

  Future<bool?> setVacationSettings(
          String cookie, VacationSettings vacationSettings) async =>
      null;
}
