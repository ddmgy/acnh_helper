import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import 'package:acnh_helper/utils.dart';

class ChangelogScreen extends StatefulWidget {
  Future<String> get data async => rootBundle.loadString("CHANGELOG.md");
  @override
  State<StatefulWidget> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        "Changelog",
        style: context.titleTextStyle(),
      ),
    ),
    body: Center(
      child: FutureBuilder<String>(
        future: widget.data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: context.titleTextStyle(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final h1Style = context.titleTextStyle(fontSize: 20);
          final h2Style = context.titleTextStyle(fontSize: 18);
          final h3Style = context.titleTextStyle(fontSize: 16);
          final mainTextStyle = context.subtitleTextStyle();

          return Scrollbar(
            child: Markdown(
              data: snapshot.data,
              styleSheet: MarkdownStyleSheet(
                h1: h1Style,
                h2: h2Style,
                h3: h3Style,
                p: mainTextStyle,
                listBullet: mainTextStyle,
              ),
              extensionSet: md.ExtensionSet.commonMark,
              onTapLink: (text, href, title) => _showLinkDialog(
                context,
                text,
                href,
                title,
              ),
            ),
          );
        },
      ),
    ),
  );

  void _showLinkDialog(BuildContext context, String text, String href, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Link",
          style: context.titleTextStyle(),
        ),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "See the following link for more information:",
              style: context.subtitleTextStyle(fontSize: 13),
            ),
            SizedBox(height: 8),
            Text(
              "Link text: $text",
              style: context.subtitleTextStyle(),
            ),
            SizedBox(height: 8),
            Text(
              "Link destination: $href",
              style: context.subtitleTextStyle(),
            ),
            SizedBox(height: 8),
            Text(
              "Link title: $title",
              style: context.subtitleTextStyle(),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text(
              "Follow link",
              style: context.subtitleTextStyle(),
            ),
            onPressed: () async {
              if (await canLaunch(href)) {
                await launch(href);
              } else {
                final scaffoldState = ScaffoldMessenger.of(context);
                scaffoldState.removeCurrentSnackBar();
                scaffoldState.showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).cardColor,
                  content: Text(
                    "Unable to open link: $href",
                    style: context.titleTextStyle(),
                  ),
                ));
              }
            },
          ),
          FlatButton(
            child: Text(
              "OK",
              style: context.subtitleTextStyle(),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}