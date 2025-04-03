import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giới Thiệu"),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Text(
          'Cửa hàng điện tử Cô Trân chuyên cung cấp các mặt hàng điện tử chất lượng như chuột, tai nghe, laptop,.. Với uy tín lâu năm, cửa hàng cam kết sản phẩm chính hãng, giá cả hợp lý và dịch vụ tận tâm, mang đến sự hài lòng cho khách hàng.',
        ),
      ),
    );
  }
}
