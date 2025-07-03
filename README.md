This document details how to read in, process, analyze, and produce graphs with
the data that is output from the Mulholland Lab's fiber photometry set up. 

PLEASE SEE THE FIBER PHOTOMETRY WORKFLOW IMAGE TO SEE WHICH CODE IS FOR WHAT STAGE.

To run the R code, you will need to install, R, RStudio, and Rtools as detailed
in the protocol to do so on the Mulholland server in the "Computation
Behavior" folder. To make things smoother, use the versions listed
below.

FOR DATA ANALYSIS IN R Environment Details: R 4.2.3 (2023-03-15 ucrt) --
"Shortstop Beagle" Platform: x86\_64-w64-mingw32/x64 (64-bit) USING
RStudio 2023.03.0+386 "Cherry Blossom" Release
(3c53477afb13ab959aeb5b34df1f10c237b256c3, 2023-03-09) for Windows using
RTools 4.3.

Old Environment: R (v.4.2.2., 2022-10-31 ucrt-- "Innocent and Trusting")
USING RStudio 2022.07.2+576 "Spotted Wakerobin" Release
(e7373ef832b49b2a9b88162cfe7eac5f22c40b34, 2022-09-06) for Windows

AUTHOR: Christina L. Lebonville, PhD, 2022-2023

CITATIONS:  
R Core Team (2021). R: A language and environment for statistical
computing. R Foundation for Statistical Computing, Vienna, Austria. URL
[https://www.R-project.org/](https://www.R-project.org/).  
Alboukadel Kassambara (2021). rstatix: Pipe-Friendly Framework for Basic
Statistical Tests. R package version 0.7.0.
[https://CRAN.R-project.org/package=rstatix](https://CRAN.R-project.org/package=rstatix)  
Alboukadel Kassambara. Comparing Multiple Means in R: Mixed ANOVA in R.
Publisher: DataNovia. Access Year: 2022.
[https://www.datanovia.com/en/lessons/mixed-anova-in-r/](https://www.datanovia.com/en/lessons/mixed-anova-in-r/) Sochacki, Jakub
(2022). 3-way ANOVA. Publisher: RPubs by RStudio.
[https://rpubs.com/JS24/853604](https://rpubs.com/JS24/853604)

GENERAL PROJECT APPROACH/MANAGEMENT:
[https://rfortherestofus.com/2021/02/how-to-use-git-github-with-r/](https://rfortherestofus.com/2021/02/how-to-use-git-github-with-r/)  
[https://happygitwithr.com/install-git.html](https://happygitwithr.com/install-git.html) [https://goodresearch.dev/](https://goodresearch.dev/)

FOR LITERALLY EVERYTHING GRAPH RELATED  
[https://ggplot2-book.org/](https://ggplot2-book.org/)  
[http://zevross.com/blog/2019/04/02/easy-multi-panel-plots-in-r-using-facet\_wrap-and-facet\_grid-from-ggplot2/](http://zevross.com/blog/2019/04/02/easy-multi-panel-plots-in-r-using-facet_wrap-and-facet_grid-from-ggplot2/)

For mixed/multilevel modeling
[https://quantdev.ssri.psu.edu/tutorials/r-bootcamp-introduction-multilevel-model-and-interactions](https://quantdev.ssri.psu.edu/tutorials/r-bootcamp-introduction-multilevel-model-and-interactions)
[https://rpubs.com/rslbliss/r\_mlm\_ws](https://rpubs.com/rslbliss/r_mlm_ws)
[https://www.stats.ox.ac.uk/~snijders/FixedRandomEffects.pdf](https://www.stats.ox.ac.uk/~snijders/FixedRandomEffects.pdf)
[https://mspeekenbrink.github.io/sdam-r-companion/linear-mixed-effects-models.html#formulating-and-estimating-linear-mixed-effects-models-with-lme4](https://mspeekenbrink.github.io/sdam-r-companion/linear-mixed-effects-models.html#formulating-and-estimating-linear-mixed-effects-models-with-lme4)

