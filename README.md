# Cash Register
Ruby application that add products to the cart and calculate total price.

<details>
  <summary>Description</summary>

### Assumptions 

**Products Registered**
| Product Code | Name | Price |  
|--|--|--|
| GR1 |  Green Tea | 3.11€ |
| SR1 |  Strawberries | 5.00 € |
| CF1 |  Coffee | 11.23 € |

**Special conditions**

- The CEO is a big fan of buy-one-get-one-free offers and green tea. 
He wants us to add a  rule to do this.

- The COO, though, likes low prices and wants people buying strawberries to get a price  discount for bulk purchases. 
If you buy 3 or more strawberries, the price should drop to 4.50€.

- The VP of Engineering is a coffee addict. 
If you buy 3 or more coffees, the price of all coffees should drop to 2/3 of the original price.

Our check-out can scan items in any order, and because the CEO and COO change their minds  often, it needs to be flexible regarding our pricing rules.

**Test data**
| Basket | Total price expected |  
|--|--|
| GR1,GR1 |  3.11€ |
| SR1,SR1,GR1,SR1 |  16.61€ |
| GR1,CF1,SR1,CF1,CF1 |  30.57€ |
</details>
  
## Solution:

<details>
  <summary>Pre Requisite</summary>

  To Setup this Repo:

- Ruby 3.0.2 should be installed locally

- Bundler should be installed locally

- Rspec gem should be installed locally

Or Alternatively create Gemfile in the Repo after clonning
</details>

**Entities:**
TDD approach is followed to build the following entities:

1) Checkout: It contains scan and total methods. Scan method add products to the cart. Total method computes the total pricing of the products that are stored in the cart.
2) Product: It containts code, price, name and discount rules. Each product can have different discount rule. 
3) Discount: Abstract base class that defines the discount calculation interface. Child classes implement specific discount strategies:
   - FlatDiscount: Reduces price by a fixed amount per unit
   - RatioDiscount: Reduces price by a percentage per unit  
   - BundleDiscount: Provides free units when minimum quantity is met (buy-X-get-Y)

## CLI Driver

The application includes an interactive CLI driver that provides the best UX for setting up products and scanning items.

### Running the CLI

```bash
# Option 1: Using the executable script
./bin/cash_register

# Option 2: Direct Ruby execution
ruby lib/drivers/main.rb
```

### CLI Features

#### **1. Product Setup Phase**
- Interactive product creation with codes, names, and prices
- Support for all discount types:
  - **Flat Discount**: Fixed amount off per unit
  - **Ratio Discount**: Percentage off per unit
  - **Bundle Discount**: Buy X get Y free
  - **No Discount**: Regular pricing

#### **2. Scanning Phase**
- **Individual Scanning**: `scan <code>` - Add one product
- **Batch Scanning**: `batch <codes>` - Add multiple products at once
- **Cart Management**: View cart contents, clear cart
- **Total Calculation**: See original price, discount applied, and final total

#### **3. Available Commands**
```
scan <code>     : Add product to cart
batch <codes>   : Scan multiple products (space-separated)
total           : Calculate and display total
cart            : Show current cart contents
products        : Show all available products
clear           : Clear cart
help            : Show help
quit/exit       : Exit the application
```

### Example Usage

```
==================================================
🎯 CASH REGISTER SYSTEM
==================================================
Welcome! Let's set up your products and start scanning.

📦 PRODUCT SETUP PHASE
------------------------------
Enter product details (or 'done' to finish):

Product Code (e.g., GR1): GR1
Product Name (e.g., Green Tea): Green Tea
Price (e.g., 3.11): 3.11

Select discount type:
1. No discount
2. Flat discount (fixed amount off per unit)
3. Ratio discount (percentage off per unit)
4. Bundle discount (buy X get Y free)
Choice (1-4): 4
Buy how many units: 1
Get how many free: 1
✅ Product 'Green Tea' added successfully!

Product Code (e.g., GR1): done

📋 PRODUCTS SUMMARY
------------------------------
GR1: Green Tea (€3.11) - Buy 1 get 1 free

🛒 SCANNING PHASE
------------------------------
📖 AVAILABLE COMMANDS:
scan <code>     : Add product to cart
batch <codes>   : Scan multiple products (space-separated)
total           : Calculate and display total
cart            : Show current cart contents
products        : Show all available products
clear           : Clear cart
help            : Show this help
quit/exit       : Exit the application

> scan GR1
✅ Added: Green Tea (€3.11)

> scan GR1
✅ Added: Green Tea (€3.11)

> total
💰 TOTAL CALCULATION:
-------------------------
Original total: €6.22
Discount applied: €3.11
Final total: €3.11
```

#### Improvements:
- [ ] **Test Coverage:** Test coverage needs to be improved
- [ ] **TODOs:** TODOs comments on the code needs to be done (validations to be held in place + Edge Cases)
- [ ] **Reset:** [Nice to Have] Cart reset functionality should be there
- [x] **Driver:** Ruby driver class has been implemented with best UX design

