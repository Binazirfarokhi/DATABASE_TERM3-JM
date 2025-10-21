# Summary of AI Use for Assignment

**AI Name & Model**: Grok 3, built by xAI

**Title**: Using Old Values in an INSTEAD OF INSERT Trigger in SQLite

**My Prompt**:  
In SQLite, how to use the old value when creating a trigger for instead of insert on a view, I want to update another table. I need to access old value to compute for the new value. Write on an .md file. Format it with AI Name & Model: Title: My Prompt: (including formatting requirements) AI Answer:

**AI Answer**:  
In SQLite, `INSTEAD OF INSERT` triggers on views don’t support the `OLD` keyword, as it’s used for `UPDATE` or `DELETE` triggers to reference existing rows. To access "old" values (existing data) for computation in an `INSTEAD OF INSERT` trigger, query the underlying table directly using `NEW` values to identify the row.

**Example**:  
Suppose you have a table `products` (id, stock, price) and a view `product_updates`. You want an `INSERT` on the view to update `products` by adding to the existing stock.

```sql
-- Table
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    stock INTEGER NOT NULL,
    price REAL NOT NULL
);

-- View
CREATE VIEW product_updates AS
SELECT id, stock, price FROM products;

-- Trigger
CREATE TRIGGER update_stock_instead_of_insert
INSTEAD OF INSERT ON product_updates
FOR EACH ROW
BEGIN
    UPDATE products
    SET
        stock = (SELECT stock FROM products WHERE id = NEW.id) + NEW.stock,
        price = NEW.price
    WHERE id = NEW.id
    AND EXISTS (SELECT 1 FROM products WHERE id = NEW.id);

    INSERT OR IGNORE INTO products (id, stock, price)
    SELECT NEW.id, NEW.stock, NEW.price
    WHERE NOT EXISTS (SELECT 1 FROM products WHERE id = NEW.id);
END;
```

**Explanation**:  
- The trigger updates `products` by adding `NEW.stock` to the current `stock` (queried using `SELECT stock FROM products WHERE id = NEW.id`).  
- If the `id` doesn’t exist, it inserts a new row.  
- Use `EXISTS` to check for existing rows and avoid `NULL` issues in calculations.