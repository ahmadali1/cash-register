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

#### Improvements:
- [ ] **Test Coverage:** Test coverage needs to be improved
- [ ] **TODOs:** TODOs comments on the code needs to be done (validations to be held in place + Edge Cases)
- [ ] **Reset:** [Nice to Have] Cart reset functionality should be there
- [ ] **Driver:** Ruby driver class needs to be implemented to make it a CLI application that will ask products data and discount rules and then ask which items to be scanned

