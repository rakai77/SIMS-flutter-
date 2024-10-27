import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../topup/topup_screen.dart';
import '../transaction/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),         // Home content (main screen)
    const TopUpScreen(),         // Top Up screen
    const TransactionScreen(),   // Transaction screen
    const ProfileScreen(),       // Profile screen
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 // Only show AppBar when _currentIndex is 0 (Home)
          ? AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SIMS PPOB',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/user-profile.jpg'), // Replace with user's profile picture URL
              radius: 20,
            ),
          ],
        ),
      )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Top Up'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}


class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting and Balance Card
          const Text(
            'Selamat datang,\nKristanto Wibowo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PromoCard(
                  color: Colors.redAccent,
                  title: 'Saldo Gratis!',
                  description: 'saldo SIMS PPOB gratis maksimal Rp25.000 untuk pengguna pertama',
                ),
                SizedBox(width: 10),
                PromoCard(
                  color: Colors.purpleAccent,
                  title: 'Diskon listrik!',
                  description: 'diskon untuk setiap pembayaran listrik prabayar/pascabayar 10%',
                ),
                SizedBox(width: 10),
                PromoCard(
                  color: Colors.orangeAccent,
                  title: 'Promo Spesial!',
                  description: 'dapatkan diskon 20% untuk pembayaran PDAM bulan ini.',
                ),
              ],
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
      width: 200, // Set a fixed width for each promo card
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
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}