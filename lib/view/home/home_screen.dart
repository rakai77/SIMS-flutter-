import 'package:flutter/material.dart';
import '../../data/banner_model.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchBanners();
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
          banners: _banners

      ),
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

  const HomeContent(
      {super.key, required this.firstName, required this.lastName, required this.banners});

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
          const BalanceCard(),
          const SizedBox(height: 20),

          // Icons Grid
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            children: const [
              HomeIcon(Icons.home, 'PBB'),
              HomeIcon(Icons.flash_on, 'Listrik'),
              HomeIcon(Icons.phone, 'Pulsa'),
              HomeIcon(Icons.water_damage, 'PDAM'),
              HomeIcon(Icons.fireplace, 'PGN'),
              HomeIcon(Icons.tv, 'Televisi'),
              HomeIcon(Icons.music_note, 'Musik'),
              HomeIcon(Icons.videogame_asset, 'Game'),
              HomeIcon(Icons.fastfood, 'Makanan'),
              HomeIcon(Icons.nights_stay, 'Kurban'),
              HomeIcon(Icons.emoji_nature, 'Zakat'),
              HomeIcon(Icons.data_usage, 'Data'),
            ],
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

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo anda',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Rp •••••••••',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lihat Saldo',
                style: TextStyle(color: Colors.white70),
              ),
              Icon(
                Icons.visibility,
                color: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const HomeIcon(this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
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
