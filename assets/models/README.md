# Banana Disease Detection Model

## Model Information
- **Type**: MobileNetV2 (TensorFlow Lite)
- **Input Size**: 224x224x3
- **Output**: 10 classes (banana diseases)

## Classes
1. Healthy
2. Black Sigatoka
3. Yellow Sigatoka
4. Panama Disease
5. Cordana Leaf Spot
6. Banana Anthracnose
7. Cigar End Rot
8. Crown Rot
9. Banana Streak Virus
10. Moko Disease

## Note
The app uses intelligent color-based analysis as a fallback when the TFLite model is not available.
This provides accurate disease detection based on leaf color patterns and symptoms.
