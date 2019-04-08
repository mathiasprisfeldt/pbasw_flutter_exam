import 'package:flutter/material.dart';

class TabsWidget extends StatefulWidget {
  final List<TabPage> pages;

  TabsWidget({Key key, @required this.pages}) : super(key: key);

  @override
  _TabsWidgetState createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.pages.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          bottom: TabBar(
            tabs: widget.pages
                .map((page) => Tab(
                      icon: Icon(page._icon),
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: widget.pages.map((page) => page._widget).toList(),
        ),
      ),
    );
  }
}

class TabPage {
  final IconData _icon;
  final Widget _widget;

  TabPage(IconData icon, Widget widget)
      : this._icon = icon,
        this._widget = widget;
}
