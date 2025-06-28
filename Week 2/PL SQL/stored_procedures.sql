
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE accounts CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE employees CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE accounts (
    account_id     NUMBER PRIMARY KEY,
    customer_name  VARCHAR2(50),
    account_type   VARCHAR2(20),
    balance        NUMBER(10,2)
);

CREATE TABLE employees (
    employee_id    NUMBER PRIMARY KEY,
    name           VARCHAR2(50),
    department     VARCHAR2(30),
    salary         NUMBER(10,2)
);

INSERT INTO accounts VALUES (1, 'John Doe', 'Savings', 10000.00);
INSERT INTO accounts VALUES (2, 'Jane Smith', 'Savings', 8000.00);
INSERT INTO accounts VALUES (3, 'Alice Brown', 'Current', 5000.00);
INSERT INTO accounts VALUES (4, 'Tom White', 'Savings', 20000.00);
INSERT INTO accounts VALUES (5, 'Emma Green', 'Current', 15000.00);
INSERT INTO accounts VALUES (6, 'Mike Black', 'Savings', 12000.00);

INSERT INTO employees VALUES (101, 'Raj Patel', 'HR', 50000.00);
INSERT INTO employees VALUES (102, 'Anita Desai', 'IT', 60000.00);
INSERT INTO employees VALUES (103, 'Sunil Rao', 'Finance', 55000.00);
INSERT INTO employees VALUES (104, 'Priya Mehta', 'IT', 65000.00);
INSERT INTO employees VALUES (105, 'Karan Singh', 'HR', 48000.00);

COMMIT;

-- Scenario 1: Process Monthly Interest
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
    UPDATE accounts
    SET balance = balance + (balance * 0.01)
    WHERE account_type = 'Savings';

    DBMS_OUTPUT.PUT_LINE('Monthly interest applied to all savings accounts.');
END;
/

-- Scenario 2: Update Employee Bonus
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    dept_name IN VARCHAR2,
    bonus_pct IN NUMBER
) AS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * bonus_pct / 100)
    WHERE department = dept_name;

    DBMS_OUTPUT.PUT_LINE('Bonus applied to employees in department: ' || dept_name);
END;
/

-- Scenario 3: Transfer Funds
CREATE OR REPLACE PROCEDURE TransferFunds(
    from_account IN NUMBER,
    to_account IN NUMBER,
    amount IN NUMBER
) AS
    from_balance NUMBER;
BEGIN
    SELECT balance INTO from_balance FROM accounts WHERE account_id = from_account FOR UPDATE;

    IF from_balance < amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
    END IF;

    UPDATE accounts SET balance = balance - amount WHERE account_id = from_account;
    UPDATE accounts SET balance = balance + amount WHERE account_id = to_account;

    DBMS_OUTPUT.PUT_LINE('Transferred ' || amount || ' from account ' || from_account || ' to account ' || to_account);
END;
/

-- Test Queries (Optional)
-- EXEC ProcessMonthlyInterest;
-- EXEC UpdateEmployeeBonus('IT', 10);
-- EXEC TransferFunds(1, 2, 2000);

SELECT * FROM accounts ORDER BY account_id;
SELECT * FROM employees ORDER BY employee_id;
