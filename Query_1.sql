/* Hrithika Saranga */
/*Overview Dashboard*/
/* For this scenario, the current month is considered as November, 2021 */ 

/* Query to retreieve total loan applications */
SELECT COUNT(id) AS TotaL_loan_Applications FROM Loan_Information_Data

/* Query to retreieve total funded amount */
SELECT SUM(loan_amount) AS TotaL_loan_Amount FROM Loan_Information_Data

/* Query to retrieve how much amount has been received by the bank */
SELECT SUM(total_payment) AS Total_Payment_Amount FROM Loan_Information_Data

/* Query to calculate average interest rate */
SELECT ROUND(AVG(int_rate), 4) * 100 AS MTD_Average_Interest_Rate FROM Loan_Information_Data

/* Query to retrieve Average debt to income ratio */
SELECT AVG(dti) * 100 AS Avg_Debt_to_income_ratio FROM Loan_Information_Data