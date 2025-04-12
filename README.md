# 3D Test

<p align="center">
  <img src="3D Test/Resources/readme_logo.png" alt="3D Test Logo" width="550"/>
</p>

A SwiftUI application demonstrating 3D model integration and visualization with SceneKit, featuring an Anime Tropical theme.

## Overview

This project serves as a test environment for loading and displaying 3D USDZ models in a SwiftUI iOS application. It features a game-like interface with levels, power-up buttons, and a rotating 3D character model. The application follows an Anime Tropical theme with a pixel-art pirate girl character and a scenic seaside background.

## Features

- **3D Model Loading**: Loads and displays USDZ 3D models with automatic rotation animation
- **SceneKit Integration**: Custom SceneKit view embedded within SwiftUI
- **Transparent Background**: Support for transparent backgrounds to overlay 3D content
- **Fallback Handling**: Automatic creation of a 3D cube if model loading fails
- **Anime Theme**: 
  - Pixel-art anime pirate girl character (3D USDZ model)
  - Seaside background
  - Thematic UI elements
- **UI Components**: Various game-like UI elements including:
  - Current level display
  - Level selection buttons
  - Power-up button
  - Custom background

## Project Structure

```
3D Test/
├── Assets.xcassets/           # Asset catalog (images, colors, etc.)
├── Resources/                 # 3D models and other resources
│   └── Pixel_Anime_Character_Female.usdz
├── _D_TestApp.swift           # Application entry point
├── BackgroundView.swift       # Background image view
├── ContentView.swift          # Main content view
├── CurrentLevelView.swift     # Level indicator UI component
├── Model3DView.swift          # 3D model loader and renderer
└── PowerUpButton.swift        # Custom button component
```

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.5+

## Setup

1. Clone the repository
2. Open the project in Xcode
3. Build and run on an iOS device or simulator

## Working with 3D Models

To use your own 3D models:

1. Add USDZ files to the Resources directory
2. Reference them in your code:

```swift
Model3DView(modelName: "YourModelName")
```

The model loader will automatically handle loading, positioning, and animation.

## Development Notes

- The application uses SceneKit for 3D rendering
- Models are automatically rotated for 360° viewing
- Error handling provides a fallback cube if model loading fails
- Debug information is printed to console during model loading

## License

This project is intended for testing purposes.

## Future Improvements

- Add touch interaction with 3D models
- Implement model switching functionality
- Add physics interactions
- Support for animations embedded in USDZ files
- Expand the tropical theme with:
  - Ocean wave animations
  - More pirate/island-themed UI elements
  - Day/night cycle with appropriate lighting
  - Weather effects (rain, sunshine)