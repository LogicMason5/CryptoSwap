import 'package:flutter/material.dart';
import 'package:my_app/pages/swap_tokens.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:my_app/pages/current_price.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

  loginUsingMetamask(BuildContext context) {}
}

class _LoginPageState extends State<LoginPage> {
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  var _session, _uri;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          print(uri);
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Crypto Swap'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              height: 400.0,
              duration: Duration(seconds: 1),
              child: Image.asset('assets/images/app_icon3.png',
                  fit: BoxFit.fitWidth),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () => loginUsingMetamask(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Connect with Metamask'), // <-- Text
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      // <-- Icon
                      Icons.exit_to_app,
                      size: 24.0,
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 15),
                    fixedSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
            const SizedBox(height: 30),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SwapTokens()));
                },
                icon: Icon(Icons.swap_horiz),
                label: const Text("Swap Tokens"),
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 16),
                    fixedSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GetCurrentPrice()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Get Current Prices'), // <-- Text
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      // <-- Icon
                      Icons.price_check,
                      size: 24.0,
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 16),
                    fixedSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ],
        ),
      ),
    );
  }
}
