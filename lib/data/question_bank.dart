import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';

/// Data soal dummy (lokal), tidak memakai database.
const List<QuizCategory> quizCategories = [
  QuizCategory(
    id: 'tech',
    name: 'Teknologi',
    description: 'Flutter, Dart & dasar pemrograman',
    imageAsset: 'assets/images/cat_tech.svg',
    color: Color(0xFF2563EB),
    questions: [
      Question(
        questionText: 'Flutter dikembangkan oleh perusahaan...',
        options: ['Microsoft', 'Google', 'Meta', 'Apple'],
        correctIndex: 1,
        explanation:
            'Flutter adalah UI toolkit open-source buatan Google, dirilis stabil tahun 2018.',
      ),
      Question(
        questionText: 'Bahasa pemrograman yang digunakan Flutter adalah...',
        options: ['Kotlin', 'Swift', 'Dart', 'JavaScript'],
        correctIndex: 2,
        explanation: 'Flutter menggunakan bahasa Dart yang juga dikembangkan oleh Google.',
      ),
      Question(
        questionText:
            'Widget yang tampilannya tidak berubah karena state internal adalah...',
        options: ['StatefulWidget', 'StatelessWidget', 'InheritedWidget', 'AnimatedWidget'],
        correctIndex: 1,
        explanation:
            'StatelessWidget tidak menyimpan state yang dapat berubah; tampilannya hanya bergantung pada parameter.',
      ),
      Question(
        questionText: 'Method untuk memperbarui tampilan pada StatefulWidget adalah...',
        options: ['build()', 'initState()', 'setState()', 'dispose()'],
        correctIndex: 2,
        explanation:
            'setState() memberi tahu framework bahwa state berubah sehingga build() dipanggil ulang.',
      ),
      Question(
        questionText: 'Widget untuk menyusun beberapa widget secara vertikal adalah...',
        options: ['Row', 'Column', 'Stack', 'Wrap'],
        correctIndex: 1,
        explanation:
            'Column menyusun children dari atas ke bawah, sedangkan Row dari kiri ke kanan.',
      ),
      Question(
        questionText: 'File untuk mengatur dependensi dan aset pada proyek Flutter adalah...',
        options: ['package.json', 'build.gradle', 'main.dart', 'pubspec.yaml'],
        correctIndex: 3,
        explanation: 'pubspec.yaml berisi daftar package, font, dan aset yang digunakan aplikasi.',
      ),
      Question(
        questionText:
            'Fitur Flutter untuk melihat perubahan kode tanpa restart aplikasi adalah...',
        options: ['Hot Reload', 'Live Build', 'Quick Run', 'Fast Deploy'],
        correctIndex: 0,
        explanation:
            'Hot Reload menyuntikkan kode baru ke Dart VM sehingga perubahan UI langsung terlihat dan state tetap terjaga.',
      ),
      Question(
        questionText: 'Kepanjangan dari HTML adalah...',
        options: [
          'HyperText Markup Language',
          'High Text Machine Language',
          'HyperTool Multi Language',
          'Home Tool Markup Language',
        ],
        correctIndex: 0,
        explanation:
            'HTML (HyperText Markup Language) adalah bahasa markah untuk membuat struktur halaman web.',
      ),
      Question(
        questionText:
            'Struktur data yang menerapkan prinsip LIFO (Last In First Out) adalah...',
        options: ['Queue', 'Array', 'Stack', 'Tree'],
        correctIndex: 2,
        explanation: 'Pada Stack, elemen terakhir yang dimasukkan adalah yang pertama dikeluarkan.',
      ),
      Question(
        questionText: 'Navigator.push() di Flutter digunakan untuk...',
        options: [
          'Menghapus widget',
          'Berpindah ke halaman baru',
          'Menyimpan data',
          'Mengganti tema',
        ],
        correctIndex: 1,
        explanation:
            'Navigator.push() menambahkan route baru ke tumpukan navigasi sehingga halaman baru tampil.',
      ),
    ],
  ),
  QuizCategory(
    id: 'science',
    name: 'Sains',
    description: 'Fisika, kimia, biologi & astronomi',
    imageAsset: 'assets/images/cat_science.svg',
    color: Color(0xFF059669),
    questions: [
      Question(
        questionText: 'Planet terbesar di tata surya adalah...',
        options: ['Saturnus', 'Jupiter', 'Neptunus', 'Bumi'],
        correctIndex: 1,
        explanation: 'Jupiter adalah planet terbesar; diameternya sekitar 11 kali diameter Bumi.',
      ),
      Question(
        questionText: 'Rumus kimia air adalah...',
        options: ['CO2', 'O2', 'H2O', 'NaCl'],
        correctIndex: 2,
        explanation: 'Satu molekul air tersusun dari dua atom hidrogen dan satu atom oksigen.',
      ),
      Question(
        questionText: 'Gas yang dihasilkan tumbuhan saat fotosintesis adalah...',
        options: ['Karbon dioksida', 'Nitrogen', 'Oksigen', 'Hidrogen'],
        correctIndex: 2,
        explanation: 'Fotosintesis mengubah CO2 dan air menjadi glukosa dengan melepaskan oksigen.',
      ),
      Question(
        questionText: 'Satuan SI untuk gaya adalah...',
        options: ['Joule', 'Watt', 'Pascal', 'Newton'],
        correctIndex: 3,
        explanation: 'Gaya diukur dalam Newton (N); 1 N = 1 kg·m/s².',
      ),
      Question(
        questionText: 'Organ tubuh yang berfungsi memompa darah adalah...',
        options: ['Paru-paru', 'Hati', 'Jantung', 'Ginjal'],
        correctIndex: 2,
        explanation: 'Jantung memompa darah ke seluruh tubuh melalui pembuluh darah.',
      ),
      Question(
        questionText: 'Planet yang paling dekat dengan Matahari adalah...',
        options: ['Venus', 'Merkurius', 'Mars', 'Bumi'],
        correctIndex: 1,
        explanation: 'Merkurius berada di orbit terdalam tata surya.',
      ),
      Question(
        questionText: 'Kecepatan cahaya di ruang hampa kira-kira...',
        options: ['300.000 km/s', '30.000 km/s', '3.000 km/s', '340 m/s'],
        correctIndex: 0,
        explanation:
            'Cahaya merambat sekitar 299.792 km/s; 340 m/s adalah kecepatan bunyi di udara.',
      ),
      Question(
        questionText: 'Bagian sel yang berperan sebagai "pembangkit energi" adalah...',
        options: ['Nukleus', 'Ribosom', 'Mitokondria', 'Vakuola'],
        correctIndex: 2,
        explanation: 'Mitokondria menghasilkan ATP melalui respirasi seluler.',
      ),
      Question(
        questionText: 'Pada tekanan 1 atm, air mendidih pada suhu...',
        options: ['90 °C', '100 °C', '110 °C', '120 °C'],
        correctIndex: 1,
        explanation: 'Titik didih air pada tekanan standar (1 atm) adalah 100 °C.',
      ),
      Question(
        questionText: 'Unsur kimia dengan lambang Fe adalah...',
        options: ['Fluor', 'Fosfor', 'Besi', 'Fermium'],
        correctIndex: 2,
        explanation: 'Fe berasal dari bahasa Latin "ferrum" yang berarti besi.',
      ),
    ],
  ),
  QuizCategory(
    id: 'geo',
    name: 'Geografi',
    description: 'Negara, benua & bentang alam',
    imageAsset: 'assets/images/cat_geo.svg',
    color: Color(0xFF0284C7),
    questions: [
      Question(
        questionText: 'Ibu kota Jepang adalah...',
        options: ['Osaka', 'Kyoto', 'Tokyo', 'Hiroshima'],
        correctIndex: 2,
        explanation: 'Tokyo menjadi ibu kota Jepang sejak tahun 1868.',
      ),
      Question(
        questionText: 'Gunung tertinggi di dunia adalah...',
        options: ['K2', 'Everest', 'Kilimanjaro', 'Elbrus'],
        correctIndex: 1,
        explanation: 'Puncak Everest di Pegunungan Himalaya tingginya sekitar 8.849 mdpl.',
      ),
      Question(
        questionText: 'Sungai terpanjang di Indonesia adalah...',
        options: ['Mahakam', 'Musi', 'Kapuas', 'Barito'],
        correctIndex: 2,
        explanation: 'Sungai Kapuas di Kalimantan Barat panjangnya sekitar 1.143 km.',
      ),
      Question(
        questionText: 'Benua terluas di dunia adalah...',
        options: ['Afrika', 'Asia', 'Amerika', 'Eropa'],
        correctIndex: 1,
        explanation: 'Asia mencakup sekitar 30% daratan Bumi.',
      ),
      Question(
        questionText: 'Samudra terluas di dunia adalah...',
        options: ['Atlantik', 'Hindia', 'Arktik', 'Pasifik'],
        correctIndex: 3,
        explanation: 'Samudra Pasifik luasnya lebih dari 160 juta km².',
      ),
      Question(
        questionText: 'Danau terbesar di Indonesia adalah...',
        options: ['Danau Toba', 'Danau Singkarak', 'Danau Poso', 'Danau Sentani'],
        correctIndex: 0,
        explanation: 'Danau Toba di Sumatra Utara terbentuk dari letusan supervulkan.',
      ),
      Question(
        questionText: 'Ibu kota Australia adalah...',
        options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'],
        correctIndex: 2,
        explanation:
            'Canberra dipilih sebagai ibu kota sebagai kompromi antara Sydney dan Melbourne.',
      ),
      Question(
        questionText: 'Gurun terluas di Benua Afrika adalah...',
        options: ['Kalahari', 'Namib', 'Sahara', 'Gobi'],
        correctIndex: 2,
        explanation: 'Gurun Sahara membentang di Afrika Utara; Gobi berada di Asia.',
      ),
      Question(
        questionText:
            'Garis khayal yang membagi Bumi menjadi belahan utara dan selatan adalah...',
        options: ['Garis bujur', 'Khatulistiwa', 'Garis balik utara', 'Meridian Greenwich'],
        correctIndex: 1,
        explanation: 'Khatulistiwa (ekuator) berada pada lintang 0°.',
      ),
      Question(
        questionText: 'Puncak tertinggi di Indonesia adalah...',
        options: ['Semeru', 'Rinjani', 'Kerinci', 'Puncak Jaya'],
        correctIndex: 3,
        explanation: 'Puncak Jaya (Carstensz Pyramid) di Papua tingginya sekitar 4.884 mdpl.',
      ),
    ],
  ),
  QuizCategory(
    id: 'history',
    name: 'Sejarah',
    description: 'Sejarah & tokoh Indonesia',
    imageAsset: 'assets/images/cat_history.svg',
    color: Color(0xFFEA580C),
    questions: [
      Question(
        questionText: 'Proklamasi kemerdekaan Indonesia dibacakan pada tanggal...',
        options: ['17 Agustus 1945', '20 Mei 1908', '28 Oktober 1928', '1 Juni 1945'],
        correctIndex: 0,
        explanation: 'Proklamasi dibacakan Soekarno di Jalan Pegangsaan Timur 56, Jakarta.',
      ),
      Question(
        questionText: 'Presiden pertama Republik Indonesia adalah...',
        options: ['Mohammad Hatta', 'Soeharto', 'Soekarno', 'B.J. Habibie'],
        correctIndex: 2,
        explanation:
            'Soekarno menjabat presiden pertama, didampingi Mohammad Hatta sebagai wakil presiden.',
      ),
      Question(
        questionText: 'Sumpah Pemuda diikrarkan pada tahun...',
        options: ['1908', '1928', '1945', '1955'],
        correctIndex: 1,
        explanation: 'Sumpah Pemuda diikrarkan pada Kongres Pemuda II, 28 Oktober 1928.',
      ),
      Question(
        questionText: 'Candi Borobudur merupakan peninggalan agama...',
        options: ['Hindu', 'Buddha', 'Islam', 'Konghucu'],
        correctIndex: 1,
        explanation: 'Borobudur dibangun pada masa Dinasti Syailendra sebagai candi Buddha.',
      ),
      Question(
        questionText:
            'Pahlawan wanita dari Aceh yang memimpin perlawanan terhadap Belanda adalah...',
        options: ['R.A. Kartini', 'Dewi Sartika', 'Cut Nyak Dhien', 'Martha Christina Tiahahu'],
        correctIndex: 2,
        explanation:
            'Cut Nyak Dhien memimpin perang gerilya melawan Belanda dalam Perang Aceh.',
      ),
      Question(
        questionText: 'Kerajaan Hindu tertua di Indonesia adalah...',
        options: ['Majapahit', 'Sriwijaya', 'Tarumanegara', 'Kutai'],
        correctIndex: 3,
        explanation:
            'Kerajaan Kutai di Kalimantan Timur diketahui dari prasasti Yupa (abad ke-4).',
      ),
      Question(
        questionText: 'Mahapatih Majapahit yang terkenal dengan Sumpah Palapa adalah...',
        options: ['Gajah Mada', 'Hayam Wuruk', 'Ken Arok', 'Raden Wijaya'],
        correctIndex: 0,
        explanation:
            'Gajah Mada bersumpah tidak akan menikmati palapa sebelum menyatukan Nusantara.',
      ),
      Question(
        questionText: 'Tokoh yang mengetik naskah proklamasi adalah...',
        options: ['Sutan Sjahrir', 'Sayuti Melik', 'Ahmad Soebardjo', 'Sukarni'],
        correctIndex: 1,
        explanation:
            'Sayuti Melik mengetik naskah proklamasi berdasarkan tulisan tangan Soekarno.',
      ),
      Question(
        questionText: 'Hari Pahlawan di Indonesia diperingati setiap tanggal...',
        options: ['10 November', '2 Mei', '1 Oktober', '21 April'],
        correctIndex: 0,
        explanation: 'Hari Pahlawan memperingati Pertempuran Surabaya, 10 November 1945.',
      ),
      Question(
        questionText: 'Pencipta lagu kebangsaan "Indonesia Raya" adalah...',
        options: ['Ismail Marzuki', 'C. Simanjuntak', 'W.R. Supratman', 'Ibu Sud'],
        correctIndex: 2,
        explanation:
            'Wage Rudolf Supratman pertama kali memperdengarkan lagu ini pada Kongres Pemuda II.',
      ),
    ],
  ),
];
