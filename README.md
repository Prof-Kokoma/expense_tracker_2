# expense_tracker_2

# Expense Tracker App
This is an Expense Tracker app built using Flutter with a local database implemented using shared_preferences.

## Overview
The Expense Tracker app allows users to keep track of their expenses. Users can add, edit, and delete expenses, categorize them, and view their spending history. The app provides a simple and efficient way to manage personal finances.

## Features
Expense Management: Add, edit, and delete expenses.
Expense Categories: Categorize expenses for better organization.
Expense History: View a history of past expenses.
Local Database: Utilizes shared_preferences for storing expense data locally.
User-Friendly Interface: An intuitive and user-friendly design for easy navigation.
Getting Started
Follow these steps to get the app up and running on your local development environment.

### UIs
- Home Screen

![image](https://github.com/Prof-Kokoma/expense_tracker_2/assets/59128052/2ca0ac95-0390-4f96-b456-1401ed1583a4)

![image](https://github.com/Prof-Kokoma/expense_tracker_2/assets/59128052/0481a453-1522-4dbf-a7c9-9410ec864bee)

![image](https://github.com/Prof-Kokoma/expense_tracker_2/assets/59128052/7d8b51e8-32a2-4f9b-9569-c0e61543e8dd)

- Category Screen
  
 ![image](https://github.com/Prof-Kokoma/expense_tracker_2/assets/59128052/32d96ea1-039d-45f4-a237-f159de2a8833)


### Prerequisites
Flutter must be installed on your system.
Installation
Clone this repository to your local machine:

bash
Copy code
git clone https://github.com/your-username/expense-tracker-app.git
Navigate to the project directory:

bash
Copy code
cd expense-tracker-app
Install dependencies:

bash
Copy code
flutter pub get
Running the App
Run the app on an emulator or physical device:

bash
Copy code
flutter run
### Usage
Adding Expenses: Tap the "+" button to add a new expense. Fill in the details and save.
Editing Expenses: Tap an expense from the list to edit its details.
Deleting Expenses: Swipe left on an expense in the list to delete it.
Categorizing Expenses: Assign a category to each expense for better organization.
Viewing Expense History: Navigate to the history section to see a list of past expenses.
Local Database (shared_preferences)
The app uses shared_preferences to store expense data locally on the user's device. This ensures that expense data persists even after app restarts. You can find the database logic in the lib/data/database.dart file.

Contributing
If you'd like to contribute to this project, please follow these guidelines:

Fork the repository.
Create a new branch for your feature or bug fix: git checkout -b feature/your-feature-name
Make your changes and commit them: git commit -m "Add new feature"
Push your changes to your fork: git push origin feature/your-feature-name
Create a pull request to the main branch of the original repository.
License
This project is licensed under the MIT License - see the LICENSE file for details.

### Acknowledgments
Thank you to the Flutter community for providing valuable resources and plugins.
Inspired by the need for a simple expense-tracking solution.
### Contact
If you have any questions or suggestions, please feel free to contact us at your.email@example.com.

