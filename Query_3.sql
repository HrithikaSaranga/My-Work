/* Calculating monthly trends by issue date */
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