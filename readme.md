# Opera Audition Aria Statistics, 2013-2019

## Background

Every year, hundreds of the most talented young opera singers in the country audition for the chance to take part in one of a handful of prestigious summer opera festivals. These singers prepare 4-6 pieces (known as "arias") to sing for a panel of judges, and usually perform 1-3 of them. One festival, Wolf Trap Opera in Vienna, Virginia, compiles a yearly list of every single aria that was offered by a singer. By looking at a collection of these lists over the years, one can gain a pretty clear picture of which arias, operas, and composers are most popular among young vocal artists.

Knowing these arias was fundamental to my career as an opera pianist. One of my most reliable sources of income was playing for singers in these auditions, and often playing an entire day of auditions for the opera companies. I would sit in a room for 8 hours as singers came in one after the other, and I would have to perform whatever they put in front of me, whether I knew it or not. Needless to say, this job became a lot easier the more arias I had in my back pocket. It's not possible to learn every aria, but by learning the most popular, I could get a pretty good handle on what I might have to play.

The foundational importance of knowing these popular arias was what motivated me to assemble Wolf Trap's list into a database back in 2019. I spent hours manually typing out all the data about the pieces and calculating the totals across a 7-year period from 2013-2019. I basically found out what I needed to know, but I was curious to come back to this dataset after learning some real data analysis and visualization tools like Google Sheets/Excel, SQL, and Tableau.

## Analysis

Links to data, SQL code, and graphs:

- [Dataset](https://docs.google.com/spreadsheets/d/17Qt5mnLgXGZ1ryyki03XkbZMpSovYYgT1uRyux-f1eI/edit#gid=1229051757)
- [SQL Queries](https://github.com/Jonathan-Heaney/aria_stats/blob/main/aria_stats.sql)
- [Results sheets](https://docs.google.com/spreadsheets/d/1gzVztDbYSH-RA88E-dpb_SUojyeiU2S_728B0uojT0E/edit#gid=1617119782)
- [Tableau visualizations](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/AriaRanking)

## Conclusions

### Types of Queries

I performed three types of queries in my analysis: some to filter the aria list, some to determine the popularity of different composers/operas/etc, and some to track changes across time.

#### Filtering the Aria List

In addition to playing arias in auditions, one of my other main roles was to coach singers and help them choose repertoire. A singer might come to me and ask for a new piece to work on- they might have a language in mind, or an era of music, or they might want to choose something less popular to stand out.
SQL provides the tools to filter the data in any of these ways, to meet any request of any singer. I included several different sample queries in my analysis that filtered the data based on potential requests, including:

- A tenor wants to learn a rarely-performed French aria
- A mezzo needs a piece written before 1750
- A baritone doesn't want to sing any Italian music or 19th-century music
