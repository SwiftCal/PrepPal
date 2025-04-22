# 🥗 PrepPal

## 📚 Table of Contents  
1. [Overview](#overview)  
2. [Product Spec](#product-spec)  
3. [Wireframes](#wireframes)  
4. [Schema](#schema)  

---

## 📖 Overview

### 📌 Description  
**PrepPal** is a mobile meal planning app that helps users generate weekly meal plans, create smart grocery lists, and reduce food waste by suggesting meals based on what they already have at home. The app is tailored for busy professionals, college students, and health-conscious users looking to simplify their cooking routine.

### ✅ App Evaluation

- **Category:** Food & Drink / Health  
- **Mobile:** Yes, mobile-only (iOS)  
- **Story:** PrepPal supports users in forming healthy eating habits by making meal planning, grocery shopping, and pantry tracking quick and painless.  
- **Market:** Busy professionals, college students, fitness-conscious individuals, families  
- **Habit:** Designed for regular (weekly or daily) use during meal planning, shopping, and cooking  
- **Scope:** Moderate scope — core focus on planning meals and grocery tracking with future support for pantry inventory and leftovers management

---

## 🛠 Product Spec

### 1. ✅ User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can register and log in to their account  
- [x] User sees a dashboard with a personalized greeting and this week’s meals  
- [x] User can view a scrollable list of featured meals with images, names, and prep times  
- [x] User can generate a new weekly meal plan  
- [ ] User can see a summary of their grocery list for the week  
- [x] User can check off grocery list items  
- [x] User can add pantry ingredients manually  
- [ ] User receives notifications about expiring pantry items  

**Optional Nice-to-have Stories**

- [ ] User can scan barcodes to add pantry items  
- [ ] User receives AI-powered suggestions using their pantry ingredients  
- [ ] User can save favorite meals  
- [ ] User can toggle between different diet types (vegan, keto, etc.)  
- [ ] User can link grocery list to an external delivery service (e.g., Instacart)  

---

### Development Progress
**Sprint 1**
![Screen Recording 2025-04-14 at 21 51 27](https://github.com/user-attachments/assets/3c3b4760-9698-44d4-9131-bb4c623a5f64)


### 2. 🧭 Screen Archetypes

- **Login/Sign Up Screen**  
  * User can log in or register for an account

- **Dashboard Screen**  
  * Personalized greeting, featured meals, grocery summary, and “Generate Plan” button

- **Meal Plan Detail Screen**  
  * User can view full meal details for each recipe

- **Grocery List Screen**  
  * User can see and check off ingredients grouped by category (Produce, Protein, etc.)

- **Pantry Screen**  
  * User can add, edit, or delete pantry ingredients manually  

- **Settings/Profile Screen**  
  * User can manage account info, preferences, and log out  

---

### 3. 🔄 Navigation

**Tab Navigation** (Tab to Screen)

- 🏠 Dashboard  
- 🧺 Grocery List  
- 🍱 Pantry  
- 👤 Profile  

**Flow Navigation** (Screen to Screen)

- **Login Screen**  
  * Leads to **Dashboard Screen**

- **Dashboard Screen**  
  * Leads to **Meal Plan Detail Screen**

- **Dashboard Screen**  
  * Leads to **Grocery List Screen**

- **Dashboard Screen**  
  * Leads to **Pantry Screen**

---

## 📝 Wireframes

### Dashboard Page
![Dashboard](https://github.com/user-attachments/assets/7cf2a060-d515-4fce-a8a0-94ce75dc4735)

### Login / Signup Page
![Login Page](https://github.com/user-attachments/assets/103ee6f0-e5bf-42af-b405-138749c4a212)

### Profile Page
![Profile](https://github.com/user-attachments/assets/0c599e6d-8a1c-4580-abbc-8bddc49c32d5)

### Grocery List Page
![Grocery List](https://github.com/user-attachments/assets/ea61075c-7a20-4eec-a352-2a019dc71ca0)

### Pantry Page
![Pantry](https://github.com/user-attachments/assets/e7660c60-3507-4b1f-9084-2b4f995b9714)

### Meal Detail Page
![Meal Detail Page](https://github.com/user-attachments/assets/a9bbdec4-7117-4c73-a6db-6afa18a48154)

### Scan Food Page
![scan page - preppal](https://github.com/user-attachments/assets/3ba42dbb-8646-4914-9f3d-c6806f6da4cd)

---

## 🧬 Schema

### 📦 Models

#### 👤 User  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for each user                |
| email         | String   | Email address                          |
| password      | String   | Hashed password for login              |
| dietaryPrefs  | [String] | List of dietary preferences (vegan, etc.) |

#### 🍽️ Meal  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for each meal                |
| name          | String   | Name of the meal                       |
| imageURL      | String   | URL to meal image                      |
| prepTime      | Int      | Estimated time in minutes              |
| ingredients   | [String] | List of ingredient names               |

#### 🛒 GroceryItem  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for grocery item             |
| name          | String   | Ingredient name                        |
| quantity      | String   | Amount (e.g., "1 lb", "5 pieces")      |
| category      | String   | Group (e.g., Produce, Dairy)           |
| isChecked     | Bool     | Whether user has checked it off        |

#### 🧊 PantryItem  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for pantry item              |
| name          | String   | Name of ingredient                     |
| quantity      | String   | Amount                                 |
| expiration    | Date     | Optional: Expiry date                  |

---

### 🌐 Networking

#### 🔐 [Login / Signup]
- `[POST] /register` – create a new account  
- `[POST] /login` – log in and return session token  

#### 🍽️ [Meal Plan]
- `[GET] /meals` – retrieve suggested meals  
- `[POST] /meals/generate` – generate new weekly plan  

#### 🛒 [Grocery List]
- `[GET] /grocery-list` – get current grocery list  
- `[POST] /grocery-list/check` – update item as checked  

#### 🧊 [Pantry]
- `[GET] /pantry` – get pantry items  
- `[POST] /pantry/add` – add new pantry item  
- `[DELETE] /pantry/{id}` – remove pantry item  

> *(Note: Some endpoints will use Firebase or a third-party API like Spoonacular)*

