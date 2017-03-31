
# Applying Data Science For Social Good In Non-Profit Organization With Troubled Family Risk Profiling R Dashboard Application

## author
Ting-Wei Lin<sup>1</sup>,Tsun-Wei Tseng<sup>2</sup>,Yu-Hsuan Lin<sup>3</sup>,Pei-Yu Chen<sup>4</sup>,Ning-Yuan Lyu<sup>5</sup>,Ting-Kuang Lo<sup>6</sup>,Shing-Yun Jung<sup>7</sup>,Hsu Wei<sup>8</sup>,Charles Chuang<sup>9</sup>,Chun-Yu Yin<sup>8</sup>,Johnson Hsieh<sup>10,11</sup>
<sup>superscript</sup>

  1. Genome and Systems Biology Degree Program, National Taiwan University and Academia Sinica
  2. TAO Info Co.Ltd
  3. inQ Technology Co.Ltd
  4. Pegatron Co.Ltd
  5. Department of Electrical Engineering, National Tsing-Hua University
  6. Department of applied mathematics, Feng Chia University
  7. Department of Computer Science, National Tsing-Hua University
  8. Hfoundataion
  9. NETivism Co.Ltd
  10. Department of Computer Science, National Chengchi University
  11. DSP Co.Ltd

**Keywords**:  troubled family risk profiling, data science for social good, association rule analysis, steady-state analysis, topic model, shiny application

**Webpages**:  https://weitinglin.shinyapps.io/d4sg_dashboard_v1/


# Abstract

Assessing the troubled families's risk status and distributing the resources right is always a big issue for Non-Profit organizations, not even to mention the national program like UK Trouble Families Program^1^. Unfortunately, those organizations and national programs still use very manual way to deal with these problems^2^. As the increasing demands for social assistance and longterm shortage of social workers in these field, a more precise and continuous way to handle the social resources wisely and efficiently is needed. Besides, the junior social workers are hard to quickly get a hang of several families through lots of interview records and past documents, then decide whether providing their intervention. And most importantly of all, they lack of ability to utilize those information with proper data engineering and summarize those experience through data analysis. So here We first apply a evidence-based approach on assessing the troubled families's risk status with a *R* dashboard application integrated the prediction model generated from those families archives, follow-up records under the Data Science For Social Good Program in Taiwan with the cooperation between a volunteer data science team and local Non-Profit organization HFoundation.

 the beginning, the organization and volunteer data science team use customer journey analysis to map the social worker's experience and organization workflow in order to understand how organization generate their different types of data and define the proper scale of framework in dealing with their problems. Overall, There are now 57 families accepted active aid by organization and with maximum following time up to 6 years. The documents from these families have basic socioeconomic  information, following interview records from home visits with various follow-up time by the social workers, mainly text files. After de-identification of those documents, we preprocess their family archives and cases follow-up interview into suitable format for further management. Then, We use risk factors system to tag each home visit interview events in order to create family risk prediction model. There are seven major risk factors categories range from financial problems to housing problems. And we also use topic model to extract more information related to those risk factors from families archives. Then, we use association rule analysis in those home visit records during these 6 years and discuss the result rules to the senior social workers and in the same time the steady state analysis with Markov chain were performed to calculate recurrence rate of high risk factors for each home visit event. Those result can help to detect possible underline risk factors and predict the possible recurrence rate for each risk factors from recent family status.

 The dashboard shiny application was build with the above analysis result to assist the social worker daily work in recognizing the possible risk factors from those troubled families and prioritizing their resources to manage families high recurrence risk factors. The application provide a overview visualization of each case family data in timeline with risk factors and basic summary statistic. Social workers can easily get the insights from cases families past records and know the possible underline risk factors with the association rules and decide which families's problems should tackle first with the highest recurrence rate predicted from the model. In addition, the social workers can input their home visit or interview data into the application which can update the model and become their day-to-day working tools and make their workflow more efficiently and precisely. In the end, the high-risk family profiling R dashboard application can be a great tool to provide those non-profit organizations, not only HFoundation, in these field to precisely and efficiently manage their family cases and prioritizing their resources on managing families problems.



# References
1. Fletcher A, Gardner F, McKee M, Bonell C.(2012). The British government’s Troubled Families Programme. BMJ2012;344:e3403. doi: https://10.1136/bmj.e3403 
2. Chris Bonell, Martin McKee.(2016). Adam Fletcher. Troubled families, troubled policy making. BMJ 2016; 355 doi: https://doi.org/10.1136/bmj.i5879
