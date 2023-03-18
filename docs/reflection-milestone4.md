# Reflection Document for DS-Salaries Shiny App Project

Milestone 4

-   authors: Mehwish Nabi, Yaou Hu, Jonah Hamilton, Ruslan Dimitrov

## Completed Implementations

Working toward the completion of Milestone 4, our further developed the dash board incorporating all the meaningful feedback we received from the Instructors and TA team along with the peer reviews.

Specifically each team member implemented changes as follows:

1. Ruslan Dimitrov   
**Modification**: Added default view of the Salary per Year plot to display "Average Salary per Year by All Experience Levels" when none of the options is selected in the checkboxGroupInput element of the Salary by Year plot       
**Source:** Peer review milestone 3: When no selection is made, add a 'please make selection' instruction to avoid empty page   
(https://github.ubc.ca/fdandrea/532-peer-review/issues/10#issuecomment-23050)    
**Team member**: Ruslan Dimitrov       
**Commit/s:** https://github.com/UBC-MDS/DS-Salaries/commit/c9eee2100e4c664186ae9f6b9528757382858051   

2. Mehwish Nabi
**Modification**: Added a reactive element in the Top Ten Highest paid jobs to compare the salaries between 2 different countries. Made some modifications in UI to make the layout consistent.   
**Source:** Peer review milestone 3     
[backend/layout review point 11](https://github.ubc.ca/fdandrea/532-peer-review/issues/10#issuecomment-23013)    
**Team member:** Mehwish Nabi     
**Commit:** [Commit](https://github.com/UBC-MDS/DS-Salaries/commit/f8e67778e94377908a57923223f5b747e952d24c) 
3. Yaou Hu  
**Modification**: Combined the boxplot of 'average salary per year' and 'salary by employment type' plot into the same tab and placed side-by-side. Also, made these two plots share the same theme to make the layout consistent.     
**Source:** Peer review milestone 3     
[frontend/layout review point 7](https://github.ubc.ca/fdandrea/532-peer-review/issues/10#issuecomment-23013)    
**Team member:** Yaou Hu      
**Commit:** https://github.com/UBC-MDS/DS-Salaries/commit/2610f0b877641195620adcdd047a47ccd4313296   

4. Jonah Hamilton  
**Modification**: Map improvements:
Set an appropriate default height. Added base map and observer map object to prevent reloading every time the filter is applied. Properly formatted salary ranges in the tool tips. Increased space between radio buttons  
**Source:** Peer review milestone 3 
[frontend review](https://github.ubc.ca/fdandrea/532-peer-review/issues/10#issuecomment-23013), [backend review](https://github.ubc.ca/fdandrea/532-peer-review/issues/10#issuecomment-23050)  
**Team member:** Jonah  
**Commit:** [commit](https://github.com/UBC-MDS/DS-Salaries/commit/d67aa8184306de895fb7955cffbd3dd88840e16c)

 


Furthermore we made multiple changes to make the app complete and professional grade:
- Fix Salary by year plot to better reflect experience level average salaries
- Add description, keywords, link to shinyapps.io to repo for better review
- Implemented tests on the app to make it more error proof
- Incorporate CI and CD workflows and add respective badges to readme




## Changes made to original proposal

1.  **Plots consolidated into three tabs instead of four**

**Rationale**: We realized that having all plots in separate tabs could be optimized for better user experience, that is why we combined two of the plots into a joint tab, achieving optimum levels of readability and cognitive load.

## Usability

We believe that as a result of the above improvements the app has become significantly more usable and professional looking.  

## Feedback themes

Feedback received was extremely helpful.  There weren't recurring themes, however, users who tested the app gave us valuable third party perspective on functionality and corner cases which the team had not implemented in the original Milestone 2 version of the app.

Feedback and guidance received from the course Instructor and TA team was critical for the achievement of the Milestone 4 goals including setting up and implementing Continuous Integration and Continous Deployment processes.
