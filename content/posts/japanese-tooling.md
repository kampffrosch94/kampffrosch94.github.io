+++
title = "tools for learning Japanese"
date = 2023-09-07T11:22:00+02:00
categories = ["japanese"]
draft = false
+++

Sometimes it feels like at least half the people learning Japanese are comp sci students or
programmers.
Given that I am one of those myself I know what it feels like when one has an idea for a project
that will help them study japanese so much more efficiently.
You may think: "Just a couple hours of work and efficiency will increase. It will be worth it."
It will be worth it for other people. But the efficiency increase will not make
up the time spent working on the tool for you personally, unless the tool is trivial to build.

It is a better idea to use tools built by other people and adapt them to your use case if possible.
Or to just live with not everything being perfect.

Here is a list of tools I have used/use and like. Tools that don't meet these two criteria are omitted.
The list only includes what I consider essential to know for the sake of brevity.


## [yomichan](https://addons.mozilla.org/en-US/firefox/addon/yomichan/) {#yomichan}

An in browser popup dictionary for Japanese.
It can not only lookup vocab instantly, it also supports grammar dictionaries.
Grab some from [Marv's list](https://github.com/MarvNC/yomichan-dictionaries/) if you feel so inclined.
Since yomichan is EOL, its good to have an eye on its successor [yomitan](https://github.com/themoeway/yomitan) too.


## [jpdb](https:jpdb.io) {#jpdb--https-jpdb-dot-io}

Its like a better anki for Japanese vocab with all the batteries already included. Highly recommended.


### jpdb mpv plugin {#jpdb-mpv-plugin}

Its available for jpdb patreons only. Makes mining sentences from video a breeze.
If you don't want to become a patreon or prefer anki [memento](https://ripose-jp.github.io/Memento/) is an alright alternative.

{{< figure src="/images/mpv_plugin.png" >}}


### [jpd-breader](https://github.com/max-kamps/jpdb-browser-reader) {#jpd-breader}

A browser based popup dictionary that very deeply integrates with jpdb.
Grading while reading is possible.

{{< figure src="/images/breader.png" >}}


## [mokuro](https://github.com/kha-white/mokuro) {#mokuro}

_The_ tool for OCRing manga. Acquiring manga as offline images can be annoying but its worth it for this.
The breader has builtin support for it.

{{< figure src="/images/nagatoro.png" >}}


## VN Setup {#vn-setup}


### [JL](https://github.com/rampaa/JL) {#jl}

An awesome popup dictionary made with VNs in mind. Can be laid over the text box of a VN and used instead. Can be used for mining with [jpdb-connect](https://github.com/kampffrosch94/jpdb-connect).
Does work with magpie.


### [Textractor](https://github.com/Artikash/Textractor) {#textractor}

Gets the text out of VNs for usage with JL. Worked with any VN I have tried so far.
If you use a [clipboard inserter](https://github.com/laplus-sadness/lap-clipboard-inserter) and a texthooker page like [this](https://anacreondjt.gitlab.io/texthooker.html) you can use yomichan/the breader with VNs.


### [Magpie](https://github.com/Blinue/Magpie/blob/main/README_EN.md) {#magpie}

Scales up low res VNs (or anything really). Works pretty well. Also runs on potato hardware.
