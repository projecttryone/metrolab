import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
void openWhatsAppChat(String phone, {String message = ''}) async {
  final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}");

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    // Optional: fallback to web or show error dialog
    print("WhatsApp is not installed.");
  }
}
class CallToActionWidget extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback? onChatPressed; // Optional: handle chat action

  const CallToActionWidget({
    Key? key,
    required this.phoneNumber,
    this.onChatPressed,
  }) : super(key: key);

  void _callNow(BuildContext context) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }
final double buttonFontSize = 10;  // adjust this
final double buttonIconSize = 08; 
  @override
  Widget build(BuildContext context) {
  return Stack(
    clipBehavior: Clip.none, // allow overflow
    children: [
      // 1) The colored background/card
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF3EDBB2), Color(0xFF19456B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        // leave extra right padding so text/buttons don't overlap the image
        // padding: const EdgeInsets.fromLTRB(16, 16, 100, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Couldn’t find the test you were searching?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Talk to our health advisors to book your",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 16),
        Row(
  children: [
    // Call Now
    ElevatedButton.icon(
      onPressed: () => _callNow(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF21C87A),
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      ),
      icon: Icon(
        Icons.call,
        color: Colors.white,
        size: buttonIconSize,
      ),
      label: Text(
        'Call Now',
        style: TextStyle(
          color: Colors.white,
          fontSize: buttonFontSize,
        ),
      ),
    ),
    const SizedBox(width: 10),
    // Chat with Us
    OutlinedButton.icon(
      onPressed: () => openWhatsAppChat(
    '9779860103441', // <-- no "+" sign
    message: 'Hello, I’d like to chat with you!',
  ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white),
        shape: StadiumBorder(),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 09),
      ),
      icon: Icon(
        Icons.chat,
        color: Colors.white,
        size: buttonIconSize,
      ),
      label: Text(
        'Chat with Us',
        style: TextStyle(
          color: Colors.white,
          fontSize: buttonFontSize,
        ),
      ),
    ),
  ],
),
          ],
        ),
      ),

      // 2) The doctor image, positioned to overflow on the right
      Positioned(
        top: 29, // align roughly with the container’s top padding
        right: 12, // same horizontal margin
        child: Image.asset(
          'assets/doctor.png',
          width: 180,   // bump this up so it’s big like your design
          height: 125,  // adjust to keep aspect ratio
          fit: BoxFit.contain,
        ),
      ),
    ],
  );
}
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF3EDBB2), Color(0xFF19456B)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 12,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//      child: Row(
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Couldn’t find the test you were searching?",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "Talk to our health advisors to book your",
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Row(
//           //   children: [
//           //     ElevatedButton.icon(
//           //       onPressed: () => _callNow(context),
//           //       style: ElevatedButton.styleFrom(
//           //         backgroundColor: Color(0xFF21C87A),
//           //         shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(30),
//           //         ),
//           //         padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//           //       ),
//           //       icon: Icon(Icons.call, color: Colors.white),
//           //       label: Text('Call Now', style: TextStyle(color: Colors.white)),
//           //     ),
//           //     const SizedBox(width: 12),
//           //     OutlinedButton.icon(
//           //       onPressed: onChatPressed ?? () {},
//           //       style: OutlinedButton.styleFrom(
//           //         side: BorderSide(color: Colors.white),
//           //         shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(30),
//           //         ),
//           //         foregroundColor: Colors.white,
//           //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           //       ),
//           //       icon: Icon(Icons.chat, color: Colors.white),
//           //       label: Text('Chat with Us'),
//           //     ),
//           //   ],
//           // ),

//           // Wrap(
//           //     spacing: 10,       // horizontal gap
//           //     runSpacing: 8,     // vertical gap if they wrap
//           //     children: [
//           //       ElevatedButton.icon(
//           //         onPressed: () => _callNow(context),
//           //         style: ElevatedButton.styleFrom(
//           //           backgroundColor: Color(0xFF21C87A),
//           //           shape: StadiumBorder(),
//           //           padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//           //         ),
//           //         icon: Icon(Icons.call, color: Colors.white),
//           //         label: Text('Call Now', style: TextStyle(color: Colors.white)),
//           //       ),

//           //       OutlinedButton.icon(
//           //         onPressed: onChatPressed ?? () {},
//           //         style: OutlinedButton.styleFrom(
//           //           side: BorderSide(color: Colors.white),
//           //           shape: StadiumBorder(),
//           //           foregroundColor: Colors.white,
//           //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           //         ),
//           //         icon: Icon(Icons.chat, color: Colors.white),
//           //         label: Text('Chat with Us'),
//           //       ),
//           //     ],
//           //   ),

// Row(
//   children: [
//     Flexible(
//       fit: FlexFit.tight,
//       child: ElevatedButton.icon(
//         onPressed: () => _callNow(context),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFF21C87A),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         ),
//         icon: Icon(Icons.call, color: Colors.white),
//         label: Text(
//           'Call Now',
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     ),
//     const SizedBox(width: 12),
//     Flexible(
//       fit: FlexFit.tight,
//       child: OutlinedButton.icon(
//         onPressed: onChatPressed ?? () {},
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: Colors.white),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           foregroundColor: Colors.white,
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         ),
//         icon: Icon(Icons.chat, color: Colors.white),
//         label: Text(
//           'Chat with Us',
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//     ),
//   ],
// ),



//         ],
//       ),
//     ),

//     // Wrap the image in Flexible so it won't force overflow
//     Flexible(
//       fit: FlexFit.loose,
//       child: Container(
//         height: 110,
//         width: 80,
//         margin: const EdgeInsets.only(left: 12),
//         child: Image.asset(
//           'assets/doctor.png',
//           fit: BoxFit.contain,
//         ),
//       ),
//     ),
//   ],
// ),
 
//      );
//   }
}
