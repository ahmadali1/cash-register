# Cash Register Checkout System - Scan and Total Flow

## System Architecture Diagram

```mermaid
graph TB
    %% Main Classes
    subgraph "Core Classes"
        Checkout[Checkout Class]
        Product[Product Class]
        Discount[Discount Base Class]
    end
    
    %% Discount Types
    subgraph "Discount Types"
        RatioDiscount[RatioDiscount]
        FlatDiscount[FlatDiscount]
        BundleDiscount[BundleDiscount]
    end
    
    %% Data Structures
    subgraph "Checkout Data"
        Cart["Cart Array<br/>List of Product objects"]
        ProductCount["Product Count Hash<br/>code => count"]
    end
    
    %% Inheritance
    Discount --> RatioDiscount
    Discount --> FlatDiscount
    Discount --> BundleDiscount
    
    %% Relationships
    Product --> |has discount_rule| Discount
    Checkout --> |manages| Cart
    Checkout --> |tracks| ProductCount
    Checkout --> |contains| Product
```

## Scan Process Flow

```mermaid
sequenceDiagram
    participant User
    participant Checkout
    participant Cart
    participant ProductCount
    
    User->>Checkout: scan(product)
    Checkout->>Cart: << product
    Checkout->>ProductCount: increment count for product.code
    Checkout-->>User: self (for method chaining)
```

## Total Calculation Flow

```mermaid
flowchart TD
    A[Checkout.total] --> B[Calculate base total]
    B --> C[Sum all product prices]
    C --> D[Subtract total discount]
    D --> E[Return final total]
    
    subgraph "Discount Calculation"
        F[For each product code] --> G[Find product in cart]
        G --> H{Has discount_rule?}
        H -->|No| I[Skip - no discount]
        H -->|Yes| J[Calculate discount]
        J --> K[Apply discount rule]
        K --> L[Add to total discount]
    end
    
    D --> F
    I --> L
    L --> F
```

## Discount Calculation Examples

```mermaid
graph LR
    subgraph "Ratio Discount"
        RD1["Product Price: $10<br/>Count: 3<br/>Ratio: 0.2<br/>Min Units: 2"]
        RD2["Per Unit Discount<br/>$10 - ($10 * 0.2) = $8<br/>Total Discount: $6"]
    end
    
    subgraph "Flat Discount"
        FD1["Product Price: $10<br/>Count: 3<br/>Discounted Amount: $7<br/>Min Units: 2"]
        FD2["Per Unit Discount<br/>$10 - $7 = $3<br/>Total Discount: $9"]
    end
    
    subgraph "Bundle Discount"
        BD1["Product Price: $10<br/>Count: 5<br/>Buy 2 Get 1 Free<br/>Min Units: 2"]
        BD2["Items per deal: 3<br/>Complete deals: 1<br/>Free items: 1<br/>Total Discount: $10"]
    end
```

## Data Flow Diagram

```mermaid
graph TD
    subgraph "Input"
        Product1[Product A - $10]
        Product2[Product B - $15]
        Product3[Product A - $10]
    end
    
    subgraph "Checkout State"
        CartState["Cart: [Product A, Product B, Product A]"]
        CountState["Product Count:<br/>A => 2<br/>B => 1"]
    end
    
    subgraph "Calculation"
        BaseTotal[Base Total: $35]
        DiscountCalc[Discount Calculation]
        FinalTotal[Final Total: $35 - discount]
    end
    
    Product1 --> CartState
    Product2 --> CartState
    Product3 --> CartState
    CartState --> CountState
    CountState --> BaseTotal
    CountState --> DiscountCalc
    BaseTotal --> FinalTotal
    DiscountCalc --> FinalTotal
```

## Key Methods Summary

| Method | Purpose | Returns |
|--------|---------|---------|
| `scan(product)` | Add product to cart and increment count | `self` (for chaining) |
| `total` | Calculate final price with discounts | `Float` (rounded to 2 decimals) |
| `discount` | Calculate total discount across all products | `Float` |
| `calculate_discount_for(product)` | Calculate discount for specific product | `Float` |

## Discount Rules

1. **Ratio Discount**: Reduces price by percentage (e.g., 20% off)
2. **Flat Discount**: Reduces price by fixed amount (e.g., $3 off)
3. **Bundle Discount**: Buy X get Y free (e.g., Buy 2 Get 1 Free)

All discounts require a minimum number of units to activate. 