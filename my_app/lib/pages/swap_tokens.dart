import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/constants.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class SwapTokens extends StatefulWidget {
  const SwapTokens({super.key});

  @override
  State<SwapTokens> createState() => _SwapTokensState();
}

class _SwapTokensState extends State<SwapTokens> {
  Client? httpClient;
  Web3Client? ethClient;
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(sepolia_infura_url, httpClient!);
    super.initState();
  }

  Future<DeployedContract> loadContract1() async {
    String abi = await rootBundle.loadString('assets/abi/st_abi.json');
    String contractAddress = swapTokenAddress;
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'SwapTokens'),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<DeployedContract> loadContract2() async {
    String abi = await rootBundle.loadString('assets/abi/get_bal.json');
    String contractAddress = getBalanceContractAddress;
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'TokenBalance'),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> callFunctionfromst(String funcName, List<dynamic> args,
      Web3Client ethClient, String privateKey) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await loadContract1();
    final ethFunction = contract.function(funcName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        chainId: null,
        fetchChainIdFromNetworkId: true);

    return result;
  }

  Future<List<dynamic>> ask(
      String funcName, List<dynamic> args, Web3Client ethClient) async {
    final contract = await loadContract2();
    final ethFunction = contract.function(funcName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: [args[0], args[1]]);
    return result;
  }

  late String acc1;
  late String acc2;
  late String tok1;
  late String tok2;
  late BigInt amount1;
  late BigInt amount2;
  String gldbal1 = "";
  String slvbal1 = "";
  String gldbal2 = "";
  String slvbal2 = "";
  bool isLoading1 = false;
  bool isLoading2 = false;

  Future<List<dynamic>> getBalance(
      String tok, String acc, Web3Client ethClient) async {
    List<dynamic> result = await ask(
        'getTokenBalance',
        [EthereumAddress.fromHex(tok), EthereumAddress.fromHex(acc)],
        ethClient);
    return result;
  }

  void showSuccessMessage() {
    Fluttertoast.showToast(
        msg: "Swapped Tokens successfully!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void incompleteDetails() {
    Fluttertoast.showToast(
        msg: "Please enter valid addresses!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  TextEditingController mycontroller1 = TextEditingController();
  TextEditingController mycontroller2 = TextEditingController();
  TextEditingController mycontroller3 = TextEditingController();
  TextEditingController mycontroller4 = TextEditingController();
  TextEditingController mycontroller5 = TextEditingController();
  TextEditingController mycontroller6 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swap Tokens"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(5, 5, 15, 5)),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/metamask_small.png',
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('Open Metamask'),
                        ],
                      ),
                      onPressed: () async => {
                        await LaunchApp.openApp(
                          androidPackageName: 'io.metamask',
                        )
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 40,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: Colors.white,
                        disabledColor: Color.fromARGB(255, 71, 58, 51),
                        onPressed: null,
                        child: Text(
                          "Owner 1",
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: mycontroller1,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(11),
                          border: OutlineInputBorder(),
                          labelText: 'Enter Account 1 Address',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 40,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: Colors.white,
                        disabledColor: Color.fromARGB(255, 71, 58, 51),
                        onPressed: null,
                        child: Text(
                          "Token 1",
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: mycontroller2,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(11),
                          border: OutlineInputBorder(),
                          labelText: 'Enter Token 1 Address',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 40,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: Colors.white,
                        disabledColor: Color.fromARGB(255, 71, 58, 51),
                        onPressed: null,
                        child: Text(
                          "Owner 2",
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: mycontroller3,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(11),
                          border: OutlineInputBorder(),
                          labelText: 'Enter Account 2 Address',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 40,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: Colors.white,
                        disabledColor: Color.fromARGB(255, 71, 58, 51),
                        onPressed: null,
                        child: Text(
                          "Token 2",
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: mycontroller4,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(11),
                          border: OutlineInputBorder(),
                          labelText: 'Enter Token 2 Address',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 40,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: Colors.white,
                        disabledColor: Color.fromARGB(255, 71, 58, 51),
                        onPressed: null,
                        child: Text(
                          "GOLD",
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: mycontroller5,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(11),
                          border: OutlineInputBorder(),
                          labelText: 'Enter no of GOLD tokens',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      height: 40,
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: Colors.white,
                        disabledColor: Color.fromARGB(255, 71, 58, 51),
                        onPressed: null,
                        child: Text(
                          "SILVER",
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: mycontroller6,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(11),
                          border: OutlineInputBorder(),
                          labelText: 'Enter no of SILVER tokens',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                  //style: Color,
                  child: const Text('Swap Tokens'),

                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 17),
                    elevation: 3,
                    minimumSize: const Size(100, 40), //////// HERE
                  ),
                  onPressed: () async {
                    acc1 = mycontroller1.text;
                    tok1 = mycontroller2.text;
                    acc2 = mycontroller3.text;
                    tok2 = mycontroller4.text;
                    if (acc1.length == 0 ||
                        acc2.length == 0 ||
                        tok1.length == 0 ||
                        tok2.length == 0) {
                      incompleteDetails();
                    }
                    amount1 = BigInt.parse(mycontroller5.text) *
                        BigInt.from(pow(10, 18));
                    amount2 = BigInt.parse(mycontroller6.text) *
                        BigInt.from(pow(10, 18));
                    print(acc1);
                    print(acc2);
                    print(amount1);
                    print(amount2);
                    callFunctionfromst(
                        'swap',
                        [
                          EthereumAddress.fromHex(tok1),
                          EthereumAddress.fromHex(acc1),
                          EthereumAddress.fromHex(tok2),
                          EthereumAddress.fromHex(acc2),
                          amount1,
                          amount2
                        ],
                        ethClient!,
                        owner_private_key);
                    showSuccessMessage();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(0)),
                        SizedBox(
                          width: 160,
                          child: CupertinoButton(
                            minSize: 0,
                            pressedOpacity: 1.0,
                            padding: EdgeInsets.all(10),
                            color: Color.fromARGB(255, 115, 84, 188),
                            onPressed: () async {
                              setState(() {
                                isLoading1 = true;
                              });
                              await Future.delayed(const Duration(seconds: 1));
                              acc1 = mycontroller1.text;
                              tok1 = mycontroller2.text;
                              tok2 = mycontroller4.text;
                              if (acc1.length == 0 ||
                                  tok1.length == 0 ||
                                  tok2.length == 0) {
                                setState(() {
                                  isLoading1 = false;
                                });
                                incompleteDetails();
                              }
                              //DeployedContract contract1 = await loadContract1();
                              //var _token1 = await contract1.functions.token1.call();
                              var res1 =
                                  await getBalance(tok1, acc1, ethClient!);
                              BigInt bigint1 = BigInt.from(
                                  res1[0] / BigInt.from(pow(10, 18)));
                              var res2 =
                                  await getBalance(tok2, acc1, ethClient!);
                              BigInt bigint2 = BigInt.from(
                                  res2[0] / BigInt.from(pow(10, 18)));
                              setState(() {
                                gldbal1 = '$bigint1';
                                slvbal2 = '$bigint2';
                                isLoading1 = false;
                              });
                              print(gldbal1);
                              print(slvbal2);
                            },
                            child: const Text(
                              "Account 1 balance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: !isLoading1
                                ? Column(
                                    children: [
                                      Text(
                                        'GOLD : $gldbal1',
                                        style: const TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'SILVER : $slvbal2',
                                        style: const TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                : const CircularProgressIndicator()),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(padding: EdgeInsets.all(0)),
                        SizedBox(
                          width: 160,
                          child: CupertinoButton(
                            minSize: 0,
                            pressedOpacity: 1.0,
                            padding: EdgeInsets.all(10),
                            color: Color.fromARGB(255, 115, 84, 188),
                            onPressed: () async {
                              setState(() {
                                isLoading2 = true;
                              });
                              await Future.delayed(const Duration(seconds: 2));
                              acc2 = mycontroller3.text;
                              tok1 = mycontroller2.text;
                              tok2 = mycontroller4.text;
                              if (acc2.length == 0 ||
                                  tok1.length == 0 ||
                                  tok2.length == 0) {
                                setState(() {
                                  isLoading2 = false;
                                });
                                incompleteDetails();
                              }
                              var res1 =
                                  await getBalance(tok2, acc2, ethClient!);
                              BigInt bigint1 = BigInt.from(
                                  res1[0] / BigInt.from(pow(10, 18)));
                              var res2 =
                                  await getBalance(tok1, acc2, ethClient!);
                              BigInt bigint2 = BigInt.from(
                                  res2[0] / BigInt.from(pow(10, 18)));
                              setState(() {
                                slvbal1 = '$bigint1';
                                gldbal2 = '$bigint2';
                                isLoading2 = false;
                              });
                            },
                            child: Text(
                              "Account 2 balance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                            child: !isLoading2
                                ? Column(
                                    children: [
                                      Text(
                                        'SILVER : $slvbal1',
                                        style: const TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'GOLD : $gldbal2',
                                        style: const TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : const CircularProgressIndicator()),
                      ],
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
