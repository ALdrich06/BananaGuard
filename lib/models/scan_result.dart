class ScanResult {
  final String diseaseName;
  final double confidence;
  final String imagePath;
  final DateTime dateScanned;
  final String severity;

  ScanResult({
    required this.diseaseName,
    required this.confidence,
    required this.imagePath,
    required this.dateScanned,
    required this.severity,
  });

  Map<String, dynamic> toMap() => {
        'diseaseName': diseaseName,
        'confidence': confidence,
        'imagePath': imagePath,
        'dateScanned': dateScanned.toIso8601String(),
        'severity': severity,
      };

  factory ScanResult.fromMap(Map<String, dynamic> map) => ScanResult(
        diseaseName: map['diseaseName'],
        confidence: map['confidence'],
        imagePath: map['imagePath'],
        dateScanned: DateTime.parse(map['dateScanned']),
        severity: map['severity'],
      );
}

class DiseaseInfo {
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> treatments;
  final String severity;
  final String emoji;
  final String imagePath;
  final int colorCode;

  const DiseaseInfo({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.severity,
    required this.emoji,
    required this.imagePath,
    this.colorCode = 0xFF757575,
  });
}

const List<DiseaseInfo> diseaseDatabase = [
  DiseaseInfo(
    name: 'Black Sigatoka',
    description: 'A serious fungal disease caused by Mycosphaerella fijiensis. It attacks banana leaves reducing photosynthesis and can cause up to 50% yield loss if untreated.',
    symptoms: ['Dark brown to black streaks on leaves', 'Yellowing of leaf edges', 'Premature leaf death', 'Reduced fruit size'],
    treatments: ['Apply fungicides (Propiconazole or Trifloxystrobin)', 'Remove and destroy infected leaves', 'Ensure proper plant spacing for air circulation', 'Use resistant banana varieties'],
    severity: 'High',
    emoji: '🍂',
    imagePath: 'assets/images/black_sigatoka.png',
    colorCode: 0xFF263238,
  ),
  DiseaseInfo(
    name: 'Yellow Sigatoka',
    description: 'A fungal disease caused by Mycosphaerella musicola. Less severe than Black Sigatoka but still causes significant yield reduction.',
    symptoms: ['Yellow streaks parallel to leaf veins', 'Brown oval spots with yellow halos', 'Premature ripening of fruit', 'Weakened plant structure'],
    treatments: ['Apply Mancozeb or Chlorothalonil fungicides', 'Remove affected leaves early', 'Maintain proper drainage', 'Balanced fertilization with potassium'],
    severity: 'Medium',
    emoji: '🌿',
    imagePath: 'assets/images/yellow_sigatoka.png',
    colorCode: 0xFFF9A825,
  ),
  DiseaseInfo(
    name: 'Panama Disease',
    description: 'A soil-borne fungal disease caused by Fusarium oxysporum. One of the most destructive banana diseases with no chemical cure.',
    symptoms: ['Yellowing of lower leaves', 'Wilting and collapse of plant', 'Brown discoloration inside stem', 'Stunted growth'],
    treatments: ['Use disease-free planting material', 'Plant resistant varieties (Cavendish)', 'Quarantine infected areas', 'Improve soil drainage'],
    severity: 'Critical',
    emoji: '☠️',
    imagePath: 'assets/images/panama_disease.png',
    colorCode: 0xFFC62828,
  ),
  DiseaseInfo(
    name: 'Cordana Leaf Spot',
    description: 'A fungal disease caused by Cordana musae. Common in humid environments and causes oval brown spots on leaves.',
    symptoms: ['Oval brown spots with grey centers', 'Yellow borders around spots', 'Spots mainly on older leaves', 'Gradual leaf browning'],
    treatments: ['Apply Copper-based fungicides', 'Remove heavily infected leaves', 'Reduce humidity around plants', 'Avoid overhead irrigation'],
    severity: 'Low',
    emoji: '🟤',
    imagePath: 'assets/images/cordana.png',
    colorCode: 0xFF795548,
  ),
  DiseaseInfo(
    name: 'Banana Bunchy Top Virus',
    description: 'A severe viral disease caused by Banana Bunchy Top Virus (BBTV), transmitted by banana aphids. Infected plants produce no fruit and must be destroyed.',
    symptoms: ['Leaves become narrow and bunched at top', 'Dark green streaks on leaf veins', 'Stunted plant growth', 'Yellow leaf margins that turn brown', 'No fruit production'],
    treatments: ['Remove and destroy all infected plants immediately', 'Control aphid populations with insecticides', 'Use certified virus-free planting material', 'Quarantine affected areas', 'Do not replant in infected soil for 6 months'],
    severity: 'Critical',
    emoji: '🦠',
    imagePath: 'assets/images/bbtv.png',
    colorCode: 0xFF6A1B9A,
  ),
  DiseaseInfo(
    name: 'Moko Disease',
    description: 'A bacterial wilt caused by Ralstonia solanacearum. Spreads through soil, water, insects, and contaminated tools. Extremely destructive.',
    symptoms: ['Sudden wilting of youngest leaves', 'Yellow-orange discoloration of leaf stems', 'Internal stem browning when cut', 'Bacterial ooze from cut stem', 'Premature fruit ripening with rotting'],
    treatments: ['Destroy infected plants by uprooting and burning', 'Sterilize all tools with bleach between uses', 'Avoid planting in infected soil for 2–3 years', 'Control insect vectors', 'Use healthy certified planting material'],
    severity: 'Critical',
    emoji: '🔴',
    imagePath: 'assets/images/moko.png',
    colorCode: 0xFFBF360C,
  ),
  DiseaseInfo(
    name: 'Banana Anthracnose',
    description: 'A post-harvest fungal disease caused by Colletotrichum musae. Mainly affects ripening fruit but can also attack leaves and flowers.',
    symptoms: ['Dark sunken spots on fruit skin', 'Rapid fruit decay after harvest', 'Brown to black lesions on leaves', 'Premature yellowing of fruit', 'Soft rotting areas on banana peel'],
    treatments: ['Apply post-harvest fungicides (Thiabendazole)', 'Handle fruit carefully to avoid bruising', 'Store fruit at correct temperature (13–14°C)', 'Use hot water treatment (50°C for 3 min)', 'Maintain good field sanitation'],
    severity: 'Medium',
    emoji: '🍌',
    imagePath: 'assets/images/anthracnose.png',
    colorCode: 0xFFE65100,
  ),
  DiseaseInfo(
    name: 'Banana Streak Virus',
    description: 'A viral disease caused by Banana Streak Virus (BSV). Spread through infected planting material and mealybugs.',
    symptoms: ['Yellow or pale green streaks on leaves', 'Chlorotic (yellow) patches on leaves', 'Irregular yellow-brown streaks', 'Reduced plant vigor', 'Distorted leaf shape'],
    treatments: ['Use certified virus-free planting material', 'Control mealybug populations', 'Remove heavily infected leaves', 'Avoid propagating from infected plants', 'Apply mineral oil sprays to reduce virus spread'],
    severity: 'Medium',
    emoji: '🟡',
    imagePath: 'assets/images/bsv.png',
    colorCode: 0xFF827717,
  ),
  DiseaseInfo(
    name: 'Cigar End Rot',
    description: 'A fungal disease caused by Verticillium theobromae and Trachysphaera fructigena. Affects the tip of developing fruit.',
    symptoms: ['Dark brown rot starting at fruit tip', 'Dry shriveled appearance like a cigar end', 'Spread from tip toward stalk', 'White fungal growth in wet conditions', 'Premature fruit death'],
    treatments: ['Remove infected fruit bunches early', 'Apply Thiram or Copper fungicides', 'Maintain proper field drainage', 'Avoid wounding fruit during handling', 'Remove dead floral tissue promptly'],
    severity: 'Low',
    emoji: '�',
    imagePath: 'assets/images/cigar_end_rot.png',
    colorCode: 0xFF4E342E,
  ),
  DiseaseInfo(
    name: 'Crown Rot',
    description: 'A post-harvest disease complex caused by several fungi (Fusarium, Colletotrichum, Lasiodiplodia). Attacks the crown of harvested banana hands.',
    symptoms: ['Dark water-soaked lesions on crown', 'White to grey fungal growth on crown', 'Soft rotting of crown tissue', 'Yellowing around crown area', 'Separation of individual fingers'],
    treatments: ['Use fungicide dips after harvest', 'Handle crowns carefully to minimize wounds', 'Maintain proper cold chain storage', 'Use clean cutting tools', 'Apply wax coatings on crown'],
    severity: 'High',
    emoji: '👑',
    imagePath: 'assets/images/crown_rot.png',
    colorCode: 0xFF880E4F,
  ),
  DiseaseInfo(
    name: 'Banana Tip Burn',
    description: 'A physiological or fungal condition causing browning and necrosis at leaf tips, often triggered by calcium deficiency or drought stress.',
    symptoms: ['Brown dry tips on young leaves', 'Tip necrosis spreading inward', 'Crispy brown leaf margins', 'Yellowing adjacent to brown areas', 'More severe on outer leaves'],
    treatments: ['Apply foliar calcium sprays', 'Ensure adequate and consistent watering', 'Avoid over-fertilizing with nitrogen', 'Mulch around base to retain soil moisture', 'Check soil pH and adjust if needed'],
    severity: 'Low',
    emoji: '🔥',
    imagePath: 'assets/images/tip_burn.png',
    colorCode: 0xFFFF8F00,
  ),
  DiseaseInfo(
    name: 'Healthy',
    description: 'The banana plant appears healthy with no signs of disease. Continue regular maintenance to keep it in good condition.',
    symptoms: ['Deep green, vibrant leaves', 'No spots or discoloration', 'Strong upright growth', 'Normal fruit development'],
    treatments: ['Regular watering and fertilization', 'Proper spacing between plants', 'Routine monitoring for early detection', 'Balanced NPK fertilizer application'],
    severity: 'None',
    emoji: '✅',
    imagePath: 'assets/images/healthy.png',
    colorCode: 0xFF2E7D32,
  ),
];
