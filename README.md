# PrepPal

## Table of Contents  
1. [Overview](#overview)  
2. [Product Spec](#product-spec)  
3. [Wireframes](#wireframes)  
4. [Schema](#schema)  

---

## Overview

### Description  
**PrepPal** is a mobile meal planning app that helps users generate weekly meal plans, create smart grocery lists, and reduce food waste by suggesting meals based on what they already have at home. The app is tailored for busy professionals, college students, and health-conscious users looking to simplify their cooking routine.

### App Evaluation

- **Category:** Food & Drink / Health  
- **Mobile:** Yes, mobile-only (iOS)  
- **Story:** PrepPal supports users in forming healthy eating habits by making meal planning, grocery shopping, and pantry tracking quick and painless.  
- **Market:** Busy professionals, college students, fitness-conscious individuals, families  
- **Habit:** Designed for regular (weekly or daily) use during meal planning, shopping, and cooking  
- **Scope:** Moderate scope — core focus on planning meals and grocery tracking with future support for pantry inventory and leftovers management

---

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can register and log in to their account  
- [x] User sees a dashboard with a personalized greeting and this week’s meals  
- [x] User can view a scrollable list of featured meals with images, names, and prep times  
- [x] User can generate a new weekly meal plan  
- [x] User can see a summary of their grocery list for the week  
- [x] User can check off grocery list items  
- [x] User can add pantry ingredients manually  
- [x] User receives notifications about expiring pantry items  

**Optional Nice-to-have Stories**

- [ ] User can scan barcodes to add pantry items  
- [ ] User receives AI-powered suggestions using their pantry ingredients  
- [ ] User can save favorite meals  
- [ ] User can toggle between different diet types (vegan, keto, etc.)  
- [ ] User can link grocery list to an external delivery service (e.g., Instacart)  

---

### 2. Screen Archetypes

- [ ] **Login/Sign Up Screen**  
  * User can log in or register for an account

- [ ] **Dashboard Screen**  
  * Personalized greeting, featured meals, grocery summary, and “Generate Plan” button

- [ ] **Meal Plan Detail Screen**  
  * User can view full meal details for each recipe

- [ ] **Grocery List Screen**  
  * User can see and check off ingredients grouped by category (Produce, Protein, etc.)

- [ ] **Pantry Screen**  
  * User can add, edit, or delete pantry ingredients manually  

- [ ] **Settings/Profile Screen**  
  * User can manage account info, preferences, and log out  

---

### 3. Navigation

**Tab Navigation** (Tab to Screen)

- [x] Dashboard  
- [x] Grocery List  
- [x] Pantry  
- [x] Profile  

**Flow Navigation** (Screen to Screen)

- [ ] **Login Screen**  
  * Leads to **Dashboard Screen**

- [ ] **Dashboard Screen**  
  * Leads to **Meal Plan Detail Screen**

- [ ] **Dashboard Screen**  
  * Leads to **Grocery List Screen**

- [ ] **Dashboard Screen**  
  * Leads to **Pantry Screen**

---

## Wireframes

[Insert hand-drawn or digital wireframes here once created. This can be a PDF or image upload.]

### [BONUS] Digital Wireframes & Mockups  
[Optional: Add Figma or XD mockups here]

### [BONUS] Interactive Prototype  
[Optional: Add prototype link here]

---

## Schema

### Models

#### User  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for each user                |
| email         | String   | Email address                          |
| password      | String   | Hashed password for login              |
| dietaryPrefs  | [String] | List of dietary preferences (vegan, etc.) |

#### Meal  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for each meal                |
| name          | String   | Name of the meal                       |
| imageURL      | String   | URL to meal image                      |
| prepTime      | Int      | Estimated time in minutes              |
| ingredients   | [String] | List of ingredient names               |

#### GroceryItem  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for grocery item             |
| name          | String   | Ingredient name                        |
| quantity      | String   | Amount (e.g., "1 lb", "5 pieces")      |
| category      | String   | Group (e.g., Produce, Dairy)           |
| isChecked     | Bool     | Whether user has checked it off        |

#### PantryItem  
| Property      | Type     | Description                            |
|---------------|----------|----------------------------------------|
| id            | String   | Unique ID for pantry item              |
| name          | String   | Name of ingredient                     |
| quantity      | String   | Amount                                 |
| expiration    | Date     | Optional: Expiry date                  |

---

### Networking

#### [Login / Signup]
- `[POST] /register` – create a new account  
- `[POST] /login` – log in and return session token  

#### [Meal Plan]
- `[GET] /meals` – retrieve suggested meals  
- `[POST] /meals/generate` – generate new weekly plan  

#### [Grocery List]
- `[GET] /grocery-list` – get current grocery list  
- `[POST] /grocery-list/check` – update item as checked  

#### [Pantry]
- `[GET] /pantry` – get pantry items  
- `[POST] /pantry/add` – add new pantry item  
- `[DELETE] /pantry/{id}` – remove pantry item  

> *(Note: Some endpoints will use Firebase or a third-party API like Spoonacular)*

