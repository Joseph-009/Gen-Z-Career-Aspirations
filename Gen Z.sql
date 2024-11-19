use generation;
select* from gen_z;

load data infile "C:\\ProgramData\\MySQL\\MySQL Server 8.1\\Uploads\\Gen Z.csv" into table gen_z
fields terminated by ','
enclosed by '"'  
lines terminated by '\r\n'
ignore 1 lines;

###      ---                ####       ----          ###        ----               ###       ----           ###           -----
## Change the Data Type of  Timestamp Column to Datetime
-- Create New column
ALTER TABLE gen_z
ADD COLUMN timestamp_datetime DATETIME
After timestamp;

-- Updata New column
UPDATE gen_z
SET timestamp_datetime = STR_TO_DATE(timestamp, '%d-%m-%Y %H:%i');

-- See Data type of new column
DESCRIBE gen_z;

-- Remove Old Timestamp column
Alter table gen_z
    drop column timestamp;
  
-- Rename timestamp_datetime to Timestamp
Alter table gen_z
     rename column timestamp_datetime to Timestamp;

##     ----            ###        ----          ####       ----              ###          ----              ####   -----


-- 1. What is the gender distribution of respondents from India?

select
      gender,
      count(gender)
    from gen_z
    where country = "India"
    group by gender;
    
-- 2. What percentage of respondents from India are interested in education abroad and sponsorship?

    SELECT 
    round((a.count_aspiration / b.total_respondents) * 100, 2) AS Percent_of_Respondent
FROM
    (SELECT COUNT(Higher_Education_Aspiration) AS count_aspiration
     FROM gen_z
     WHERE country = "India" AND Higher_Education_Aspiration = "Needs a Sponsor") AS a,
    
    (SELECT COUNT(Higher_Education_Aspiration) AS total_respondents
     FROM gen_z
     WHERE country = "India") AS b;

-- 3. What are the 6 top influences on career aspirations for respondents in India?

   select
         Aspirational_Career_Choice as Influences_Factors,
         count(Aspirational_Career_Choice) as Top6_Career_Aspiration
         from gen_z
         where country = "India"
         group by Influences_Factors
         order by Top6_Career_Aspiration desc
         limit 6;
         
-- 4. How do career aspiration influences vary by gender in India?

         select
         gender,
         Aspirational_Career_Choice as Influences_Factors,
         count(Aspirational_Career_Choice) as Total_Career_Aspiration
         from gen_z
         where country = "India"
         group by gender, Influences_Factors
         ;

-- 5. What percentage of respondents are willing to work for a company for at least 3 years?
        
	  select
           round((a.count_aspiration/b.count_aspiration)*100, 2) As Percentage_of_Respondent
           from(select
                count(Likelihood_of_3years_in_Company) AS count_aspiration
                from gen_z
                where Likelihood_of_3years_in_Company= "Yes") as a ,

             (select
                   count(Likelihood_of_3years_in_Company)AS count_aspiration
                   from gen_z) as b;
                   
-- 6. How many respondents prefer to work for socially impactful companies?

       SELECT 
             COUNT(`Willingness_ Work_Without_Clearly_Defined_Public_Mission`) As Numbers_of_Respondent
             FROM gen_z
       where `Willingness_ Work_Without_Clearly_Defined_Public_Mission`= "No" ;
       
-- 7. How does the preference for socially impactful companies vary by gender?
        
          SELECT
             gender as Gender,
             COUNT(`Willingness_ Work_Without_Clearly_Defined_Public_Mission`) As Numbers_of_Respondent
             FROM gen_z
       where `Willingness_ Work_Without_Clearly_Defined_Public_Mission`= "No" 
       group by gender;

        
--  8. What is the distribution of minimum expected salary in the first three years among respondents?

SELECT CONCAT(MIN(CAST(REPLACE(SUBSTRING_INDEX(`Expected_Monthly_Salary(First 3 Years)`, 'k', 1), '>', '') AS UNSIGNED)), 'k') AS Min_Salary
FROM gen_z;


-- 9. What is the expected minimum monthly salary in hand?
       SELECT CONCAT(MIN(CAST(REPLACE(SUBSTRING_INDEX(`Expected_Monthly_Salary(First 3 Years)`, 'k', 1), '>', '') AS UNSIGNED)), 'k') AS Min_Salary
       FROM gen_z;
       
-- 10. What percentage of respondents prefer remote working?
        
          select
           (a.count_respondent/b.count_respondent)*100 As Percentage_of_Respondents
           from(select
                count(Preferred_Working_Environment) As count_respondent
                from gen_z
                where Preferred_Working_Environment= "Fully Remote working") as a,
                (select
                count(Preferred_Working_Environment) As count_respondent
                from gen_z) as b;


-- 11. What is the preferred number of daily work hours?

SELECT 
    Preferred_Daily_Working_Hours,
    COUNT(Preferred_Daily_Working_Hours) AS Numbers_of_Respondent
FROM 
    gen_z
WHERE 
    Preferred_Daily_Working_Hours IS NOT NULL 
    AND Preferred_Daily_Working_Hours <> 'Null'
GROUP BY 
    Preferred_Daily_Working_Hours;


-- 12. What are the common work frustrations among respondents?
   
SELECT 
    Factors_Cause_Frustration_at_Work,
    COUNT(Factors_Cause_Frustration_at_Work) AS count_Factors_Cause_Frustration
FROM 
    gen_z
WHERE 
    Factors_Cause_Frustration_at_Work IS NOT NULL 
    AND Factors_Cause_Frustration_at_Work <> 'Null'
    
GROUP BY 
    Factors_Cause_Frustration_at_Work;


-- 13. How does the need for work-life balance interventions vary by gender?

       select
             gender,
             `Frequency_Needing _Full_Week_Break_for_Work_Life_Balance`,
             count(`Frequency_Needing _Full_Week_Break_for_Work_Life_Balance`)
             from gen_z
             WHERE 
             `Frequency_Needing _Full_Week_Break_for_Work_Life_Balance` IS NOT NULL 
             AND `Frequency_Needing _Full_Week_Break_for_Work_Life_Balance` <> 'Null'
             group by gender,`Frequency_Needing _Full_Week_Break_for_Work_Life_Balance`;


-- 14. How many respondents are willing to work under an abusive manager?

		 Select
               count(Work_Under_Manager_with_History_of_Abusive_Behavior) As Numbers_of_Respondent
               from gen_z
               where Work_Under_Manager_with_History_of_Abusive_Behavior = "Yes";
               
-- 15. What is the distribution of minimum expected salary after five years?
               
          SELECT CONCAT(MIN(CAST(REPLACE(SUBSTRING_INDEX(`Expected_Monthly_Salary(After 5 Years)`, 'k', 1), '>', '') AS UNSIGNED)), 'k') AS Min_Salary
       FROM gen_z;  
       
-- 16. What are the remote working preferences by gender?

        select
               gender,
                count(Preferred_Working_Environment) As count_respondent
                from gen_z
                group by gender;
                
-- 17. What are the top work frustrations for each gender?

         Select
               gender,
                Factors_Cause_Frustration_at_Work,
    COUNT(Factors_Cause_Frustration_at_Work) AS count_Factors_Cause_Frustration
FROM 
    gen_z
    WHERE 
    Factors_Cause_Frustration_at_Work IS NOT NULL 
    AND Factors_Cause_Frustration_at_Work <> 'Null'
    group by gender,Factors_Cause_Frustration_at_Work;
    
--  18. What factors boost work happiness and productivity for respondents?

         select
               Factors_Increase_Happiness_Productivity_at_Work As Factors_Increase_Happiness_Productivity,
               count(Factors_Increase_Happiness_Productivity_at_Work) As Factor_Count
               from gen_z
                 WHERE 
			   Factors_Increase_Happiness_Productivity_at_Work IS NOT NULL 
               AND Factors_Increase_Happiness_Productivity_at_Work <> 'Null'
               group by Factors_Increase_Happiness_Productivity_at_Work;
               
               
-- 19. What percentage of respondents need sponsorship for education abroad?

       SELECT 
    round((a.count_aspiration / b.total_respondents) * 100, 2) AS Percent_of_Respondent
FROM
    (SELECT COUNT(Higher_Education_Aspiration) AS count_aspiration
     FROM gen_z
     WHERE Higher_Education_Aspiration = "Needs a Sponsor") AS a,
    
    (SELECT COUNT(Higher_Education_Aspiration) AS total_respondents
     FROM gen_z) AS b;
     
	




    
    
