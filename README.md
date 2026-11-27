# Maji Ndogo Water Analysis

Maji Ndogo is a fictional country with a real-feeling problem: too many people, too few working water sources. In this project I used SQL to dig into the `md_water_services` database and answer a simple question: who has access to clean water, and where should repairs start?

I built this as part of my ALX Data Analytics training.

## What I Wanted to Find Out

- Is the pollution data trustworthy, and if not, how do I fix it?
- What kinds of water sources do people rely on?
- How long do people wait in line for water?
- Which sources should be repaired first?

## What's in This Repo

```
maji-ndogo-water-analysis/
├── sql_scripts/
│   ├── 01_Cleaning_of_water_pollution.sql
│   └── 02_water_source_analysis.sql
├── visuals/            # Screenshots of my query results
├── .gitignore
└── README.md
```

## The Data

Everything comes from the `md_water_services` database. These are the tables I worked with:

| Table | What it holds |
|-------|---------------|
| `water_source` | Type of source and how many people it serves |
| `water_quality` | Quality scores and visit counts |
| `well_pollution` | Contamination results and descriptions |
| `visits` | Survey visits, queue times and timestamps |
| `location` | Province, town, and rural or urban type |
| `employee` | Surveyor details |

## How I Approached It

### Step 1: Cleaning the data (`01_Cleaning_of_water_pollution.sql`)

I started by looking at the first few rows of each table, then went hunting for things that didn't look right:

- Queue times over 500 minutes, and others at 0
- Wells marked `Clean` even though their biological contamination was above 0.01
- Descriptions that had "Clean" stuck on the front, like `Clean Bacteria: E. coli`

I fixed the descriptions and relabeled the wrongly marked wells as `Contaminated: Biological`.

### Step 2: Analyzing water sources (`02_water_source_analysis.sql`)

With clean data, I moved on to the analysis:

- Employees: created work emails (`first.last@ndogowater.gov`), trimmed phone numbers, counted staff per town, and found the top 3 surveyors by number of visits
- Locations: counted records per town, province and location type
- Water sources: counted sources by type, found the average users per source, and worked out what share of the population each type serves
- Repairs: ranked sources by people served with `DENSE_RANK()`
- Queue times: measured how long the survey ran, then broke average queue time down by weekday, by hour, and in a weekday-by-hour pivot table

## What I Found

1. Most water sources are rural, about 60% of locations.
2. Shared taps carry the load. Around 43-44% of people use one, and about 2,000 people often share a single tap.
3. Home taps often don't work. 31% of people have water infrastructure at home, but 45% of those systems are broken because of pipes, pumps or reservoirs.
4. Wells are a risk. 18% of people use wells, and only 28% of those wells are clean.
5. The wait is long. People queue for more than 120 minutes on average.
6. Saturday is the worst day (246 minutes on average). Sunday (82) and Wednesday (97) are the easiest. Mornings and evenings are the busiest times.

The survey ran for 924 days, from 1 January 2021 to 14 July 2023.

## Tools

MySQL Workbench, VS Code, Git and GitHub.

Along the way I got comfortable with aggregates, `CASE` pivots, window functions (`RANK`, `DENSE_RANK`), date and string functions, and `UPDATE` for cleaning.

## Run It Yourself

1. Load the `md_water_services` database into MySQL.
2. Run the scripts in order:
   ```sql
   SOURCE sql_scripts/01_Cleaning_of_water_pollution.sql;
   SOURCE sql_scripts/02_water_source_analysis.sql;
   ```
3. Compare your results with the screenshots in `visuals/`.

## About Me

I'm Micheal, a Mathematics graduate of the Federal University of Technology, Minna, currently building my data analytics skills through ALX.