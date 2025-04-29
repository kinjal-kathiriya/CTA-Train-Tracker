# CTA-Train-Tracker

A real-time Chicago Transit Authority (CTA) train tracker app that displays arrivals, stations, and train lines with automatic refresh capabilities.

<img width="466" alt="Screenshot 2025-04-29 at 12 57 01 AM" src="https://github.com/user-attachments/assets/d1e7ae65-0799-415d-a07d-17722f3ed8a6" />

<img width="466" alt="Screenshot 2025-04-29 at 12 57 27 AM" src="https://github.com/user-attachments/assets/6b86aeee-c5ae-4574-ac96-41883448f4d5" />

<img width="466" alt="Screenshot 2025-04-29 at 12 57 49 AM" src="https://github.com/user-attachments/assets/98e4f440-fda5-4f1c-9d9c-692c6858d2c7" />

<img width="466" alt="Screenshot 2025-04-29 at 12 58 11 AM" src="https://github.com/user-attachments/assets/ccb3bad0-198f-4aa4-aa78-8d8178425266" />

<img width="466" alt="Screenshot 2025-04-29 at 12 58 33 AM" src="https://github.com/user-attachments/assets/acfdefaf-0fee-495e-95d1-59e7c6950889" />



## Features

🚇 **Comprehensive CTA Coverage**
- View all 8 CTA train lines (Red, Blue, Green, Brown, Orange, Pink, Purple, Yellow)
- See complete station lists for each line
- Real-time arrival predictions

⏱ **Automatic Updates**
- Arrival times refresh every 10 seconds
- Pull-to-refresh on all screens
- Background data fetching

🎨 **Authentic CTA Design**
- Official CTA color scheme
- Animated transitions
- System-friendly dark/light mode

🛠 **Robust Architecture**
- MVVM-inspired design
- Comprehensive error handling
- Mock data for development
- Unit test ready

## System Diagram 

![deepseek_mermaid_20250428_6e33a2](https://github.com/user-attachments/assets/eb727d96-b5e8-4325-a8dd-8c95015a37b0)


## Technical Details

```swift
struct TechSpecs {
    let platform = "iOS 15+"
    let architecture = "MVVM + Singleton"
    let networking = "URLSession + Combine"
    let persistence = "In-memory caching"
    let dependencies = "None (100% Swift)"
}



