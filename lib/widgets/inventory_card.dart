import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String arrowUrl;

  const InventoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.arrowUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFC0C0C0),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(19, 44, 74, 0.04),
            offset: Offset(0, 10),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 110,
            height: 88,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8C8C8C),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 67),
                  child: Image.network(
                    arrowUrl,
                    width: 21,
                    height: 21,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
