# flexTeaching
Use rstudio shiny+flexdashboard to create random stats assignments

## What is this?

The flexTeaching app is an interface which allows the creation and deployment of lessons and assignments that include personalized random data, based on a random seed based on their student ID.

[![Screenshot](https://raw.githubusercontent.com/richarddmorey/flexTeaching/gh-pages/images/flexTeach2_tn.png)](https://raw.githubusercontent.com/richarddmorey/flexTeaching/gh-pages/images/flexTeach2_tn.png)

*Students* can download their personalized data sets and see the assignment. *Assignment markers* can obtain the solutions specific to that student using their ID plus the secret in use at the time the student downloaded the data set. *Students* can obtain solutions to exercises with other randomized data sets for practice.

*New assignments* can be built and placed in the `assignments` directory, and they will be automatically picked up by the app.
 
Benefits:
* Every student's assignment is unique
* Markers who know the secret can get the solutions to a student's exercises
* Students who do not know the secret can still generate an infinite number of practice exercises
* The student's practice exercises can include the solutions. The solutions can be hidden by the student until needed

 
## How can I play with the app?

Just download the repository and run the corresponding `.Rmd` file in the Rstudio interface. 

![Run button](https://raw.githubusercontent.com/richarddmorey/flexTeaching/gh-pages/images/run.png)


The button may say "knit" the first time you run it; that's ok, just click it. You might have to install the packages listed below before it will run.

    ## Install necessary packages
     install.packages(c("shiny","rmarkdown","stargazer","broom","xtable",
         "flexdashboard","digest","base64enc","haven","xlsx",
         "lubridate"), dep=TRUE)

Without Rstudio:

    ## You may need to install the packages above 
    setwd('/PATH/TO/REPOSITORY/app')
    # For data download interface
    rmarkdown::run('download.Rmd')
    # For solutions interface
    rmarkdown::run('solve.Rmd')

    
## How can I help?

You can help in three ways:
* *Create new assignments.* Use the included example assignments to generate new assignments and contribute them back to the project.
* *Report/fix bugs.* While you're creating a new assignment, you may find a bug. Please report it in the GitHub issues and/or fix it and make a pull request.
* *Add new features.* The project is very new. No doubt there are many features that could be added to make it more useful to you and others. Please contribute!



## Current limitations

The `html_fragment` assignments are flexible; however, a current limitation is that I do not know how to include the proper HTML dependencies for nice features like `plotly` and other `htmlwidgets`. Hopefully we'll figure out a way around this.
