import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Paymentdetails>> fetchPaymentdetails() async {
  final response = await http.get(
    Uri.parse('https://my-json-server.typicode.com/YOGAN-GIT/Flutterapi/transactions'),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((item) => Paymentdetails.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load transactions');
  }
}

class Paymentdetails {
  String? transactionStatus;
  String? amount;
  String? date;
  String? time;
  String? uPIID;
  String? to;
  String? from;

  Paymentdetails({
    this.transactionStatus,
    this.amount,
    this.date,
    this.time,
    this.uPIID,
    this.to,
    this.from,
  });

  factory Paymentdetails.fromJson(Map<String, dynamic> json) {
    return Paymentdetails(
      transactionStatus: json['transaction_status'],
      amount: json['amount'],
      date: json['date'],
      time: json['time'],
      uPIID: json['UPI_ID'],
      to: json['To'],
      from: json['From'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Paymentdetails>> futurePaymentdetails;

  @override
  void initState() {
    super.initState();
    futurePaymentdetails = fetchPaymentdetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Transaction List')),
        body: Center(
        child: FutureBuilder<List<Paymentdetails>>(
        future: futurePaymentdetails,
        builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data![index];
                    return ListTile(
                      title: Text('${transaction.transactionStatus} - ₹${transaction.amount}'),
                      subtitle: Text('To: ${transaction.to}\nDate: ${transaction.date} at ${transaction.time}'),
                      isThreeLine: true,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}