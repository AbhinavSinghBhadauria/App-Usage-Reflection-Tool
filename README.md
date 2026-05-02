The App Usage Reflection Tool is an iOS application that analyzes app usage patterns and transforms raw screen time data into meaningful insights about user behavior.

Unlike traditional tracking apps, this project focuses on **interpreting data**, helping users understand how they spend their time on mobile devices.



## Features

* Track app usage and screen time
*  Smart insights engine (behavior analysis)
*  Pull-to-refresh for real-time updates
*  Clean modern UI with dark theme
*  Smooth animations and transitions
*  Reusable SwiftUI components
*  Visual representation of app usage distribution


## Tech Stack

* **SwiftUI** – UI development
* **MVVM Architecture** – clean separation of concerns
* **Combine** – state management using `@Published` and `ObservableObject`


Project Structure

UsageInsight/
│
├── Models/
│   └── AppUsage.swift
│
├── ViewModels/
│   └── UsageViewModel.swift
│
├── Views/
│   ├── DashboardView.swift
│   └── AppRowView.swift

##  Key Learnings

* Implemented MVVM architecture for scalable app design
* Built dynamic UI using SwiftUI data binding
* Designed a custom insights engine to analyze usage patterns
* Created reusable UI components for maintainability
* Improved user experience with animations and interactive features

---

##  Future Improvements

* Integration with iOS Screen Time APIs
* Weekly and monthly analytics
* AI-based personalized recommendations
* Cloud sync for cross-device data

