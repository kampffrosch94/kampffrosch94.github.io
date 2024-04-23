+++
title = "1 book a week for 4 months"
date = 2024-04-23T20:56:00+02:00
categories = ["japanese"]
draft = false
+++

In my previous post I said I wanted to read 100 books in japanese as preparation for the JLPT in December.

The plan was split into three simple parts:

-   read 1 book per week for 4 months
-   read 2 books per week for 4 months
-   read 3 books per week for 4 months

That together with the 3 books I read before starting on the challenge would get me to 100 books read with even two weeks or so to spare.
All in the name of preparing for the JLPT-N1.


## About Metrics and Targets {#about-metrics-and-targets}

[Goodhart's Law](https://en.wikipedia.org/wiki/Goodhart%27s_law) states: "When a measure becomes a target, it ceases to be a good measure".
I've kept this piece of wisdom in mind when I planned what to read.

In this case maximizing for books read would mean only reading very short books (think around 50k-60k characters).
That is something I am intentionally not doing.
I was trying to balance my reading list so that the average book would be about 100k characters long.
Doing so was fairly easy, in the fantasy genre lots of books are around 130k or more. So far so good.


## Let's see how I actually did {#let-s-see-how-i-actually-did}

I tracked this by hand for the most part, but why do by hand in a minute what you can automate in an hour.
I am using <https://learnnatively.com/> to track my immersion and it provides quite detailed exports of its data as `.csv` files.

```python
from tabulate import tabulate
import pandas as pd
folder = "~/documents/org/assets/attach/4d/ace1bf-0217-4379-a72a-35559b542403"
f = "2024-04-16--11-07-10--Kampffrosch_895c34_user_books_2024_04_16_05_07_06.csv"
df = pd.read_csv(f"{folder}/{f}")
df = df.query("Status == 'finished' and `Book Type` != 'manga'")
df = df.query("`Date Finished` > '2023-11-31' and `Date Finished` < '2024-04-01'")
df = df.sort_values("Date Finished")
df = df[["Book Title", "Date Started", "Date Finished", "My Rating"]]

print(tabulate(df, headers='keys', tablefmt='orgtbl', showindex=range(1,len(df)+1)))
```

|    | Book Title                               | Date Started | Date Finished | My Rating |
|----|------------------------------------------|--------------|---------------|-----------|
| 1  | 誰が勇者を殺したか                       | 2023-11-26   | 2023-12-03    | 3         |
| 2  | キノの旅 1                               | 2023-10-23   | 2023-12-11    | 4         |
| 3  | この素晴らしい世界に祝福を!(1)           | 2023-12-11   | 2023-12-17    | 3         |
| 4  | 乙女ゲームの破滅フラグしかない悪役令嬢に転生してしまった... 3 | 2023-12-17   | 2023-12-23    | 4         |
| 5  | 雨の日も、晴れ男                         | 2023-12-24   | 2023-12-25    | 4         |
| 6  | 六花の勇者 1                             | 2023-12-26   | 2024-01-03    | 4         |
| 7  | 異世界迷宮の最深部を目指そう 1           | 2024-01-03   | 2024-01-10    | 3         |
| 8  | 六花の勇者 2                             | 2024-01-10   | 2024-01-21    | 3         |
| 9  | この素晴らしい世界に祝福を!(2)           | 2024-01-21   | 2024-01-28    | 2         |
| 10 | 伝説の勇者の伝説〈1〉昼寝王国の野望      | 2024-01-29   | 2024-02-04    | 4         |
| 11 | ひげを剃る。そして女子高生を拾う。       | 2024-02-04   | 2024-02-11    | 2         |
| 12 | 伝説の勇者の伝説〈2〉宿命の二人三脚      | 2024-02-12   | 2024-02-21    | 3         |
| 13 | 変な家                                   | 2024-02-23   | 2024-03-01    | 2         |
| 14 | バッカーノ! The Rolling Bootlegs (電撃文庫 な 9-1) | 2024-03-01   | 2024-03-09    | 5         |
| 15 | 黒い森の記憶                             | 2024-01-30   | 2024-03-11    | 4         |
| 16 | 悪逆騎士団 そのエルフ、凶暴につき        | 2024-03-11   | 2024-03-23    | 2         |
| 17 | くまクマ熊ベアー 1                       | 2024-03-24   | 2024-03-30    | 2         |

From <span class="timestamp-wrapper"><span class="timestamp">&lt;2023-12-01 Fri&gt; </span></span> to <span class="timestamp-wrapper"><span class="timestamp">&lt;2024-03-31 Sun&gt; </span></span> its 17 weeks and 2 days[^fn:1]. So I guess I actually kinda made it with cheating a little. Surprising.
I actually thought I did not.


## What happened in April so far {#what-happened-in-april-so-far}

Unfortunately after kuma I only finished two other books.
Life and work got in the way, eyestrain got so bad I had to switch to audiobooks for a while (better now :gladge:) and I also kinda ran out of steam a bit if I am honest. Started watching more anime and reading things in English about programming and the workings of the mind (俺のマイブーム).

I am definitely not doing 2 books a week like I originally intended.


## Where to go from here {#where-to-go-from-here}

For now I am just gonna continue reading series I have already started and liked.
I wrote some tools, did some calculations and concluded that mining from easy books is
about as useful for my overall coverage as mining from hard works (posts about that also
coming sometime in the future).
I've adjusted my goals now that I've got some experience and gonna aim for one book
for every week of the year (currently 2 behind). That's not nothing and fairly easy to
achieve even if I don't find a series to binge (still looking for the one unfortunately).

I did a decent amount of listening lately (cause I was forced to) and noticed that its
actually really easy, provided you have excellent coverage.
I always assumed that would be the case, but its nice to know for sure now.
I am going to do some more of that.
Listening to random high coverage audiobooks while walking around and watching anime without
subtitles should be plenty.

I bought the shinkanzen grammar books for N2 and N1 and kinda regret it already.
Now I really have to do it. It saps my spirit and sucks away so much time though.
At least these books are written in Japanese, so they count towards my book goal.

Not sure if this is enough to pass the JLPT-N1 in December but I'll attempt it even if I end
up failing catastrophically.

[^fn:1]: Checked this with <https://www.weeksuntil.com/weeksbetween/>
