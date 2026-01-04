# MouseKeepAlive

English | [简体中文](README.md)

A macOS intelligent tool designed to bypass enterprise IM online status detection. Keep your online status active even when you step away from your computer by simulating real user activities.

## Core Features

### 🎯 Bypass Online Detection
- **Prevent Offline Status**: Enterprise IM apps (DingTalk, WeChat Work, Feishu/Lark, etc.) detect online status through mouse/keyboard activity monitoring. This app intelligently simulates real operations to keep you online even when away from screen
- **Natural Simulation**: Tiny mouse movements (5-50 pixels configurable), nearly invisible to the naked eye, won't interfere with running programs
- **Smart Trigger**: Only activates when there's truly no activity, doesn't affect normal usage

### ⚙️ Flexible Configuration
- **Detection Interval**: 5/10/30/60/120 seconds options to adapt to different IM detection frequencies
- **Movement Range**: 5/10/20/50 pixels options to balance between stealth and effectiveness
- **Menu Bar Integration**: Lightweight design with minimal resource usage

## Installation

### Download Pre-built Version

1. Go to [Releases](https://github.com/alpacachen/MouseKeepAlive/releases) to download the latest version
2. Unzip and drag to Applications folder
3. Right-click -> Open for first launch

### Build from Source

```bash
git clone https://github.com/alpacachen/MouseKeepAlive.git
cd MouseKeepAlive
open MouseKeepAlive.xcodeproj
# Press Cmd + R in Xcode to run
```

## Permission Setup

The app requires **Accessibility permission** to function properly:

**System Settings** → **Privacy & Security** → **Accessibility** → Check `MouseKeepAlive`

## Usage

1. After launching, the app icon appears in the menu bar
2. Click the menu bar icon to configure detection interval and movement range
3. The app works automatically in the background

## Use Cases

- **Brief Absence**: Stay online when getting water or using the restroom, avoid showing offline status to colleagues/managers
- **Lunch Break**: Maintain online presence during lunch time for more "productive" working hours
- **Remote Work**: Handle other tasks at home without worrying about appearing away from desk
- **Multitasking**: When focusing on physical documents, phone, or other devices, your main computer still shows active

> ⚠️ **Usage Note**: This tool is only for reasonably maintaining online status. Please comply with company policies and regulations, and don't abuse it. Recommended for legitimate scenarios like brief desk absences.

## How It Works

Enterprise IM apps typically determine online status through:
1. Monitoring system idle time
2. Tracking last mouse/keyboard activity time

MouseKeepAlive's mechanism:
1. **Continuous Monitoring**: Real-time detection of actual mouse and keyboard activities
2. **Smart Detection**: When no activity detected within configured time
3. **Precise Simulation**: Execute tiny mouse movements (round-trip displacement, cursor position unchanged)
4. **Timer Reset**: System recognizes user activity, updates "last activity time"
5. **IM Detection**: Enterprise IM reads activity signal, maintains online status

The entire process is fully automated, requiring no manual intervention.

## System Requirements

- macOS 13.0 or higher

## Privacy & Security

- **Pure Local Execution**: All functions run locally, no network requests, no data collection
- **Open Source Transparency**: Code is fully open source, auditable by anyone
- **Minimal Permissions**: Only requires Accessibility permission for mouse movement simulation, doesn't access any personal information

## License

MIT License - See [LICENSE](LICENSE) file for details
