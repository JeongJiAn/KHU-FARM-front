import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khu_farm/screens/administrator/daily/product_detail.dart';
import 'package:khu_farm/screens/chatbot.dart';

class AdministratorDailyScreen extends StatelessWidget {
  const AdministratorDailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,

      bottomNavigationBar: Container(
        color: const Color(0xFFB6832B),
        padding: EdgeInsets.only(
          // top: 20,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              iconPath: 'assets/bottom_navigator/select/daily.png',
              onTap: () {},
            ),
            _NavItem(
              iconPath: 'assets/bottom_navigator/unselect/stock.png',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/admin/stock',
                  ModalRoute.withName("/admin/daily"),
                );
              },
            ),
            _NavItem(
              iconPath: 'assets/bottom_navigator/unselect/harvest.png',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/admin/harvest',
                  ModalRoute.withName("/admin/daily"),
                );
              },
            ),
            _NavItem(
              iconPath: 'assets/bottom_navigator/unselect/laicos.png',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/admin/laicos',
                  ModalRoute.withName("/admin/daily"),
                );
              },
            ),
            _NavItem(
              iconPath: 'assets/bottom_navigator/unselect/mypage.png',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/admin/mypage',
                  ModalRoute.withName("/admin/daily"),
                );
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          // 노치 배경
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight + screenHeight * 0.06,
            child: Image.asset('assets/notch/morning.png', fit: BoxFit.cover),
          ),

          // 우상단 이미지
          Positioned(
            top: 0,
            right: 0,
            height: statusBarHeight * 1.2,
            child: Image.asset(
              'assets/notch/morning_right_up_cloud.png',
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),

          // 좌하단 이미지
          Positioned(
            top: statusBarHeight,
            left: 0,
            height: screenHeight * 0.06,
            child: Image.asset(
              'assets/notch/morning_left_down_cloud.png',
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),

          Positioned(
            top: statusBarHeight,
            height: statusBarHeight + screenHeight * 0.02,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/admin/daily',
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'KHU:FARM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/admin/notification/list',
                        );
                      },
                      child: Image.asset(
                        'assets/top_icons/notice.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // TODO: 찜 화면으로
                      },
                      child: Image.asset(
                        'assets/top_icons/dibs.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // TODO: 장바구니 화면으로
                      },
                      child: Image.asset(
                        'assets/top_icons/cart.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: statusBarHeight + screenHeight * 0.06 + 16,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            bottom: 0, // 하단 내비바 높이
            child: DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 탭바
                  TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: const [Tab(text: '과일별'), Tab(text: '농가별')],
                  ),
                  const SizedBox(height: 16),

                  // 탭뷰: Expanded로 감싸기
                  Expanded(
                    child: TabBarView(
                      children: [
                        // 과일별 탭
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/admin/daily/apple',
                                    );
                                  },
                                  child: _CategoryIcon(
                                    iconPath: 'assets/icons/apple.png',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/admin/daily/mandarin',
                                    );
                                  },
                                  child: _CategoryIcon(
                                    iconPath: 'assets/icons/mandarin.png',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/admin/daily/strawberry',
                                    );
                                  },
                                  child: _CategoryIcon(
                                    iconPath: 'assets/icons/strawberry.png',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: '검색하기',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  _buildProductItem(
                                    context,
                                    imagePath: 'assets/mascot/login_mascot.png',
                                    producer: '한우리영농조합법인',
                                    title: '못난이 꿀사과 가정용 특가',
                                    price: '10,000원',
                                    unit: '/5kg',
                                    liked: false,
                                  ),
                                  _buildProductItem(
                                    context,
                                    imagePath: 'assets/mascot/login_mascot.png',
                                    producer: '새은귤농원',
                                    title: '감귤 못난이 10kg 꿀맛 과즙 팡팡',
                                    price: '10,000원',
                                    unit: '/5kg',
                                    liked: true,
                                  ),
                                  _buildProductItem(
                                    context,
                                    imagePath: 'assets/mascot/login_mascot.png',
                                    producer: '우리농원딸농산물센터',
                                    title: '감귤 못난이 10kg 과즙 팡팡',
                                    price: '10,000원',
                                    unit: '/5kg',
                                    liked: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // 농가별 탭
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 검색 필드
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: '검색하기',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                            ),
                            // 농가 리스트
                            Expanded(
                              child: ListView(
                                children: const [
                                  _FarmListItem(
                                    imagePath: 'assets/farm/temp_farm.jpg',
                                    producer: '한우리영농조합법인',
                                    subtitle: '싱싱한 사과를 기르는 조합',
                                    liked: false,
                                  ),
                                  _FarmListItem(
                                    imagePath: 'assets/farm/temp_farm.jpg',
                                    producer: '맑은귤농원',
                                    subtitle: '맛있는 귤을 재배하는 농원',
                                    liked: true,
                                  ),
                                  _FarmListItem(
                                    imagePath: 'assets/farm/temp_farm.jpg',
                                    producer: '우리농산물센터',
                                    subtitle: '신선한 딸기를 전달하는 센터',
                                    liked: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 채팅 모달 버튼 (고정)
          Positioned(
            bottom: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  showChatbotModal(context);
                },
                child: Image.asset(
                  'assets/chat/chatbot_icon.png',
                  width: 68,
                  height: 68,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
    BuildContext context, {
    required String imagePath,
    required String producer,
    required String title,
    required String price,
    required String unit,
    required bool liked,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ProductDetailScreen(
                  imagePath: imagePath,
                  title: title,
                  producer: producer,
                  price: price,
                  unit: unit,
                  liked: liked,
                ),
          ),
        );
      },
      child: _ProductListItem(
        imagePath: imagePath,
        producer: producer,
        title: title,
        price: price,
        unit: unit,
        liked: liked,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _NavItem({required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.15;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Image.asset(iconPath, width: size, height: size)],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String iconPath;
  const _CategoryIcon({required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Image.asset(iconPath, width: 48, height: 48)]);
  }
}

class _ProductListItem extends StatelessWidget {
  final String imagePath;
  final String producer;
  final String title;
  final String price;
  final String unit;
  final bool liked;

  const _ProductListItem({
    required this.imagePath,
    required this.producer,
    required this.title,
    required this.price,
    required this.unit,
    this.liked = false,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품 이미지 및 아이콘
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : Colors.white,
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: Colors.black54,
                  child: Text(
                    producer,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          // 상세 텍스트
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmListItem extends StatelessWidget {
  final String imagePath;
  final String producer;
  final String subtitle;
  final bool liked;

  const _FarmListItem({
    required this.imagePath,
    required this.producer,
    required this.subtitle,
    this.liked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // Favorite icon top-right
          Positioned(
            top: 8,
            right: 8,
            child: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Colors.red : Colors.white,
            ),
          ),
          // Text and icon at bottom
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producer,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
