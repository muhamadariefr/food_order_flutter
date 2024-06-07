import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        child: SingleChildScrollView( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAboutUsCard(),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: AboutCard(
                  title: 'Tentang Perusahaan',
                  children: [
                    AboutInfo(
                      icon: Icons.info,
                      content:
                          'Multiverse Resto adalah restoran terkemuka di Kota Wakanda yang menawarkan beragam menu kuliner dari seluruh dunia. Dengan bahan-bahan berkualitas tinggi dan chef berpengalaman, kami berkomitmen untuk memberikan pengalaman makan yang luar biasa bagi setiap pelanggan. Kami terus berinovasi untuk menghadirkan menu yang unik dan cita rasa yang tak terlupakan.',
                    ),
                    AboutInfo(
                      icon: Icons.history,
                      content:
                          'Sejak didirikan pada tahun 2000, Multiverse Resto telah menjadi tempat favorit bagi warga lokal maupun wisatawan. Kami bangga dengan layanan kami yang ramah dan profesional, serta lingkungan restoran yang nyaman dan bersahabat.',
                    ),
                    AboutInfo(
                      icon: Icons.star,
                      content:
                          'Visi kami adalah menjadi destinasi kuliner terbaik di dunia, dan misi kami adalah untuk menciptakan kebahagiaan melalui makanan yang lezat dan layanan yang luar biasa. Terima kasih telah menjadi bagian dari perjalanan kami!',
                    ),
                  ],
                ),
              ),
              _buildVisitUsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutUsCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: NetworkImage(
                'https://images.pexels.com/photos/3434523/pexels-photo-3434523.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Selamat Datang di Multiverse Resto!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitUsCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
              child: Text(
                'Kunjungi Kami di Google Maps',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                
              ),
            ),
            ListTile(
              onTap: () {
                _launchURL('https://www.google.com/maps/place/STT+Mandala+Bandung+High+Technology+Campus');
              },
              title: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Jl. Kamana Wae Ieu Mah IV No. 112, Kota Wakanda, Wakanda',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class AboutCard extends StatelessWidget {
  final String title;
  final List<AboutInfo> children;

  const AboutCard({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutInfo extends StatelessWidget {
  final IconData icon;
  final String content;

  const AboutInfo({
    Key? key,
    required this.icon,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
