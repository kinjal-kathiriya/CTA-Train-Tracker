# CTA-Train-Tracker

A real-time Chicago Transit Authority (CTA) train tracker app that displays arrivals, stations, and train lines with automatic refresh capabilities.

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

## Technical Details

```swift
struct TechSpecs {
    let platform = "iOS 15+"
    let architecture = "MVVM + Singleton"
    let networking = "URLSession + Combine"
    let persistence = "In-memory caching"
    let dependencies = "None (100% Swift)"
}




