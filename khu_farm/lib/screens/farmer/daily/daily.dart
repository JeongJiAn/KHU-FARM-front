import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:khu_farm/screens/product_detail.dart';
import 'package:khu_farm/screens/chatbot.dart';
import 'package:khu_farm/constants.dart';
import 'package:khu_farm/services/storage_service.dart';
import 'package:khu_farm/model/fruit.dart';
import 'package:khu_farm/model/farm.dart';

class FarmerDailyScreen extends StatefulWidget {
  const FarmerDailyScreen({super.key});

  @override
  State<FarmerDailyScreen> createState () => _FarmerDailyScreenState();
}

class _FarmerDailyScreenState extends State<FarmerDailyScreen> {
  List<Fruit> _fruits = [];
  List<Farm> _farms = [];
  bool _isLoading = true;
  late final TextEditingController _searchFruitController;
  late final TextEditingController _searchFarmController;

  @override
  void initState() {
    super.initState();
    _searchFruitController = TextEditingController();
    _searchFarmController = TextEditingController();
    _fetchFruits();
    _fetchFarms();
  }

  Future<void> _fetchFruits() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await StorageService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        print('Authentication token is missing. Please log in.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/fruits/get/2?size=1000'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> result = data['result'];
        final List<dynamic>? fruitList = result['content'];

        if (fruitList != null) {
          setState(() {
            _fruits = fruitList.map((json) => Fruit.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          print("The 'content' field in the server response is null.");
          setState(() {
            _fruits = [];
            _isLoading = false;
          });
        }
      } else {
        print('API Error - Status Code: ${response.statusCode}');
        print('API Error - Response Body: ${utf8.decode(response.bodyBytes)}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchFruits(String keyword) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await StorageService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        print('Authentication token is missing. Please log in.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      // API 명세서에 따라 검색 키워드를 포함한 URL 구성
      final response = await http.get(
        Uri.parse('$baseUrl/fruits/search/2?searchKeyword=$keyword'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> result = data['result'];
        final List<dynamic>? fruitList = result['content'];

        if (fruitList != null) {
          setState(() {
            _fruits = fruitList.map((json) => Fruit.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          print("The 'content' field in the server response is null.");
          setState(() {
            _fruits = [];
            _isLoading = false;
          });
        }
      } else {
        print('Search API Error - Status Code: ${response.statusCode}');
        print('Search API Error - Response Body: ${utf8.decode(response.bodyBytes)}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred during search: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchFarms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await StorageService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        print('Authentication token is missing. Please log in.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final headers = {
        'Authorization': 'Bearer $accessToken',
      };
  
      final uri = Uri.parse('$baseUrl/seller');
      final response = await http.get(uri, headers: headers);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> result = data['result'];
        final List<dynamic>? farmList = result['content'];

        if (farmList != null && farmList.isNotEmpty) {
          setState(() {
            final newFarms = farmList.map((json) => Farm.fromJson(json)).toList();
            _farms.addAll(newFarms);
          });
        } else {
          setState(() {
            _farms = [];
            _isLoading = false;
          });
        }
      } else {
        print('API Error - Status Code: ${response.statusCode}');
        print('API Error - Response Body: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('An error occurred during farm fetch: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchFarms(String keyword) async {
    final String? token = await StorageService.getAccessToken();
    if (token == null) {
      print('로그인 정보가 없습니다.');
      return;
    }

    // API 명세에 따라 searchKeyword만 쿼리 파라미터로 추가
    final uri = Uri.parse('$baseUrl/seller/search').replace(
      queryParameters: {'searchKeyword': keyword},
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> result = data['result'];
        final List<dynamic>? farmList = result['content'];
        // 응답 본문의 'result' 필드에서 농가 목록을 추출하여 상태 업데이트
        if (farmList != null && farmList.isNotEmpty) {
          setState(() {
            final newFarms = farmList.map((json) => Farm.fromJson(json)).toList();
            _farms.addAll(newFarms);
          });
        } else {
          setState(() {
            _farms = [];
            _isLoading = false;
          });
        }
        print('농가 검색 성공: $_farms');
      } else {
        print('농가 검색 실패 (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('네트워크 오류: $e');
    }
  }

  Future<void> _addToWishlist(int fruitId) async {
    final accessToken = await StorageService.getAccessToken();
    if (accessToken == null) return;

    final headers = {'Authorization': 'Bearer $accessToken'};
    final uri = Uri.parse('$baseUrl/wishList/$fruitId/add');

    try {
      final response = await http.post(uri, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('찜 추가 성공');
        // On success, refetch the entire list from the server
        await _fetchFruits();
      } else {
        print('찜 추가 실패: ${response.statusCode}');
        print('Response Body: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('찜 추가 에러: $e');
    }
  }

  Future<void> _removeFromWishlist(int fruitId) async {
    final accessToken = await StorageService.getAccessToken();
    if (accessToken == null) return;

    final headers = {'Authorization': 'Bearer $accessToken'};
    final uri = Uri.parse('$baseUrl/wishList/$fruitId/delete');
    print(uri);

    try {
      final response = await http.delete(uri, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('찜 삭제 성공');
        // On success, refetch the entire list from the server
        await _fetchFruits();
      } else {
        print('찜 삭제 실패: ${response.statusCode}');
        print('Response Body: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('찜 삭제 에러: $e');
    }
  }

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
                  '/farmer/stock',
                  ModalRoute.withName("/farmer/main"),
                );
              },
            ),
            _NavItem(
              iconPath: 'assets/bottom_navigator/unselect/harvest.png',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/farmer/harvest',
                  ModalRoute.withName("/farmer/main"),
                );
              },
            ),
            _NavItem(
              iconPath: 'assets/bottom_navigator/unselect/laicos.png',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/farmer/laicos',
                  ModalRoute.withName("/farmer/main"),
                );
              },
            ),
            _NavItem(
              iconPath: 'assets/bottom_navigator/unselect/mypage.png',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/farmer/mypage',
                  ModalRoute.withName("/farmer/main"),
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
                      '/farmer/main',
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
                          '/farmer/notification/list',
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
                      onTap: () async {
                        // 찜 화면으로 이동하고, 돌아올 때까지 기다립니다.
                        await Navigator.pushNamed(
                          context,
                          '/farmer/dib/list',
                        );
                        // 찜 화면에서 돌아온 후 목록을 새로고침합니다.
                        _fetchFruits();
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
                        Navigator.pushNamed(
                          context,
                          '/farmer/cart/list',
                        );
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
                                      '/farmer/daily/fruit',
                                      arguments: {'fruitId': 1, 'wholesale': 2},
                                    );
                                  },
                                  child: const _CategoryIcon(
                                    iconPath: 'assets/icons/apple.png',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/farmer/daily/fruit',
                                      arguments: {'fruitId': 2, 'wholesale': 2},
                                    );
                                  },
                                  child: const _CategoryIcon(
                                    iconPath: 'assets/icons/mandarin.png',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/farmer/daily/fruit',
                                      arguments: {'fruitId': 3, 'wholesale': 2},
                                    );
                                  },
                                  child: const _CategoryIcon(
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
                              child: TextField(
                                controller: _searchFruitController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: '검색하기',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _searchFruits(value);
                                  } else {
                                    _fetchFruits(); // 검색어가 없으면 전체 목록 다시 로드
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : _fruits.isEmpty
                                    ? const Center(child: Text('해당 과일이 없습니다.'))
                                    : ListView.builder(
                                        itemCount: _fruits.length,
                                        itemBuilder: (context, index) {
                                          final fruit = _fruits[index];
                                          return _buildProductItem(
                                            context,
                                            fruit: fruit,
                                          );
                                        },
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
                              child: TextField(
                                controller: _searchFarmController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: '검색하기',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _searchFarms(value);
                                  } else {
                                    _fetchFarms(); // 검색어가 없으면 전체 목록 다시 로드
                                  }
                                },
                              ),
                            ),
                            // 농가 리스트
                            Expanded(
                              child: _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : _farms.isEmpty
                                  ? const Center(child: Text('해당 농가가 없습니다.'))
                                  : ListView.builder(
                                    itemCount: _farms.length,
                                    itemBuilder: (context, index) {
                                      final farm = _farms[index];
                                      return _FarmItem(
                                        imagePath: farm.imageUrl,
                                        producer: farm.brandName,
                                        subtitle: farm.description,
                                        liked: false,
                                      );
                                    },
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

  Widget _buildProductItem(BuildContext context, {required Fruit fruit}) {
    return GestureDetector(
      // onTap 콜백을 async로 변경
      onTap: () async {
        // MaterialPageRoute를 await로 호출하여, 해당 페이지가 pop될 때까지 기다림
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(fruit: fruit),
          ),
        );
        // ProductDetailScreen에서 돌아온 후에 _fetchFruits()를 호출하여 데이터를 새로고침
        print('Returned from detail screen. Refreshing fruit list...');
        _fetchFruits();
      },
      child: _ProductItem(
        imagePath: fruit.squareImageUrl,
        producer: fruit.brandName ?? '알 수 없음',
        title: fruit.title,
        price: fruit.price,
        unit: fruit.weight,
        liked: fruit.isWishList,
        onLikeToggle: () {
          if (fruit.isWishList) {
            _removeFromWishlist(fruit.wishListId);
          } else {
            _addToWishlist(fruit.id);
          }
        },
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

class _ProductItem extends StatelessWidget {
  final String imagePath;
  final String producer;
  final String title;
  final int price;
  final int unit;
  final bool liked;
  final VoidCallback onLikeToggle;

  const _ProductItem({
    required this.imagePath,
    required this.producer,
    required this.title,
    required this.price,
    required this.unit,
    required this.liked,
    required this.onLikeToggle,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/mascot/main_mascot.png',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onLikeToggle, // 탭 시 콜백 함수 호출
                  child: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : Colors.white,
                    size: 28, // 아이콘 크기 약간 키움
                  ),
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
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    producer,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
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
                  '$price원',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' / $unit' 'kg',
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

class _FarmItem extends StatelessWidget {
  final String imagePath;
  final String producer;
  final String subtitle;
  final bool liked;

  const _FarmItem({
    required this.imagePath,
    required this.producer,
    required this.subtitle,
    this.liked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      child: Stack(
        children: [
          // 1. 배경 이미지
          Image.network(
            imagePath,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/farm/temp_farm.jpg',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              );
            },
          ),
          
          // 2. 하단 텍스트 및 아이콘 버튼
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // --- 🖼️ 이 부분이 수정되었습니다 ---
                // 텍스트를 감싸는 반투명 컨테이너
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // 반투명 배경
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Column이 자식 크기만큼만 차지하도록 설정
                    children: [
                      Text(
                        producer,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(), // 텍스트와 아이콘 사이의 공간을 모두 차지
                // --- 여기까지 ---
                
                // 찜 아이콘 버튼
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     shape: BoxShape.circle,
                //   ),
                //   child: Icon(
                //     liked ? Icons.favorite : Icons.favorite_border,
                //     color: liked ? Colors.red : Colors.grey.shade700,
                //     size: 24,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}