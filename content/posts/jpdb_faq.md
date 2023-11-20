+++
title = "jpdb FAQ"
date = 2023-11-20T17:39:00+01:00
tags = ["jpdb"]
categories = ["japanese"]
draft = false
+++

This is still somewhat half finished, but since I don't really feel like
working on it and the questions answered here do come up all the time I think it
is time to publish it.

In general I recommend actually reading through all the [settings](https://jpdb.io/labs/settings) and the
official [FAQ](https://jpdb.io/faq) once. They explain a lot.


## What is the coverage number on decks? {#what-is-the-coverage-number-on-decks}

-   Its how much of the vocab in the deck you know weighted by the amount of occurences.
-   AAABB &lt;- if you know A but not B its 60% coverage


## Why do nothing and something give me the same 2min interval? {#why-do-nothing-and-something-give-me-the-same-2min-interval}

-   After a failure (nothing/something) you won't a review interval but a failure
    interval instead (2min default)
-   Only after getting the card correct once will its review be scheduled by the scheduler again.


## What coverage to go for {#what-coverage-to-go-for}

-   <https://www.sinosplice.com/life/archives/2016/08/25/what-80-comprehension-feels-like>
-   When I was still pre learning I liked to stop at 90% coverage, its a good
    tradeoff between coverage and effort required.


## Word limits {#word-limits}

-   60k for non patreons, 200k for patreons
-   deck limit: 10k, 50k for patreons
-   if you hit it you will get a server error telling you to remove cards


## The mpv plugin does not work for me. Why? {#the-mpv-plugin-does-not-work-for-me-dot-why}

-   Check that you have a version with luajit enabled installed.
-   You can check this via a console command `mpv -v | grep luajit`
-   Homebrew users had some issues with the version from there.
-   Also make sure that your firewall doesn't block it.


## Will deleting the last deck that contains a card delete that cards history? {#will-deleting-the-last-deck-that-contains-a-card-delete-that-cards-history}

No. It just won't show up in your reviews until a deck containig it is added again.


## What does abandoning do? {#what-does-abandoning-do}

-   Takes all currently due cards (with the due + failure state) and inserts an
    abandoned marker into their history.
-   They will be treated is if their history was reset for all purposes.


## How do I make a top X frequency deck? {#how-do-i-make-a-top-x-frequency-deck}

-   There is a button for that at the bottom of <https://jpdb.io/learn>

{{< figure src="/images/topdeck.png" >}}


## Can Kanji cards be marked as known? {#can-kanji-cards-be-marked-as-known}

No. But they can be blacklisted.


## Can I export my known kanji? {#can-i-export-my-known-kanji}

-   here: <https://jpdb.io/export/known-kanji.csv>
-   this includes only the ones in a known state


## Can I see the front of the review queue somehow? {#can-i-see-the-front-of-the-review-queue-somehow}

No. Best make a FORQ deck instead. This means putting a deck at the top of your learning order in which you put vocab instead of adding it to the front of review queue.


## Is Bunpro any good? {#is-bunpro-any-good}

-   it works
-   lots of people that use jpdb use it
-   it can feel very punishing if you are not consistent with it
-   whatever you do don't rush into adding lots of cards, its even worse than
    (old) anki with overwhelming peop
