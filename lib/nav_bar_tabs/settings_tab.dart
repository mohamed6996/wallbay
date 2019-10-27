import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallbay/bloc/pref_provider.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Layout'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Choose Layout'),
                  subtitle: Text('Choose how images are displayed.'),
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return PickTypeDialog(preferencesProvider);
                        });
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Collection'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Default Collection'),
                  subtitle: Text('Choose which collection to show.'),
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return CollectionType(preferencesProvider);
                        });
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('About'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      title: Text('Recommend'),
                      subtitle: Text('Share this app with friends and family.'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Rate app'),
                      subtitle:
                          Text('Leave an honest review on Google Play Store.'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Feedback'),
                      subtitle: Text(
                          'Tell me what do you think and help me to improve the app.'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PickTypeDialog extends StatefulWidget {
  final PreferencesProvider mainProvider;
  PickTypeDialog(this.mainProvider);
  @override
  _PickTypeDialogState createState() => _PickTypeDialogState();
}

class _PickTypeDialogState extends State<PickTypeDialog> {
  int _radioValue = 0;

  PreferencesProvider _mainProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainProvider = widget.mainProvider;
    _radioValue = _mainProvider.layoutType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Layout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RadioListTile(
              title: Text('List'),
              value: 0,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                  _mainProvider.layoutType = value;
                  //  SharedPrefs.saveLayout(value);
                  Navigator.of(context).pop();
                });
              }),
          RadioListTile(
              title: Text('Grid'),
              value: 1,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                  _mainProvider.layoutType = value;
                  //  SharedPrefs.saveLayout(value);
                  Navigator.of(context).pop();
                });
              }),
          RadioListTile(
              title: Text('Staggered'),
              value: 2,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                  _mainProvider.layoutType = value;
                  //SharedPrefs.saveLayout(value);
                  Navigator.of(context).pop();
                });
              }),
        ],
      ),
    );
  }
}

class CollectionType extends StatefulWidget {
  final PreferencesProvider mainProvider;
  CollectionType(this.mainProvider);
  @override
  _CollectionTypeState createState() => _CollectionTypeState();
}

class _CollectionTypeState extends State<CollectionType> {
  int _radioValue = 0;
  PreferencesProvider _mainProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainProvider = widget.mainProvider;
    _radioValue = _mainProvider.collectionType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Show me'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RadioListTile(
              title: Text('All'),
              value: 0,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                  _mainProvider.collectionType = value;
                  //SharedPrefs.saveCollection(value);
                  Navigator.of(context).pop();
                });
              }),
          RadioListTile(
              title: Text('Wallpaper'),
              value: 1,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                  _mainProvider.collectionType = value;
                  // SharedPrefs.saveCollection(value);
                  Navigator.of(context).pop();
                });
              }),
        ],
      ),
    );
  }
}
