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
/* Id's which have loan status as fully paid or current fall under the Healthy loan category and rest in  Failed category */

/*Loan Applications Dashboard*/

/*  Calculating the count of Healthy Loan Applications*/
SELECT COUNT(id) AS Number_of_Healthy_Loan_Applications FROM Loan_Information_Data
WHERE loan_status='Fully Paid' OR loan_status='Current'

/*  Calculating Healthy Loan Application Percentage*/
SELECT
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0)
	/
	COUNT(id) AS Healthy_Loan_Percentage
FROM Loan_Information_Data

/* Calculating the total amount funded via healthy loan applications */
SELECT SUM(loan_amount) AS funded_amount_via_healthy_loan FROM Loan_Information_Data
WHERE loan_status='Fully Paid' OR loan_status='Current'

/* Calculating the total amount received via healthy loan applications */
SELECT SUM(total_payment) AS Total_amount_received_via_healthy_loan FROM Loan_Information_Data
WHERE loan_status='Fully Paid' OR loan_status='Current'

/*FAILED LOAN APPLICATIONS*/

/*  Calculating the count of Failed Loan Applications*/
SELECT COUNT(id) AS Number_of_Failed_loan_Applications FROM Loan_Information_Data
WHERE loan_status='Charged Off'

/*  Calculating Healthy Loan Application Percentage*/
SELECT
	(COUNT(CASE WHEN loan_status='Charged Off' THEN id END) * 100.0)
	/
	COUNT(id) AS failed_loan_Percentage
FROM Loan_Information_Data

/* Calculating the total amount funded via healthy loan applications */
SELECT SUM(loan_amount) AS funded_amount_via_failed_loan  FROM Loan_Information_Data
WHERE loan_status='Charged Off'

/* Calculating the total amount received via healthy loan applications */
SELECT SUM(total_payment) AS Total_amount_received_via_failed_loan FROM Loan_Information_Data
WHERE loan_status='Charged Off'

/* Loan Applications Breakdown*/
SELECT 
	loan_status,
	COUNT(id) AS Total_Applications,
	SUM(total_payment) AS Total_Amount_Received,
	SUM(loan_Amount) AS Total_Funded_Amount,
	AVG(int_rate * 100) AS Interest_Rate,
	AVG(dti *100) AS DTI
FROM Loan_Information_Data
GROUP BY loan_status/* Calculating monthly trends by issue date */
SELECT 
	MONTH(issue_date) AS Month_Number,
	DATENAME(MONTH, issue_date) AS Month_Name,
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM Loan_Information_Data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date)

/* Loan Application Analysis by State */
SELECT 
	address_state AS State,
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM Loan_Information_Data
GROUP BY address_state
ORDER BY SUM(loan_amount) DESC

/* Loan Term Analysis */
SELECT 
	term AS Term_Duration,
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM Loan_Information_Data
GROUP BY term
ORDER BY term

/* Loan Analysis wrt employee length */
SELECT 
	emp_length AS employeee_length,
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM Loan_Information_Data
GROUP BY emp_length
ORDER BY emp_length

/* Loan Analysis wrt purpose */
SELECT 
	purpose AS Reason_for_Loan,
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM Loan_Information_Data
GROUP BY purpose
ORDER BY COUNT(id) DESC

/* Loan Analysis by home ownership */
SELECT 
	home_ownership AS Home_Ownership_Status,
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM Loan_Information_Data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC

/* Borrower Risk Assessment Dashboard*/
/* Categorising borrowers into risk Levels */
SELECT 
    id, 
    annual_income, 
    dti, 
    emp_length, 
    grade, 
    loan_status,
    CASE 
        /*High Risk: Low income, high DTI, and lower credit grades*/
        WHEN annual_income < 50000 AND dti > 0.15 AND grade IN ('D', 'E', 'F', 'G') THEN 'High Risk'
        /*Medium Risk: Mid-range income, moderate DTI, mid-tier grades*/
        WHEN annual_income BETWEEN 50000 AND 200000 AND dti BETWEEN 0.07 AND 0.15 
             AND grade IN ('B', 'C', 'D') THEN 'Medium Risk'
        /*Low Risk: High income, low DTI, top credit grades*/
        WHEN annual_income > 200000 AND dti < 0.07 AND grade IN ('A', 'B') THEN 'Low Risk'
        /*Moderate Risk: Covers missing cases between 20K-500K income and wider DTI range*/
        WHEN annual_income BETWEEN 20000 AND 500000 AND dti BETWEEN 0.05 AND 0.20 THEN 'Moderate Risk'
        /*Special Case: If DTI is very low (< 0.05), categorize separately*/
        WHEN dti < 0.05 THEN 'Very Low Risk'
        /*Special Case: High earners with high DTI (Risky high-income borrowers)*/
        WHEN annual_income > 500000 AND dti > 0.15 THEN 'High-Income Risk'
        /*Fallback for any remaining cases*/
        ELSE 'Unclassified'
    END AS risk_category
FROM Loan_Information_Data;

/* To see how many loans in each category have been Chargedoff */
SELECT 
    risk_category, 
    COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*) AS default_probability
FROM (
    SELECT 
        id, 
        annual_income, 
        dti, 
        emp_length, 
        grade, 
        loan_status,
        CASE 
			
			WHEN annual_income < 50000 AND dti > 0.15 AND grade IN ('D', 'E', 'F', 'G') THEN 'High Risk'			
			WHEN annual_income BETWEEN 50000 AND 200000 AND dti BETWEEN 0.07 AND 0.15 
				 AND grade IN ('B', 'C', 'D') THEN 'Medium Risk'			
			WHEN annual_income > 200000 AND dti < 0.07 AND grade IN ('A', 'B') THEN 'Low Risk'			
			WHEN annual_income BETWEEN 20000 AND 500000 AND dti BETWEEN 0.05 AND 0.20 THEN 'Moderate Risk'			
			WHEN dti < 0.05 THEN 'Very Low Risk'
			WHEN annual_income > 500000 AND dti > 0.15 THEN 'High-Income Risk'
			ELSE 'Unknown'
        END AS risk_category
    FROM Loan_Information_Data
) risk_data
GROUP BY risk_category;

/* To see how many loans in each grade have been Chargedoff and their corresponding percentage */
SELECT 
    grade, 
    COUNT(*) AS total_loans,
    COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) AS defaulted_loans,
    ROUND(COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM Loan_Information_Data
GROUP BY grade
ORDER BY default_rate ASC;

/*Loan Performance and Profitability Dashboard*/
/*Total Loan Applications*/
SELECT COUNT(*)AS Total_Loan_Applications
FROM Loan_Information_Data

/*Total Loan Amount Issued*/
SELECT SUM(loan_amount) AS Total_Loan_Amount_Issued
FROM Loan_Information_Data

/*Total Loan Amount Received*/
SELECT SUM(total_payment) AS Total_Loan_Aount_Received
FROM Loan_Information_Data

/*Calculating the total interest earned, by excluding the chargedoff/failed loans*/
SELECT 
    SUM((int_rate / 100) * loan_amount) - 
    SUM(CASE WHEN loan_status = 'Charged Off' THEN (int_rate / 100) * loan_amount ELSE 0 END) AS Interest_earned_from_Healthy_Loan
FROM Loan_Information_Data;

/*Calculating the % of Charged Off loans*/
SELECT
	COUNT(CASE WHEN loan_status='Charged Off' THEN 1 END)*100.0/COUNT(*) AS Charged_Off_Percentage
FROM Loan_Information_Data

/*Calculating Loan Recovery Rate*/
SELECT
	SUM(loan_amount)*100.0/Sum(total_Payment) AS Loan_Recovery_Rate
FROM Loan_Information_Data

/*Calculating Total Outstanding Loan Balance*/
SELECT
	SUM(CASE WHEN loan_amount>total_payment
			 THEN loan_amount-total_payment
			 ELSE 0
			 END) AS Total_Outstanding_Amt
FROM Loan_Information_Data