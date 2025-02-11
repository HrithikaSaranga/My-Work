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



