library(sqldf)

library(readxl)
User_data <- read_excel("SQL Problem - Users.xlsx") 
view(User_data)


OUTPUT <- sqldf("WITH CTE AS(SELECT Timestamp AS Date, COUNT(DISTINCT Userid) AS Dau
  FROM User_data
  WHERE Events IS NOT NULL 
  GROUP BY 1)
  SELECT Date, Dau, 
         SUM(Dau) OVER (ORDER BY Date ROWS BETWEEN 30 PRECEDING AND CURRENT ROW) AS Mau,
         100*Dau/NULLIF((SUM(Dau) OVER (ORDER BY Date ROWS BETWEEN 30 PRECEDING AND CURRENT ROW)),0) AS Percent_DAUMAU
  FROM CTE
  GROUP BY 1
  ORDER BY 1")

sqldf("SELECT Timestamp,COUNT(DISTINCT Userid) as Dau,
       (SELECT COUNT(DISTINCT Userid) 
       FROM User_data as y
       WHERE y.Timestamp BETWEEN x.Timestamp - 30 AND x.Timestamp) AS Mau
       FROM User_data AS x
       GROUP BY 1
       ORDER BY 1")

sqldf("SELECT a.Timestamp,a.Userid,SUM(a.Userid))

write.csv(OUTPUT,file = "Output.csv")

Cohort <- read_excel("Cohort Analysis - SQL.xlsx")
view(Cohort)

sqldf("WITH CTE AS(SELECT Timestamp as Date,Userid 
      FROM Cohort WHERE Events = 'Registration'
      GROUP BY 1,2)
      SELECT 
             COUNT (DISTINCT CASE WHEN Events = 'Profile Completion' THEN Cohort.Userid ELSE NULL END) AS User_Profile,
             COUNT (DISTINCT CASE WHEN Events = 'CIBIL' THEN Cohort.Userid ELSE NULL END) AS User_CIBIL,
             COUNT (DISTINCT CASE WHEN Events = 'Transaction' THEN Cohort.Userid ELSE NULL END) AS User_Transaction
      FROM CTE JOIN Cohort ON Cohort.Timestamp = CTE.Date")
             
