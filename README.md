# Healing Pet App

## Project Introduction

Healing Pet App is a therapeutic pet interaction application designed to provide emotional support and psychological comfort through virtual pet interactions, breathing exercises, and conversation features.

### Core Features

- **Pet Interaction**: Interact with cute virtual pets to enhance emotional connection
- **Breathing Exercises**: Guided breathing exercises to help users relax
- **Smart Dialogue**: Simple conversation exchange with pets
- **Mood Recording**: Record and track user's emotional state
- **Interaction Count**: Record interaction times with pets to enhance sense of achievement

## Screenshots

<img src="./docs/start.png" width="200"><img src="./docs/touch.png" width="200"><img src="./docs/chat.png" width="200"><img src="./docs/breath.png" width="200">

<img src="./docs/start_dark.png" width="200"><img src="./docs/touch_dark.png" width="200"><img src="./docs/chat_dark.png" width="200"><img src="./docs/breath_dark.png" width="200">

## Tech Stack

- **Development Language**: Swift
- **UI Framework**: SwiftUI
- **State Management**: ObservableObject
- **Project Structure**: MVVM Architecture

## Project Structure

```
healing-pet-app/
├── Assets.xcassets/           # Resource files
├── Models/                    # Data models
│   └── Models.swift
├── Stores/                    # State management
│   └── PetStore.swift
├── Utils/                     # Utility classes and themes
│   └── Theme.swift
├── Views/                     # View files
│   ├── ContentView.swift
│   ├── OnboardingView.swift
│   └── PetMainView.swift
├── healing_pet_app.entitlements
└── healing_pet_appApp.swift   # App entry point
```

## Installation Instructions

1. Clone the project to your local machine
2. Open `healing-pet-app.xcodeproj` file with Xcode
3. Select target device or simulator
4. Click the run button to launch the app

## Usage

### Main Interface
- **Top**: Mood selection buttons and interaction count
- **Middle**: Pet display area, showing different content based on current mode
- **Bottom**: Three function buttons (Pet, Chat, Breathe)

### Mode Switching
- **Pet Mode**: Interact with the pet to enhance emotional connection
- **Chat Mode**: Have conversations with the pet
- **Breathe Mode**: Perform guided breathing exercises

## Development Notes

### Adding New Features
- Create new files in the corresponding directories for new features
- Follow Swift coding standards and best practices
- Maintain clear code structure for easy maintenance

### Testing
- Ensure testing on different devices and system versions
- Check app display on different screen sizes

## Contribution

Issues and Pull Requests are welcome to help improve this project.

## License

MIT License