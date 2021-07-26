# Data science with Formula 1 History race Data (1950-2020)
![f1 logo](https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/F1.svg/1280px-F1.svg.png)

This repository includes code to illustrate some concepts of data analysis and data science using the amazing data set provided by [Rohan Rao](https://en.wikipedia.org/wiki/Rohan_Rao) (aka. vopani) at [kaggle](https://www.kaggle.com/rohanrao/formula-1-world-championship-1950-2020/discussion/new).

## ⚠️ Important note
Several modifications were made to the schema proposed by vopani:
 - Inclusion of the [eras in F1 History](https://en.wikipedia.org/wiki/History_of_Formula_One) as a new analysis dimension.
    - `era_id` foreign key added on the `race` table
 - Inclusion of the boolean type column `season_last_round` on the `race` table to facilitate the analysis of the results at the end of seasons.
 - Various times provided in the format `H:M:S.f` or `M:S.f` where also included in milliseconds.
 - Diverse renames on columns and tables to fit my tastes.
 
 The resulting Entity Relation diagram is shown as follows:
 ![ER diagram](https://raw.githubusercontent.com/luis-perez-one/formula1-history-1950-2020/master/sql-schema-mods/er_diagram.png)
 
Because of these modifications, the plain-data on kaggle would need some modifications in order to perfectly fit the proposed schema. A couple of python functions and scripts examples on how to use them are included to ease this task.

A **postgres** (version 12.3) .tar dump of the database with the available info from kagle up to 2020-08-10 is provided. You can uncompress it *to tar level* and then use `[pg_restore]`. This is the [official](https://www.postgresql.org/docs/12/app-pgrestore.html) `[pg_restore]` documentation.


## Changelog
- **2020-08-11** : Initial release, just the framework for further work has been stablished.
