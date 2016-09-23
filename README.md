# flexTeaching
Use rstudio shiny+flexdashboard to create random stats assignments

To run:
    
    setwd('/PATH/TO/REPOSITORY/app')
    # For data download interface
    rmarkdown::run('download.Rmd')
    # For solutions interface
    rmarkdown::run('solve.Rmd')

OR just run the corresponding `.Rmd` file in the Rstudio interface, assuming you have the proper packages installed.
    
The solutions interface looks like this:

[![Screenshot](http://learnbayes.org/images/flexTeach/flexTeach1_tn.png)](http://learnbayes.org/images/flexTeach/flexTeach1.png)

The data set for each assignment is generated randomly based on the student's ID and the secret. This has several benefits:

* Every student's assignment is unique
* Markers who know the secret can get the solutions to a student's exercises
* Students who do not know the secret can still generate an infinite number of practice exercises
* The student's practice exercises can include the solutions. The solutions can be hidden by the student until needed

Assignments can simply be dropped in the `app/assignments` directory and the interface will automatically pick them up. New assignments consist of, essentially, a data generating function, an `Rmd` file that is included as an `html_fragment`, and any helper functions that might be needed.

The `html_fragment` assignments are flexible; however, a current limitation is that I do not know how to include the proper HTML dependencies for nice features like `plotly` and other `htmlwidgets`.
