## Proposal

## Section 1: Motivation and Purpose

**Our role:** As Data Scientists, our mission is to provide invaluable resources to professionals in the Data Science field

**Target audience:** Our main target audience includes individuals searching for employment in the Data Science space. A secondary audience includes managers, recruiters, and founders looking to build a talented Data Science team.

One of the primary factors in any job search is salary. However, determining the appropriate compensation for a given role can be challenging, especially in the constantly evolving world of Data Science. To address this, we have compiled a comprehensive dataset of user-submitted salary information from over 2600 jobs across 70 countries and 80 job titles.

Our interactive dashboard provides users with high-level salary trends by country and allows for customized visualizations using filters such as experience, job location, and company size. Users can explore the data in various formats including histograms, box plots, and bar charts. Not only will our dashboard help in the salary negotiation process, but it also provides an invaluable tool for guiding users in their job search.


## Section 2: Description of Data 
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


## Section 3: Research questions and usage scenarios

The DS-Salaries App aims to provide answers to current and aspiring Data Science professionals researching salaries in the field as well as professionals looking to build Data Science teams. The main research questions addressed by DS-Salaries are:

- How have salary levels changed over the past couple of years?
- What is the association between salary levels and experience?
- What are the top paying positions in the field of Data Science?
- How do salary levels for Data Science professionals vary across the world?

The team behind the app targets one main and one secondary group of users for DS-Salaries. The first group consists of Data Science professionals as well as aspiring professionals who are looking for employment or to switch careers in the sector.
A typical user from this group would be represented by the following description:

Jane is currently pursuing a degree in Data Science and is exploring career opportunities in the field.  She has spoken to several recruiters from different companies.  The positions Jane has discussed have varying job titles and responsibilities.  Because this would be her first job post graduation, Jane wants to make the best career choice.  She wants a job where she can learn fast, but she also wants to maximize her financial well being.  That is why Jane is conducting independent research on salary levels in the industry and is evaluating salary levels associated with different job titles. As a Data Scientist Jane understands that trend is important, which is why one aspect of salaries she is looking at is how they have changed over the past couple of years.  Furthermore, she wants to understand which jobs offer the best salary upside with growing experience, so Jane is researching experience related salary data.  Finally, because this is her first job, Jane would be willing to relocate in order to maximize her earning potential if everything else is equal, therefore she wants to know about salary levels in different locations.

The second group consists of professionals who are in the process of building out Data Science teams. This group includes recruiters, managers and founders researching salaries in the field in order to make competitive offers for the roles they are looking to fill.

A typical user from this group would be represented by the following description:

Michael is a recruiter at a large company from the Technology sector who has a number of job openings that need to be filled within the next year. He has posted the job listings on various recruiting websites mentioning "competitive salary" in the job descriptions, however, he has flexibility when it comes to the actual salary offered to selected candidates.  Michael wants to make competitive offers to the right candidates, but also understands that his company needs to keep costs under control.  The salary budgets he is working with are from last year, so he is interested in understanding how pay levels may have changed over the past year and adjust accordingly. Furthermore, Michael's company has multiple offices which would allow him to hire candidates for a specific job from different locations. This is why he would like to understand how salary levels vary across geography. Because his company is large, Michael can hire candidates for a role with varying levels of experience and leverage existing experts in building out any missing skills for new hires.  For that reason, he wants to understand how salaries vary across experience levels.

The DS-Salaries app will provide Jane and Michael the information they need.  DS-Salaries will set a benchmark for Janes forthcoming salary discussions once she gets multiple job offers.  Michael will similarly have solid research to back up his salary offers, making him a top performing recruiter within the industry.  

When users load the app, they will be able to find information about salary trends, experience-dependent salary levels, pay levels depending on job titles and salary levels based on specific geography.  Furthermore the app will provide functionality to evaluate the data for specific year, job location, company size and experience level.


