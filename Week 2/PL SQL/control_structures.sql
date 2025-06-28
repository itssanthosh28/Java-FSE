
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE loans CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE customers (
    customer_id   NUMBER PRIMARY KEY,
    name          VARCHAR2(50),
    age           NUMBER,
    balance       NUMBER(10,2),
    interest_rate NUMBER(5,2),
    IsVIP         VARCHAR2(5) DEFAULT 'FALSE'
);

CREATE TABLE loans (
    loan_id      NUMBER PRIMARY KEY,
    customer_id  NUMBER,
    due_date     DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES (1, 'John Doe', 65, 15000.00, 8.5, 'FALSE');
INSERT INTO customers VALUES (2, 'Jane Smith', 45, 9500.00, 9.0, 'FALSE');
INSERT INTO customers VALUES (3, 'Bob Johnson', 70, 12000.00, 7.5, 'FALSE');
INSERT INTO customers VALUES (4, 'Alice Williams', 30, 11000.00, 10.0, 'FALSE');
INSERT INTO customers VALUES (5, 'Tom Brown', 62, 5000.00, 8.0, 'FALSE');
INSERT INTO customers VALUES (6, 'Nancy Davis', 55, 20000.00, 9.2, 'FALSE');
INSERT INTO customers VALUES (7, 'Chris Wilson', 67, 3000.00, 8.7, 'FALSE');
INSERT INTO customers VALUES (8, 'Emma Thomas', 28, 12500.00, 9.8, 'FALSE');
INSERT INTO customers VALUES (9, 'Mike Taylor', 40, 8000.00, 8.3, 'FALSE');
INSERT INTO customers VALUES (10, 'Olivia Martin', 61, 10500.00, 7.9, 'FALSE');

INSERT INTO loans VALUES (101, 1, SYSDATE + 10);
INSERT INTO loans VALUES (102, 2, SYSDATE + 40);
INSERT INTO loans VALUES (103, 3, SYSDATE + 25);
INSERT INTO loans VALUES (104, 4, SYSDATE + 5);
INSERT INTO loans VALUES (105, 5, SYSDATE - 10);
INSERT INTO loans VALUES (106, 6, SYSDATE + 20);
INSERT INTO loans VALUES (107, 7, SYSDATE + 15);
INSERT INTO loans VALUES (108, 8, SYSDATE + 60);
INSERT INTO loans VALUES (109, 9, SYSDATE + 1);
INSERT INTO loans VALUES (110, 10, SYSDATE + 90);

COMMIT;

-- Scenario 1: Discount for Age > 60
BEGIN
    FOR cust IN (
        SELECT customer_id, interest_rate
        FROM customers
        WHERE age > 60
    )
    LOOP
        UPDATE customers
        SET interest_rate = interest_rate - 1
        WHERE customer_id = cust.customer_id;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('1% discount applied for customers above age 60.');
END;
/

-- Scenario 2: Set VIP for Balance > 10000
BEGIN
    FOR cust IN (
        SELECT customer_id
        FROM customers
        WHERE balance > 10000
    )
    LOOP
        UPDATE customers
        SET IsVIP = 'TRUE'
        WHERE customer_id = cust.customer_id;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('VIP status set for customers with balance > $10,000.');
END;
/

-- Scenario 3: Loan Due Reminders (Next 30 Days)
BEGIN
    FOR loan_rec IN (
        SELECT customer_id, loan_id, due_date
        FROM loans
        WHERE due_date BETWEEN SYSDATE AND SYSDATE + 30
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || loan_rec.loan_id ||
                             ' for Customer ID ' || loan_rec.customer_id ||
                             ' is due on ' || TO_CHAR(loan_rec.due_date, 'DD-MON-YYYY'));
    END LOOP;
END;
/

SELECT customer_id, name, age, interest_rate FROM customers ORDER BY customer_id;
SELECT customer_id, name, balance, IsVIP FROM customers ORDER BY customer_id;
