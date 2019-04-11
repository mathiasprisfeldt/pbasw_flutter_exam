import 'package:flutter/material.dart';

class TabsWidget extends StatefulWidget {
  final List<TabPage> pages;

  TabsWidget({Key key, @required this.pages}) : super(key: key);

  @override
  _TabsWidgetState createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> with TickerProviderStateMixin {
  static const _appBarHeight = kToolbarHeight - 8;

  TabPage _currPage;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.pages.length, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _currPage = widget.pages[_tabController.index];
      });
    });

    setState(() {
      _currPage = widget.pages[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight),
        child: AppBar(
          flexibleSpace: Container(
            alignment: Alignment.bottomCenter,
            child: TabBar(
              controller: _tabController,
              tabs: widget.pages
                  .map((page) => Tab(
                        icon: Icon(page._icon),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.pages.map((page) => page._widget).toList(),
      ),
      floatingActionButton: this._currPage.hasFab
          ? FloatingActionButton(
              onPressed: this._currPage.getFabOnPressed,
              child: Icon(this._currPage.fabIcon),
            )
          : null,
    );
  }
}

class TabPage {
  final IconData _icon;
  final TabPageWidget _widget;

  TabPage(this._icon, this._widget);

  get hasFab => _widget.onFabPressed != null;
  get fabIcon => _widget.fabIcon;

  get getFabOnPressed => hasFab
      ? () {
          _widget.onFabPressed.notifyListeners();
        }
      : null;
}

abstract class TabPageWidget extends StatefulWidget {
  final IconData fabIcon;
  final OnFabPressedEvent onFabPressed;

  TabPageWidget({Key key, this.fabIcon, this.onFabPressed}) : super(key: key);
}

class OnFabPressedEvent extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  @override
  bool get hasListeners => super.hasListeners;

  @override
  void addListener(listener) {
    super.addListener(listener);
  }
}
