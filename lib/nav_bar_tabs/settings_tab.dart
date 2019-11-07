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
    PreferencesProvider preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
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
                child: Text('Theme'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Choose Theme'),
                  subtitle: Text('Choose which theme to be applied.'),
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return PickThemeDialog(preferencesProvider);
                        });
                  },
                ),
              ),
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
                child: Text('Quality'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    ListTile(
                      title: Text('Load'),
                      subtitle:
                          Text('Choose the images quality that are loaded.'),
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return PickQualityDialog(
                                preferencesProvider,
                                isLoadQuality: true,
                              );
                            });
                      },
                    ),
                    ListTile(
                      title: Text('Download'),
                      subtitle: Text(
                          'Choose the images quality that are downloaded.'),
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return PickQualityDialog(
                                preferencesProvider,
                                isLoadQuality: false,
                              );
                            });
                      },
                    ),
                  ],
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
                    ListTile(
                      title: Text('Logout'),
                      onTap: () => preferencesProvider.isLogedIn = false,
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

class PickThemeDialog extends StatefulWidget {
  final PreferencesProvider preferencesProvider;
  PickThemeDialog(this.preferencesProvider);
  @override
  _PickThemeDialogState createState() => _PickThemeDialogState();
}

class _PickThemeDialogState extends State<PickThemeDialog> {
  int _radioValue = 0;

  PreferencesProvider _preferencesProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preferencesProvider = widget.preferencesProvider;
    _radioValue = _preferencesProvider.theme;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RadioListTile(
              title: Text('Dark'),
              value: 0,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                  _preferencesProvider.theme = value;
                  Navigator.of(context).pop();
                });
              }),
          RadioListTile(
              title: Text('Light'),
              value: 1,
              groupValue: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                  _preferencesProvider.theme = value;
                  Navigator.of(context).pop();
                });
              }),
        ],
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

class PickQualityDialog extends StatefulWidget {
  final PreferencesProvider mainProvider;
  final bool isLoadQuality;
  PickQualityDialog(this.mainProvider, {this.isLoadQuality});
  @override
  _PickQualityDialogState createState() => _PickQualityDialogState();
}

class _PickQualityDialogState extends State<PickQualityDialog> {
  String _radioValue = 'Full';

  PreferencesProvider _mainProvider;

  _save(String quality) {
    if (widget.isLoadQuality) {
      _mainProvider.loadQuality = quality;
    } else {
      _mainProvider.downloadQuality = quality;
    }
  }

  List<String> options = [];
  List<String> downloadOptions = ['Raw', 'Full', 'Regular', 'Small'];
  List<String> loadOptions = ['Regular', 'Small'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainProvider = widget.mainProvider;
    _radioValue = widget.isLoadQuality == true
        ? _mainProvider.loadQuality
        : _mainProvider.downloadQuality;

    options = widget.isLoadQuality ? loadOptions : downloadOptions;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Quality'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.map((item) {
          return RadioListTile(
            title: Text(item),
            value: item,
            groupValue: _radioValue,
            onChanged: (val) {
              setState(() {
                _radioValue = val;
                _save(val);
                Navigator.of(context).pop();
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
