# shopswiftgh

ShopSwift

A complete Flutter-based e-commerce application that integrates both User and Admin functionalities into a single project.

Project Overview

ShopSwift is a cross-platform mobile and web application built with Flutter. The app provides a seamless shopping experience for customers while also including an admin dashboard for product management. Unlike most e-commerce apps that separate the admin and user sides, ShopSwift combines both, making it easy to test, manage, and demonstrate within a single codebase.

The user side allows customers to browse products, view details, and manage their profiles. The admin side provides tools to add, update, categorize, and delete products in real time using Firebase Firestore. Images are hosted via external providers such as Cloudinary, ensuring fast loading and easy integration.

This project was built with scalability and responsiveness in mind, making it usable on mobile, tablet, and desktop screens.



Features

User Side

Authentication: Users can sign up and log in using Firebase Authentication.

Product Browsing: Products are displayed in categories such as Electronics, Fashion, Home, Books, and Beauty.

Product Details: Each product shows its name, price, description, category, and image.

Profile Management: Usernames are fetched dynamically from Firestore (not hard-coded).

Responsive UI: Works smoothly across devices with different screen sizes.


Admin Side

Add Products: Enter product name, description, price, category, and image URL.

Edit Products: Update product details with a single tap.

Delete Products: Remove products from the catalog.

Category Assignment: Products can be grouped under predefined categories.

Image Handling: Instead of local uploads, images are linked via Cloudinary URLs.

Real-time Updates: All product changes instantly reflect for users through Firestore’s live sync.


Tech Stack

Flutter: Frontend framework for cross-platform app development

Firebase Authentication: Secure user login and registration

Firebase Firestore: Real-time NoSQL database for storing products and user info

Cloudinary (or any image hosting): External hosting for product images

Material Design: For consistent and modern UI components


How to Run Locally

1. Clone the Repository

git clone <repo-url>
cd ShopSwift


2. Install Dependencies

flutter pub get


3. Setup Firebase

Add google-services.json to android/app/

Add GoogleService-Info.plist to ios/Runner/



4. Run the App

flutter run

