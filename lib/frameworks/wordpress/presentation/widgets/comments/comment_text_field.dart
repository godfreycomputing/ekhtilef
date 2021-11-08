import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../models/user_model.dart';
import '../../../../../screens/users/login_screen.dart';
import '../../../../../services/dependency_injection.dart';
import '../../../services/wordpress_service.dart';

class CommentInput extends StatefulWidget {
  final int blogId;

  const CommentInput({required this.blogId});

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final comment = TextEditingController();
  final _service = injector<WordPressService>();

  void sendComment() async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    var commentCreated = await _service.createComment(
      blogId: widget.blogId,
      content: comment.text,
      authorName:
          (userModel.user!.name != null) ? userModel.user!.name : 'Guest',
      authorAvatar: userModel.user!.picture ??
          'https://api.adorable.io/avatars/60/${userModel.user!.name ?? 'guest'}.png',
      userEmail: userModel.user!.email,
      date: DateTime.now().toIso8601String(),
    );
    if (mounted) {
      setState(() {
        comment.text = '';
      });
    }
    if (commentCreated) {
      final snackBar =
          SnackBar(content: Text(S.of(context).commentSuccessfully));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      const snackBar = SnackBar(content: Text('Comment fail'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  Widget _buildCommentSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: comment,
            maxLines: 2,
            decoration: InputDecoration(hintText: S.of(context).writeComment),
          ),
        ),
        GestureDetector(
          onTap: sendComment,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredLoginButton() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 32,
        maxHeight: 64,
        minWidth: 200,
        maxWidth: 320,
      ),
      height: 50.0,
      child: RawMaterialButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen(),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0.4,
        fillColor: Theme.of(context).buttonTheme.colorScheme!.primary,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).loginToComment,
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
      value: Provider.of<UserModel>(context),
      child: Consumer<UserModel>(
        builder: (context, model, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 40, top: 15.0),
            padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 5.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: model.user != null
                ? _buildCommentSection()
                : _buildRequiredLoginButton(),
          );
        },
      ),
    );
  }
}
