<!-- #region -->
### Section 2: Description of Data 
The dataset provided by [ai-jobs.net](https://ai-jobs.net/) is what we are utilising for this research. The information includes the average salary paid globally for AI and machine learning professionals working in a variety of professions in different nations.
The dataset is constantly updated with fresh and updated information given by professionals all over the world. This dataset is available in CSV format from [ai jobs](https://ai-jobs.net/salaries/download/). The dataset includes eleven fields for ease of understanding and comparing pay for different jobs and across nations, including work year, experience level, employment type, job title, salary, salary currency, salary in usd, employee residence, remote ratio, company location, and company size. The dataset contains 2650 rows of information reported for the three years 2020-2023. The project's main goal is to provide graduates with an insight into industry trends, across multiple roles and at multiple levels. In this project, we will be using data from the year 2020 to date. The columns in the dataset are as: 


`work_year` : The year in which salary was paid. 

`experience_level` : The experience level in the job during the `work_year` with the following possible values :
- EN :  Entry-level / Junior
- MI : Mid-level / Intermediate
- SE : Senior-level / Expert
- EX : Executive-level / Director
    
`employment_type` : The type of employment for the role : 
- PT : Part Time
- FT : Full Time 
- CT : Contract 
- FL : Freelance

`job_title` : The role of the person during the `work_year`.

`salary` : The total gross salary paid to the employee.
     
`salary_currency` : The currency in which salary is paid as an ISO 4217 currency code.

`salary_in_usd`: The salary in USD (FX rate divided by avg. USD rate of respective year via data from [BIS](https://www.bis.org/statistics/about_fx_stats.htm).

`employee_residence` : Employee's primary country of residence in during the work year as an ISO 3166 country code.

`remote_ratio` : The overall amount of work done remotely, possible values are as follows: 
- 0 : No remote work (less than 20%)
- 50 : Partially remote
- 100 : Fully remote (more than 80%)
    
    
`company_location` : The country of the employer's main office or contracting branch as an ISO 3166 country code.

`company_size` : The average number of people that worked for the company during the `work_year`:
- S : less than 50 employees(small) 
- M : 50 to 250 employees (medium)
- L : more than 250 employees (large)
 

<!-- #endregion -->
