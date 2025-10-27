import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPage extends StatefulWidget {
  final String phoneNumber;
  const CallPage({super.key, required this.phoneNumber});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void initState() {
    super.initState();
    _makePhoneCall(widget.phoneNumber);
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri launchUri = Uri.parse("tel:$number");
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $number")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // just show an empty placeholder while dialer opens
    return const Center(child: Text("Opening dialer..."));
  }
}
