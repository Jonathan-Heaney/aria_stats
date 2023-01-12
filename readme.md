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

I performed three types of queries in my analysis: some to filter the aria list, some to determine the popularity of different composers/operas/etc, and some to track changes across time.

### Filtering the Aria List

In addition to playing arias in auditions, one of my other main roles was to coach singers and help them choose repertoire. A singer might come to me and ask for a new piece to work on- they might have a language in mind, or an era of music, or they might want to choose something less popular to stand out.
SQL provides the tools to filter the data in any of these ways, to meet any request of any singer. I included several different sample queries in my analysis that filtered the data based on potential requests, including:

- A tenor wants to learn a rarely-performed French aria [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/FrenchTenorArias)
- A mezzo needs a piece written before 1750 [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/EarlyMezzoArias)
- A baritone doesn't want to sing any Italian music or 19th-century music [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/Non-ItalianBaritoneArias)

### Popularity Across Categories

Knowing the most popular arias is extremely helpful, but to gain a broader picture, I also wanted to know the most common composers, operas, languages, and voice parts.

Some key takeaways from these analyses:

#### - Mozart is far and away the most important composer of arias for young singers.

It's actually standard practice for every singer to include a Mozart aria in their package of 4-6 pieces; he is the only composer to inspire such a requirement.

Statistics to illustrate Mozart's dominance:

- Mozart's arias were offered 3,184 times; the second highest was Verdi with only 940. [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/ComposerFrequencyAriaCount)
- Each of the top 4 most-represented operas are by Mozart. [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/OperaFrequencyCount)
- Mozart is the most popular composer in both Italian AND German. [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/ComposersbyLanguage)

#### - Italian is the most prominent language, followed by English.

Singers are traditionally asked to offer arias across 4 standard languages- Italian, French, German, and English. Some leave out one of these and replace it with a wild card like Russian or Czech, or some lean more heavily on one language in particular. In the end, Italian is far and away the most popular language; opera is an Italian art form, after all. [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/LanguageFrequencyCount)

English coming in second is a bit surprising in the context of operatic repertoire as a whole. France and Germany both have more distinguished operatic traditions than the United Kingdom and United States. However, for opera auditions in America, it isn't as surprising. Singers are nearly always requested to provide a contemporary piece in English, both to assess musicianship (contemporary scores are usually more complex) and English proficiency (talking to donors/patrons is part of the job description for singers).

#### - Voice types are not equally represented in the pool of singers.

Competition for roles is a lot stiffer for young women than young men in opera. Many more female singers (sopranos or mezzo-sopranos) audition than male singers (tenor, baritone, bass, or countertenor). [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaStats/VoicePartFrequencyCount)

### Changes Across Time

As part of my data cleaning process, I looked up the premiere year of every opera in the list. In so doing, I was able to see which decades and centuries produced the most popular composers, arias, and operas. I was also able to track the popularity of different languages across time, to see if a certain country was dominant in a particular era.

Some takeaways:

#### The 19th century was the most productive period for opera.

The 1800s are on top in the number of operas produced, number of arias produced, and frequency of those arias being offered. Many of the composers most closely associated with opera (Verdi, Rossini, Wagner, etc) did most or all of their work in this century. Mozart wrote everything at the end of the 18th century, and he alone accounts for much of the output from that period. [(Graph)](https://public.tableau.com/app/profile/jonathan.heaney/viz/AriaCountbyCentury/)

####
