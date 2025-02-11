/* Id's which have loan status as fully paid or current fall under the Healthy loan category and rest in  Failed category */

/*HEALTHY LOAN APPLICATIONS*/

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

/* Loan Applications Overview*/
SELECT 
	loan_status,
	COUNT(id) AS Total_Applications,
	SUM(total_payment) AS Total_Amount_Received,
	SUM(loan_Amount) AS Total_Funded_Amount,
	AVG(int_rate * 100) AS Interest_Rate,
	AVG(dti *100) AS DTI
FROM Loan_Information_Data
GROUP BY loan_status