use project_medical_data_history;

select * from admissions;

-- Show first name, last name, and gender of patients who's gender is 'M'

select first_name,last_name,gender
from patients
where gender="M";

-- -- Show first name, last name, and gender of patients who's gender is 'F'

select first_name,last_name,gender
from patients
where gender="F";

-- Show first name and last name of patients who does not have allergies

select first_name,last_name
from patients
where allergies is null;

-- Show first name of patients that start with the letter 'C'

select first_name
from patients
where first_name LIKE 'C%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

select first_name,last_name
from patients
where weight between  100 and 120;

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

update patients
set allergies ="NKA"
where allergies = "Null";

-- Show first name and last name concatenated into one column to show their full name.

select concat(first_name, ' ' ,last_name) as full_name
from patients;

-- Show first name, last name, and the full province name of each patient.

select p.first_name,p.last_name,pr.province_name
from patients p
join province_names pr
on p.province_id = pr.province_id;

select * from patients;

select * from province_names;

-- Show how many patients have a birth_date with 2010 as the birth year.

select count(*) as total_patients_2010
from patients
where year(birth_date)=2010;

-- Show the first_name, last_name, and height of the patient with the greatest height.

select first_name,last_name,height
from patients
where height = (select max(height) from patients);

-- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000

select * 
from patients
where patient_id in (1,45,534,879,1000);

-- Show the total number of admissions

select count(*) as total_admissions
from admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.

select * 
from admissions
where admission_date = discharge_date;

-- Show the total number of admissions for patient_id 579.

select count(*) total_admissions
from admissions
where patient_id = 579;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?

select distinct city
from patients
where province_id = "NS";

-- Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70

select first_name,last_name,birth_date
from patients
where height >160 
and weight >70;

-- Show unique birth years from patients and order them by ascending.

select distinct year(birth_date) as birth_year
from patients
order by birth_year asc;

select * from patients;

-- Show unique first names from the patients table which only occurs once in the list.

SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

select patient_id,first_name
from patients
where first_name like 's%s'
and lenght(first_name) >=6;

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table

select p.patient_id,p.first_name, p.last_name 
from patients p
Join admissions a
on p.patient_id = a.patient_id
where a.diagnosis = "Dementia";

-- Display every patient's first_name. Order the list by the length of each name and then by alphbetically.

select first_name
from patients
order by lenght(first_name), first_name;

-- Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.

SELECT
SUM(CASE WHEN gender='M' THEN 1 ELSE 0 END) AS male_patients,
SUM(CASE WHEN gender='F' THEN 1 ELSE 0 END) AS female_patients
FROM patients;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

select patient_id,diagnosis
from admissions
group by patient_id, diagnosis
having count(*) >1; 

-- Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.

SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC, city ASC;

-- Show first name, last name and role of every person that is either patient or doctor.    The roles are either "Patient" or "Doctor"

select first_name,last_name,"Patient" as role
from patients
union
select first_name,last_name,"Doctor" as role
from doctors;

-- Show all allergies ordered by popularity. Remove NULL values from query

SELECT allergies, COUNT(*) AS popularity
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY popularity DESC;  

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.

select first_name,last_name,birth_date
from patients
where birth_date between "1970-01-01" and "1979-12-31"
order by birth_date;

-- We want to display each patient's full name in a single column.
-- Their last_name in all upper letters must appear first, then first_name in all lower case letters.
-- Separate the last_name and first_name with a comma. Order the list by the first_name in decending order. EX: SMITH,jane

select CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM patients
ORDER BY first_name DESC;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT province_id, SUM(height) AS total_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

select max(weight)-min(weight) as weight_difference
from patients
where last_name = "Maroni";


-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
-- Sort by the day with most admissions to least admissions

SELECT
DAY(admission_date) AS day_of_month,
COUNT(*) AS total_admissions
FROM admissions
GROUP BY DAY(admission_date)
ORDER BY total_admissions DESC;

-- Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. 
-- Order the list by the weight group decending.
-- e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT
FLOOR(weight/10)*10 AS weight_group,
COUNT(*) AS total_patients
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;  

-- Show patient_id, weight, height, isObese from the patients table.
-- Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). 
--  Weight is in units kg. Height is in units cm.

SELECT
patient_id,
weight,
height,
CASE
    WHEN (weight / POWER(height/100,2)) >= 30 THEN 1
    ELSE 0
END AS isObese
FROM patients;

-- Show patient_id, first_name, last_name, and attending doctor's specialty. 
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'.
-- Check patients, admissions, and doctors tables for required information.

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    d.specialty
FROM patients p
JOIN admissions a
    ON p.patient_id = a.patient_id
JOIN doctors d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
AND d.first_name = 'Lisa';


select * from patients;
