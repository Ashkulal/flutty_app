# ShopNow Premium 🛍️✨

ShopNow is a professional-grade, high-performance E-commerce application built with Flutter and Supabase. It offers a seamless, premium shopping experience with a focus on modern design, speed, and zero-fee transactions.

## 🚀 Key Features

- **Premium Marketplace UI:** A sleek, Amazon-inspired interface designed for maximum user engagement.
- **Real-Time Data Sync:** Powered by Supabase for instantaneous product updates and inventory management.
- **Zero-Fee UPI Payments:** Integrated Deep Linking for Google Pay, PhonePe, and other UPI apps (NPCI Protocol).
- **Persistent Shopping Cart:** State-of-the-art local persistence ensures your cart is never lost.
- **Universal Wishlist:** Save your favorite items across sessions with long-term memory.
- **Gift Cards & Rewards:** Manage balances and redeem discount coupons (e.g., `SAVE20`) instantly.
- **Order History:** Professional tracking of past and active orders.

## 🛠️ Technical Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Supabase (PostgreSQL)
- **State Management:** Provider
- **Storage:** SharedPreferences (Local Persistence)
- **Deep Linking:** url_launcher (UPI Intent)

## 📦 How to Run

1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

2. **Supabase Setup:**
   Ensure your `products` table is initialized in Supabase with public read access.

3. **Run the App:**
   ```bash
   flutter run
   ```

---
*Built with ❤️ for a premium retail experience.*
