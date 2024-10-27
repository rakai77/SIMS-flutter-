import 'package:flutter/material.dart';
import '../../data/banner_model.dart';
import '../../data/service_model.dart';
import '../../network/api_service.dart';
import '../profile/profile_screen.dart';
import '../topup/topup_screen.dart';
import '../transaction/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  int _currentIndex = 0;
  Map<String, dynamic>? _profileData;
  List<BannerModel> _banners = [];
  int _balance = 0;
  List<ServiceModel> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchBanners();
    _fetchBalance();
    _fetchServices();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await _apiService.getProfile();
      if (response.statusCode == 200 && response.data['status'] == 0) {
        setState(() {
          _profileData = response.data['data'];
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final response = await _apiService.getBanners();
      if (response.statusCode == 200 && response.data['status'] == 0) {
        setState(() {
          _banners = BannerModel.fromJsonList(response.data['data']);
        });
      }
    } catch (e) {
      print("Error fetching banners: $e");
    }
  }

  Future<void> _fetchBalance() async {
    try {
      final response = await _apiService.getBalance();
      if (response.statusCode == 200 && response.data['status'] == 0) {
        setState(() {
          _balance = response.data['data']['balance'];
        });
      }
    } catch (e) {
      print("Error fetching balance: $e");
    }
  }

  Future<void> _fetchServices() async {
    try {
      final response = await _apiService.getServices();
      if (response.statusCode == 200 && response.data['status'] == 0) {
        setState(() {
          _services = ServiceModel.fromJsonList(response.data['data']);
        });
      }
    } catch (e) {
      print("Error fetching services: $e");
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeContent(
          firstName: _profileData?['first_name'] ?? 'User',
          lastName: _profileData?['last_name'] ?? '',
          banners: _banners,
          balance: _balance,
          services: _services),
      const TopUpScreen(),
      const TransactionScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SIMS PPOB',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      _profileData?['profile_image'] ??
                          'https://example.com/user-profile.jpg', // Fallback image URL
                    ),
                    radius: 20,
                  ),
                ],
              ),
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Top Up'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String firstName;
  final String lastName;
  final List<BannerModel> banners;
  final int balance;
  final List<ServiceModel> services;

  const HomeContent(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.banners,
      required this.balance,
      required this.services});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang,\n$firstName $lastName',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          BalanceCard(balance: balance),
          const SizedBox(height: 20),

          GridView.builder(
            padding: const EdgeInsets.all(8.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return HomeIcon(
                iconUrl: service.serviceIcon,
                label: service.serviceName,
              );
            },
          ),
          const SizedBox(height: 20),

          // Promo Section
          const Text(
            'Temukan promo menarik',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: banners.map((banner) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: PromoCard(
                    color: Colors.lightBlueAccent,
                    title: banner.bannerName,
                    description: banner.description,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceCard extends StatefulWidget {
  final int balance;

  const BalanceCard({super.key, required this.balance});

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = false;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saldo anda',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            _isBalanceVisible
                ? 'Rp ${widget.balance.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}'
                : 'Rp •••••••••',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lihat Saldo',
                style: TextStyle(color: Colors.white70),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: _toggleBalanceVisibility,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeIcon extends StatelessWidget {
  final String iconUrl;
  final String label;

  const HomeIcon({super.key, required this.iconUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          backgroundImage: NetworkImage(iconUrl),
          radius: 24,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PromoCard extends StatelessWidget {
  final Color color;
  final String title;
  final String description;

  const PromoCard({
    super.key,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
