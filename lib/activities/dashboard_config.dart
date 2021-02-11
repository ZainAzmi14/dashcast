import 'package:flutter/material.dart';
import 'package:cast/cast.dart';

class DashActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cast Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: testPage(),
      ),
    );
  }
}

class testPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<testPage> {
  @override
  void initState() {
    super.initState();
    CastDiscoveryService().start();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CastDevice>>(
      stream: CastDiscoveryService().stream,
      initialData: CastDiscoveryService().devices,
      builder: (context, snapshot) {
        return Column(
          children: snapshot.data.map((device) {
            return ListTile(
              title: Text(device.name),
              onTap: () {
                _connect(context, device);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _connect(BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text('Connected'));
        Scaffold.of(context).showSnackBar(snackBar);

        _sendMessage(session);
      }
    });

    session.messageStream.listen((message) {
      print('receive message: $message');
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'YouTube', // set the appId of your app here
    });
  }

  void _sendMessage(CastSession session) {
    session.sendMessage('urn:x-cast:namespace-of-the-app', {
      'type': 'sample',
    });
  }
}
