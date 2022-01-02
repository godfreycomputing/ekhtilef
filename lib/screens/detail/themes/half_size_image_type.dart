import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../models/index.dart' show CartModel, Product, ProductModel;
import '../../cart/cart_screen.dart';
import '../product_detail_screen.dart';
import '../widgets/index.dart';

class HalfSizeLayout extends StatefulWidget {
  final Product? product;
  final bool isLoading;

  const HalfSizeLayout({this.product, this.isLoading = false});

  @override
  _HalfSizeLayoutState createState() => _HalfSizeLayoutState();
}

class _HalfSizeLayoutState extends State<HalfSizeLayout>
    with SingleTickerProviderStateMixin {
  Map<String, String> mapAttribute = HashMap();
  late final PageController _pageController = PageController();
  late final RubberAnimationController _controller;
  //final ScrollController _scrollController = ScrollController();

  var top = 0.0;
  var opacityValue = 0.9;

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        initialValue: 0.4,
        //lowerBoundValue: AnimationControllerValue(percentage: 0.15),
        halfBoundValue: AnimationControllerValue(percentage: 0.45),
        upperBoundValue: AnimationControllerValue(percentage: 0.7),
        duration: const Duration(milliseconds: 200));
    _controller.animationState.addListener(_stateListener);
    super.initState();
  }

  void _stateListener() {
    setState(() {
      opacityValue =
          _controller.animationState.value == AnimationState.collapsed
              ? 0.3
              : 0.9;
    });
  }

  Widget _getLowerLayer({width, height}) {
    final _height = height ?? MediaQuery.of(context).size.height;
    final _width = width ?? MediaQuery.of(context).size.width;
    //var totalCart = Provider.of<CartModel>(context).totalCartQuantity;

    return Material(
        // //HLOPACarousel
        //  SingleChildScrollView(
        //     controller: _scrollController,
        //     //physics: const NeverScrollableScrollPhysics(),
        child: Container(
      height: MediaQuery.of(context).size.height * .58,
      child: Stack(
        children: <Widget>[
          if (widget.product?.imageFeature != null)
            Positioned(
              top: 0,
              child: SizedBox(
                width: _width,
                height: _height,
                child: PageView(
                  //scrollDirection: Axis.vertical,
                  allowImplicitScrolling: true,
                  controller: _pageController,
                  children: [
                    Image.network(
                      widget.product?.imageFeature ?? '',
                      fit: BoxFit.fitHeight,
                    ),
                    for (var i = 1;
                        i < (widget.product?.images.length ?? 0);
                        i++)
                      Image.network(
                        widget.product?.images[i] ?? '',
                        fit: BoxFit.fitHeight,
                      ),
                  ],
                ),
              ),
            ),
          if (widget.product?.imageFeature != null)
            Positioned(
              top: 20,
              left: 0,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 22,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Provider.of<ProductModel>(context, listen: false)
                        .changeProductVariation(null);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          // Positioned(
          //   top: 30,
          //   right: 4,
          //   child: IconButton(
          //     icon: const Icon(Icons.more_vert),
          //     onPressed: () => ProductDetailScreen.showMenu(
          //         context, widget.product,
          //         isLoading: widget.isLoading),
          //   ),
          // ),
          // Positioned(
          //   top: 30,
          //   right: 40,
          //   child: IconButton(
          //       icon: const Icon(
          //         Icons.shopping_cart,
          //         size: 22,
          //       ),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute<void>(
          //             builder: (BuildContext context) => Scaffold(
          //               backgroundColor: Theme.of(context).backgroundColor,
          //               body: const CartScreen(isModal: true),
          //             ),
          //             fullscreenDialog: true,
          //           ),
          //         );
          //       }),
          // ),
          // Positioned(
          //   top: 36,
          //   right: 44,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       borderRadius: BorderRadius.circular(9),
          //     ),
          //     constraints: const BoxConstraints(
          //       minWidth: 18,
          //       minHeight: 18,
          //     ),
          //     child: Text(
          //       totalCart.toString(),
          //       style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontWeight: FontWeight.w600),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // )
/** image index indicator*/
          Positioned(
            top: MediaQuery.of(context).size.height * .55,
            right: MediaQuery.of(context).size.width * .45,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.product?.images.length ?? 0,
              effect: const JumpingDotEffect(
                offset: 20,
                dotWidth: 8.0,
                dotHeight: 8.0,
                spacing: 15.0,
                //fixedCenter: true,
                dotColor: Colors.white60,
                activeDotColor: Colors.white,
                //paintStyle: PaintingStyle.stroke
              ),
            ),
          ),
          /** image index indicator*/

          //
        ],
      ),
    ));
  }

  Widget _getUpperLayer({width}) {
    final _width = width ?? MediaQuery.of(context).size.width;

    return Material(
        color: Colors.transparent,
        child: Container(
          width: _width,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, -2), blurRadius: 20),
            ],
          ),
          child: Container(
            //padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .backgroundColor /**.withOpacity(opacityValue) */,
            ),
            //borderRadius: BorderRadius.circular(10.0)),
            child: ChangeNotifierProvider(
              create: (_) => ProductModel(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /** image index indicator*/
                    ProductTitle(widget.product),
                    ProductDescription(widget.product),
                    
                    //ProductVariant(widget.product),
                    //RelatedProduct(widget.product),
                    // const SizedBox(
                    //   height: 100,
                    // )
                    const SizedBox(height: 50,)
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // floatingActionButton: ProductVariant(widget.product),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: SingleChildScrollView(
        child:  Column(children: [
          // Align(
          //   alignment: FractionalOffset.topCenter,
          //   child:ProductVariant(widget.product)),
          //return RubberBottomSheet(
          //lowerLayer:

          _getLowerLayer(width: size.width, height: size.height * .6),
          _getUpperLayer(width: size.width),
          //upperLayer:

          /// animationController: _controller,
          //scrollController: _scrollController,
        ])),
      
      floatingActionButton: bottomSheet(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
//       );
  }

  Widget bottomSheet() {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(.6),
                Colors.white,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        height: 70,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: ProductVariant(widget.product)));
  }
}

// Scaffold(
//       floatingActionButton: ProductVariant(widget.product),
//       //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body:
