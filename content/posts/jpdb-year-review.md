+++
title = "one year of jpdb"
date = 2023-03-25T14:34:00+01:00
tags = ["jpdb"]
categories = ["japanese"]
draft = false
+++

Hi, my name is Kampffrosch and I learn Japanese using various tools.
Yesterday I hit a milestone of 365 continuous days of study using [jpdb](https:jpdb.io), so I thought it would be a good time to review my Japanese learning journey.

{{< figure src="/images/365_day_streak.png" >}}


## the dark ages {#the-dark-ages}

2015 some friends I knew from school asked me if I wanted to take some Japanese classes with them. Since I was watching tons of anime at the time I thought "Sure, might as well learn a language while I am at it." Things weren't quite that easy. I had other things on my plate and did not want to actually focus on Japanese. So after 2 years of classes (and not doing pretty much anything besides that) I got to a level where I could probably have passed the N5 but not much else.

In the following years I used various phone apps ([kanji tree](https://play.google.com/store/apps/details?id=com.asji.kanjitree.pro) mostly) to more or less RTK the first 1k Kanji. I also did a bit of Anki (Core2k deck), but it was painful and I never got anywhere before stopping for months at a time.

2017 I went on a 2 week vacation to Tokyo. I spent much of that time in various bookstores and brought a suitcase full of manga back home. Manga which I could not read. I forced myself to read a bit of Yotsubato! but it was very slow and excruciating. After 3 Volumes I stopped.

2021 I discovered [bunpro](https://bunpro.jp). I thought "Hey, popup dictionaries are a thing, I bet if I just force myself through grammar real quick I can read pretty much anything."
I managed to do all of N5 and most of N4 before I burned out and stopped. I did zero vocab study at the time.

September 2021 I discovered jpdb after reading about it on reddit.
I was very impressed, saw that I could import my half done anki deck, turn arbitrary text into decks and that the whole thing was written in rust. I became a patreon immediately and even joined the discord briefly where told some kids about the various uses of the Zollstock.

Energized and enlightened about the importance of immersion I watched 20 episodes of [kumo](https://jpdb.io/anime/7450/kumo-desu-ga-nani-ka), using the awesome [memento](https://ripose-jp.github.io/Memento/) video player for lookups. Needless to say, I pretty much white noised all of it. After that I listened to some beginner podcasts but did not stick with them.


## slight progress {#slight-progress}

Over the coming months I would sometimes log back into jpdb and do a couple cards, just a few on the side. And I noticed something peculiar. Unlike anki which would beat my failures over my head continuously, jpdb was very gentle. Even when I only reviewed every couple days or weeks, things were manageable. After a while I even learned some new words, not many, but some. Then I'd stop for a month or so, and then continue where I left of, really casually going along with it.

In April 2022 I linked patreon to discord for some unrelated reason, which automatically added me back to the jpdb.io discord server. People there took note and greeted me. Now that I had some experience with the site, I became more interested in the discussions there.
People were sharing their progress. Some had astonishing numbers of vocab learned.
20,000 or even more!
Some were adding over 500 new words every week!
"How do you manage that?" I asked impressed. "Immersion." they answered.


## eventual consistency {#eventual-consistency}

At this point I already had 20 days of daily SRS under my belt.
My growing engagement with the jpdb community also reminded me to do my reviews.
And I was jealous of the people that reported reading for hours every day.
I yearned to be as good as them, so that I too could finally immerse. What a fool I was.

I began to take SRS seriously. Adding 20, then 30 words every day. Some days even more.
I picked the flagellation device that is bunpro back up again. Some days I'd spent hours practicing.
I wanted to finally be able to read Japanese!
I stopped reading books. I stopped playing games. I spent my free time on learning Japanese and talking about learning Japanese.

After finishing the jpdb top 2k deck I started prelearning. I picked an anime that sounded achievable and pulled all my cards from that. I had kanji cards enabled, but only in the kanji -&gt; keyword direction.

At the end of April I started watching Anime again. Easy stuff, at slightly below 80% coverage. This time I even understood a good chunk of it! I didn't watch for enjoyment, just for immersion.

I tried reading a book called [MOYOM](https://learnnatively.com/book/2c1e37ec2e/), because people praised it as really easy and recommended it to beginners. I read 30-40 pages, understood nothing, then shelved it.


## manga arc {#manga-arc}

At the end of May I found out about [mokuro](https://github.com/kha-white/mokuro), the straight up best tool for learning Japanese through manga. I read a couple trashy isekai (ignoring all the rpg stat bits) and felt like I was doing well for the first time since I started in 2015.
Since copy pasting words from mokuro into jpdb was too annoying I developed a little program I called [jpdb-connect](https://github.com/kampffrosch94/jpdb-connect) to make things easier for me.

More SRS. More study. Working on tooling. Made the [jpdb-unproblemizer](https://github.com/kampffrosch94/jpdb-unproblemizer) to combat leeches. Not much more immersion. Until the July [tadoku](https://tadoku.app) came around, where I finally had my breakthrough.

I started reading [nagatoro](https://learnnatively.com/book/9cb1f67642/). 13 volumes were out at the time and I was hellbent on finishing all of them. I was convinced of the value of [narrow reading](https://morg.systems/Optimal-Reading-Immersion---Narrow-Reading).
I started out reading about 3 or 4 chapters a day, then did whole volumes, until I ran out of nagatoro on the 13th of July.
The rest of the month I spent reading some visuals novels which I'd prefer not to name :D
800 points for my first serious tadoku attempt was not bad.

During tadoku too many reviews had piled up on bunpro so I just reset it. I had the intention to start again, but I dreaded it, so I delayed.
After some discussions I became convinced that more dedicated grammar study would be more trouble than its worth for me.
I have done zero dedicated grammar study from that moment on and don't regret it one bit.

But I still spent a lot of time on jpdb. An hour a day, sometimes more. Some cards I'd fail 10 times a day or more before I passed them. My retention rate was about 60%, but I still made a lot of progress on vocab (see figure 1).
I discussed this with the wise people of the jpdb discord and concluded that a low retention rate is not the end of the world. Some people even increase their SRS interval length, because targeting a lower retention rate is theoretically more efficient (when only looking at review amount) than getting a higher retention rate with more reviews.
I started to suspect that retention rate is a lie (or rather a bad metric to target).
I even lengthened my own review interval. And after noticing no averse effects I lengthened it further until it hit the maximum at the time.
People also recommended I turn off kanji cards, but I hesitated.

{{< figure src="/images/vocab_known_redundant_2022.webp" caption="<span class=\"figure-number\">Figure 1: </span>known vocab count on jpdb (including redundant vocab)" >}}

Another site that helped me a lot is [learnnatively](https://learnnatively.com). I had been using it for a while to track what I was reading. Over the months more and more people joined and graded the difficulty of various books and manga against each other. Since the db of jpdb does not include manga, this made it the best resource to find manga on my level.
A friend I made during my time in Japanese classes recommended Gleipnir to me. He said it would become real weird later. I was intrigued. I checked it out on learnnatively and it was around the level of some other manga I have read before. My goal for the September tadoku was set.

In the September tadoku I started out reading half a volume a day. After a couple days the story became interesting. I was completely hooked. I read a volume in a day. Shortly after 2 volumes in a day. Had to take a break do to RL stuff, but finished with an epic 5 hour session in which I read 3 volumes in sequence. I felt powerful, invincible even.
Yet I had run out of Gleipnir to read. I tried some other manga but they didn't scratch the same itch.
Dejected, I stalled out and turned my gaze back to anime land.


## anime arc {#anime-arc}

In August the folks in the jpdb discord founded an anime club. Every week the members would discuss a couple episodes of an anime. The anime was decided by vote and season 1 would be watched from start to finish before a new one was chosen.
I decided to participate back then and have participated in discussing every single chosen anime ever since (some more reluctantly than others).

The following weeks I got busy with real life and barely kept up with SRS. When I got back into it I was just watching a bit of anime, but not a lot.

In November I was not feeling tadoku at all. Nothing I could read sounded appealing.
I also noticed that anime I have not purposely prelearned for started hitting 90% coverage.
Since I spent more time on SRS than immersion a radical change was needed. Something big.
I swore to not add a single new card to jpdb until I have watched 5 anime of at least 12 episodes each.

That took me about two weeks :D. I experienced another breakthrough, this time in listening stamina. The last couple days I was able to do 10+ episodes, when I started I was barely managing 3.

I also concluded that prelearning from this point on would be inefficient and switched to a mining only workflow.
SRS also got less stressful when I decided to only grade myself based on getting the reading right. Meanings can be picked up from context without lookups, readings not so much.
I finally realized that SRS is just a tool to get me ready for immersion and that the actual learning happens during immersion, not during SRS.


## booking it {#booking-it}

In December I noticed I had 95% coverage on MOYOM. Many of my jpdb compatriots had read this book or were currently reading it. And it was already on my kindle. So I decided to finish it before the year is over.

It was hard. The language was not so bad, but unlike Gleipnir or Nagatoro the story didn't grab me at all. I read it because I wanted to have read a book in Japanese. So I forced myself through. The kindle estimate was about 20hours, but that turned out to be goddamn lie. I reckon I spent about double that. But I did it. I am proud of it. And I haven't touched another book since.


## January tadoku {#january-tadoku}

In January I set my goal to 1000 points with manga only, which translates to about 5000 manga pages. One of my discord buddies also started immersing with easy manga + mokuro and he took off like a rocket.
I had a lot of fun racing him, especially when we read the same manga (Happiness, its very easy, not sol and good).
I also read another edge lord approved manga called Fire Punch, which I liked a lot. I also watched the chainsaw man anime (from the same mangaka) which had just finished airing.

After two weeks of intense tadokuing the dreaded real life came knocking once again and I more or less dropped out of the competition. Barely made it to my goal of 1000 points in the last hour of the month, so all is well that ends well.


## processing mined vocab {#processing-mined-vocab}

At this point I had a pretty big mining deck from the previous tadoku and the various anime I watched. Multiple thousands of cards I had yet to learn.
To deal with them I devised the following strategy.

Have two FORQ Decks (which mimic the native forq functionality). One for easy and one for hard cards. After a mining session I'd go through my mining deck in reverse chronological order and add all the cards where the reading was obvious to me to the easy forq deck.
Some of the vocab cards with unknown kanji I deemed valuable to learn I added to the hard forq deck. All other vocab was ignored.
I always tried to learn all vocab from the easy forq and only a bit from the hard forq, so that I would not get overwhelmed.

I also started watching some anime I knew were bad on the side while chatting or browsing the web.
I would not give them my whole attention, but I also couldn't completely tune them out.
I did not mine or specifically pre learn for these, but I picked them from anime where I had good coverage.


## march: tadoku, but with listening this time {#march-tadoku-but-with-listening-this-time}

My goal this time was reading VNs. I read all of [shinimasu](https://vndb.org/v21768) in two large sessions, the first part was really good, the other half dragged on a bit.

In march the first official competition with the reworked tadoku started.
Tadoku was now an all around immersion tracker. Everything you do, no matter if its listening or reading or even outputting can be tracked. People can create custom contests if they prefer to only have a leaderboard for reading in Japanese. Sounds great right?

Alas, I am not so sure about that development. The big benefit tadoku had for me was the spirit of competition. Even if you are not at the top of the leaderboard you can pick someone of similar skill level to you and compete against them.
But now, everyone does something completely different and does so in differing amounts.
I must confess that I just feel lost with the current iteration of tadoku, it seems like I just feed logs into a void and nobody cares anymore.
Also logging literally everything I do down to the precise minute feels like a chore. According to tadoku rules you are supposed to be paying attention, so what if I listen to a podcast while doing something else and only pay attention some of the time?
It was all around a hassle for not much benefit, so I just dropped it.

I might revisit it in the future and organize something similar to the jpdb anime club. Maybe a manga tadoku club would be nice? It certainly does sound nice.


## reducing time spent on SRS further {#reducing-time-spent-on-srs-further}

I still spent a lot of time on SRS. Even when using experimental schedulers on super long interval settings.
When a jpdb update introduced a custom failure cool down setting, I saw my chance.
What I do now is this: I set my failure period to a week during the week. On the weekend I reduce it back to normal. Go through my failures once or twice. Then abandon all that didn't make it.

I have so much vocab on jpdb now, that yeeting 50 or 100 cards doesn't set me back much. I also add new cards from mining all the time. What is hard now will be easy once I have immersed a bit more.

Another thing I did was finally dealing with kanji cards. I still wanted to see which vocab had new kanji (which locks them on jpdb if you have kanji cards enabled). But I didn't want to review them anymore. So I just blacklisted all kanji cards I have ever reviewed with this command.

```bash
cat reviews.json | jq -r '.cards_kanji_char_keyword[].character' | \
xargs -I {} echo \
"curl 'https://jpdb.io/blacklist' -H 'Cookie: sid=${SID}' -d 'k={}' && sleep 1" | sh
```

When I learn a new kanji now I write it out on paper a couple time, then immediately blacklist it. Just 1000 more to go in the top 30k words :|


## lessons learned and other hot takes {#lessons-learned-and-other-hot-takes}

We have arrived in the here and now. I think this is a good spot to spout some insights I have gained from my experiences and talking to other people.

-   If you know more than 1000 words and spent more than 30 minutes a day on study (jpdb, bunpro, anki, wanikani, birdprogram, imabi, ...), I suggest you re-prioritize and reorganize and spend that time on immersion instead. You need to immerse to get anywhere. Prioritize it.
-   All stats are fake. People use different criteria for grading their SRS, for rating media difficulty, even for time spent on something.

    A real pet peeve of mine is retention rate. Every time someone joins the discord and asks "I only have 85% retention rate on jpdb and not 99.9% like on anki, should I shorten my interval?" I roll my eyes so much they threaten to screw out of my skull. It's a real health hazard, I tell you. I have spent months on 50% retention rate and still made big gains. If you really have to track and compare something to other people, track immersion. That will at least lead you down a productive road.
-   Immerse in something you like. Don't force yourself through boring stuff because you "should". You should immerse more! Enjoyment leads to immersing more, to focus, to forming connections in your brain and thus to learning. And it prevents burnout. All the big immersion chads I know like what they are immersing in, no exceptions.
-   Digital manga with mokuro is what I'd recommend for beginners. Easy manga do contain actually good stories unlike other media (this is of course subjective, if you like moe or sol you'll have an easy time anywhere). Even with the abysmal reading speed of a beginner you can actually get somewhere in the story in a reasonable amount of time.


## conclusion {#conclusion}

After spending a year of consistent study my comprehension abilities have increased manyfold.
I have now seen 412 episodes of anime, read 69 volumes of manga, 3 short VNs and a single book.

I know from experience that I would have not made it this far using other tools than jpdb for my vocab study, so I am really grateful.

That is all I have to say. I hope you too will see success on your language learning journey.

{{< figure src="/images/vocab_over_time_2023-03-25.png" caption="<span class=\"figure-number\">Figure 2: </span>known vocab count on jpdb (not including redundant vocab)" >}}
