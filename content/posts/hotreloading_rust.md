+++
title = "I hotreload Rust and so can you"
date = 2026-01-17T10:28:00+01:00
draft = false
+++

<style>
[data-filename] {
    contain: layout;
}
[data-filename]::before {
    content: attr(data-filename);
    position: fixed;
    z-index: 1;
    right: 10px;
    color: rgb(196, 196, 197);
.copy-code {
    z-index: 10;
}
</style>

Hotreloading allows one to change the behavior of a program while it is running.
Unlike a plugin system it is strictly a dev tool.

Usually rust game devs limit their hotreloading to data files.
This is pretty useful already!
It lets one reload graphic assets, shaders, configuration files and even scripts without
restarting or recompiling.

Out of these hotreloading scripts is the most general solution.
Yet it comes with significant costs.
You suddenly have another language to deal with. It comes with different idioms, different tooling and (especially for Rust) different views on how memory is supposed to be handled.
An API exposed from Rust to a scripting language needs to make up the differences.
It is work. It calcifies the design.
Ngl some of my hobby projects have died because maintaining this API layer just became a chore.

What I really want is to use Rust as a scripting language that I can hotreload. Even if its
just for development. This way the API would stay simple, types could be shared directly
and marshalling costs either don't exist or are minimal.

And this is exactly what I am going to show how to set up now.


## Basic idea {#basic-idea}

To get hotreloading we split our game into two parts.
A host which handles communication with the outside world and owns all state that must
persist between reloads. And a worker that contains the functionality which can be
reloaded.

The worker is build both into a dynamic library (dylib) and a static library (rlib).
The static library can be used when we disable hotreloading (by a feature flag) for
shipping.

The worker and the host communicate via a trait object that the host implements and the worker gets called with.
Because Rust does not have a stable ABI doing this is usually highly illegal.
We get away with it, because we use the same compiler and same compiler flags for both the host and the worker, which creates the same ABI on both sides of the FFI.
This behavior is something we can rely on, because rustc supports separate compilation.

This also means that what I am describing here is NOT suitable for a plugin architecture. It is a development aid.


## Initial Setup {#initial-setup}

The platform we use for horeloading is a linux with glibc. (`x86_64-unknown-linux-gnu`).

I know hotreloading dynamic libraries also works on windows, though it has some minor kinks with files that can't be overwritten while in use.
Rust compilation is significantly faster on linux. And it also has faster linkers and is generally the most developer friendly and open out of the big 3 operating systems.

First off lets create a workspace with 3 crates.

```fundamental
$ tree
.
├── base
│   ├── Cargo.toml
│   └── src
│       └── lib.rs
├── Cargo.lock
├── Cargo.toml
├── host
│   ├── Cargo.toml
│   └── src
│       └── main.rs
└── worker
    ├── Cargo.toml
    └── src
        └── lib.rs
```

The `base` crate will contain the shared API and types between host and worker.

`worker/Cargo.toml`:

```toml { data-filename="worker/Cargo.toml" }
[package]
name = "worker"
version = "0.1.0"
edition = "2024"

[lib]
crate-type = ["cdylib", "lib"]

[dependencies]
base.path = "../base"
```

Adding `cdylib` to the crate types makes cargo build a dynamic library (`.so`)
The `lib` type remains, so that we can also static link.

`host/Cargo.toml`:

```toml { data-filename="host/Cargo.toml" }
[package]
name = "host"
version = "0.1.0"
edition = "2024"

[dependencies]
base.path = "../base"
worker = {path = "../worker", optional = true}
macroquad = "0.4.14"

[features]
staticlink = ["dep:worker"]
```

The dependency on the `worker` crate is optional, because we don't need to compile against it when hotreloading.

Macroquad will be our trusty gamedev library for showcasing hotreloading. It can get us a
window and draw something in it with very few lines of code. For this example project lets
draw some text and move it around.

In the base library define a context trait for the communication between worker and host:

```rust { data-filename="base/src/lib.rs" }
pub trait Context {
    fn draw_text(&mut self, x: f32, y: f32, text: &str);
}
```

Then on the host side implement this trait:

```rust { data-filename="host/src/main.rs" }
struct ContextImpl {}

impl base::Context for ContextImpl {
    fn draw_text(&mut self, x: f32, y: f32, text: &str) {
        let size = 30.0;
        let color = BLACK;
        draw_text(text, x, y, size, color);
    }
}
```

The `ContextImpl` would also be so place where we store host site state that we want to
stick around, like handles to GPU resources, file handles or network sockets.

On the worker side we export an unmangled function that uses the context for doing "game stuff":

```rust { data-filename="worker/src/lib.rs" }
#[unsafe(no_mangle)]
#[allow(improper_ctypes_definitions)]
pub extern "C" fn update(c: &mut dyn Context) {
    c.draw_text(50., 50., "Hello world!");
}
```

The function needs to be unmangled so that we can later look it up in the dynamic library.

As mentioned earlier exposing rust types like this is fine in our case which is why we can afford to `#[allow(improper_ctypes_definitions)]`.


## Loading the dynamic library {#loading-the-dynamic-library}

To load a dynamic library at runtime we need to use some variant of [`dlopen (3)`](https://www.man7.org/linux/man-pages/man3/dlopen.3.html) and to unload it we need [`dlclose(3p)`](https://www.man7.org/linux/man-pages/man3/dlclose.3p.html).
Fortunately for us crates.io already has a crate that handles the low level details of loading and unloading (!) dynamic libraries for us.

So `cd` into the host and `cargo add libloading`. We could make this dependency optional
and set it behind another feature flag, but I am not going to bother in this example for
brevity's sake.

Now loading the worker dynamic library at runtime is fairly straightforward:

```rust { data-filename="host/src/main.rs" }
#[cfg(not(feature = "staticlink"))]
mod wrapper {
    pub unsafe extern "C" fn __cxa_thread_atexit_impl() {}

    #[allow(improper_ctypes_definitions)]
    type UpdateFuncT = extern "C" fn(&mut dyn base::Context) -> ();

    pub struct Worker {
        update_func: UpdateFuncT,
        lib: libloading::Library,
    }

    impl Worker {
        pub fn new() -> Self {
            let host_src = std::env::var("CARGO_MANIFEST_DIR").unwrap();
            let path = format!("{host_src}/../target/debug/libworker.so");
            unsafe {
                let lib = libloading::Library::new(path).unwrap();
                let symb: libloading::Symbol<UpdateFuncT> = lib.get(b"hot_update").unwrap();
                let update_func = *symb.into_raw();
                Self { lib, update_func }
            }
        }

        pub fn update(&mut self, context: &mut dyn base::Context) {
            (self.update_func)(context)
        }
    }
}
```

You may have noticed a weird export there. Defining `__cxa_thread_atexit_impl` like this overwrites a check in glibc that prevents unloading dynamic libraries if they use thread locals. Credit to [fasterthanlime for figuring this out in their deep dive on the topic](https://fasterthanli.me/articles/so-you-want-to-live-reload-rust#what-can-prevent-dlclose-from-unloading-a-library).
Doing so means potentially leaking thread locals on reload. This is a prize so small that
its hard to even notice in practice in my experience. And since this only happens in
"development mode" we don't particularly need to worry about it. Just keep in mind that
state stored in a thread local won't be preserved.

Another thing you may notice is that after I loaded the symbol for the `hot_update(..)` function from the dynamic library I keep the `libloading::Library` it came from around.
I do this because dropping it will unload the library via `dlclose`. Which would invalidate our function. So lets not do that.[^fn:1]

For the case where we disable hotreloading we can directly use the `update` function exposed in our worker crate:

```rust { data-filename="host/src/main.rs" }
#[cfg(feature = "staticlink")]
mod wrapper {
    pub struct Worker {}

    impl Worker {
        pub fn new() -> Self {
            Self {}
        }

        pub fn update(&mut self, context: &mut dyn base::Context) {
            worker::update(context);
        }
    }
}
```

Then we package all of this into a bog standard macroquad gameloop:

```rust { data-filename="host/src/main.rs" }
#[macroquad::main("MyGame")]
async fn main() {
    let context = &mut ContextImpl {};
    let mut worker = wrapper::Worker::new();
    loop {
        clear_background(WHITE);

        worker.update(context);

        next_frame().await
    }
}
```

And just like that we can `cargo build` the worker crate, `cargo run` the host crate and get a window to show up:

{{< figure src="/ox-hugo/dyn_loaded_window.webp" >}}


## Stateless hotreloading {#stateless-hotreloading}

Now, to actually reload the worker we need to do four things:

-   recompile the library on source code changes
-   notice that the `.so` file has changed
-   unload the old version of the library
-   load the new one

Recompiling the worker and source code changes is easily done via `cargo watch` or `cargo bacon`.
I use `just` to run `cargo watch` because this can use the correct working directory no matter what directory I currently am in.

```bash { data-filename="justfile" }
[working-directory: 'worker']
watch:
    cargo-watch -x build --clear  --delay 0.05
```

Reducing the event debounce delay from the default of 0.5s also reduces the latency for changes until a recompile happens. When hotreloading every millisecond counts.

Next up is figuring out when to reload the `.so` file. For this we can just use the file creation metadata.
Reading this is pretty quick (about 20 micro seconds on my machine). If you need something fancier you could use the `notify` crate.

```rust { data-filename="host/src/main.rs" }
pub struct Worker {
    // ...
    creation_time: SystemTime,
}

impl Worker {
    // ...
    fn path() -> String {
        let host_src = std::env::var("CARGO_MANIFEST_DIR").unwrap();
        format!("{host_src}/../target/debug/libworker.so")
    }

    fn creation_time() -> SystemTime {
        std::fs::metadata(Self::path()).unwrap().created().unwrap()
    }

    pub fn new() -> Self {
        unsafe {
            // ...
            Self { lib, update_func, creation_time: Self::creation_time(), }
        }
    }
}
```

Now we wrap the whole struct in another wrapper, so that we can drop and recreate it on changes:

```rust { data-filename="host/src/main.rs" }
pub struct WorkerWrapper {
    inner: Option<Worker>,
}

impl WorkerWrapper {
    pub fn new() -> Self {
        Self {
            inner: Some(Worker::new()),
        }
    }

    pub fn refresh(&mut self) {
        let old = self.inner.as_ref().unwrap().creation_time;
        let new = Worker::creation_time();
        if new > old {
            // first drop (and thereby unload) the old library
            self.inner = None;
            // then we can load a fresh one
            self.inner = Some(Worker::new());
        }
    }

    pub fn update(&mut self, context: &mut dyn base::Context) {
        self.refresh();
        let worker = self.inner.as_mut().unwrap();
        worker.update(context);
    }
}
```

We then use the `WorkerWrapper` in main instead.

```diff { data-filename="host/src/main.rs" }
-    let mut worker = wrapper::Worker::new();
+    let mut worker = wrapper::WorkerWrapper::new();
```

Similarly the `staticlink` feature now needs to provide a `WorkerWrapper`.

With all that done we can now hotreload our code:

<video width="100%" controls><source src="/ox-hugo/hotreload_stateless_cut.mp4" type="video/mp4">
Your browser does not support the video tag.</video>

This is pretty fun, but not much of a game.
Let's add controls for the player to move the text around.

First up add a method to grab the pressed input in the base crate:

```rust { data-filename="base/src/lib.rs" }
pub trait Context {
    fn draw_text(&mut self, x: f32, y: f32, text: &str);
    fn is_pressed(&self, input: Input) -> bool;
}

pub enum Input {
    Left, Right, Up, Down,
}
```

Then implement it in the host:

```rust { data-filename="host/src/main.rs" }
impl base::Context for ContextImpl {
    // ..

    fn is_pressed(&self, input: Input) -> bool {
        match input {
            Input::Left => is_key_pressed(KeyCode::A),
            Input::Right => is_key_pressed(KeyCode::D),
            Input::Up => is_key_pressed(KeyCode::W),
            Input::Down => is_key_pressed(KeyCode::S),
        }
    }
}
```

This incidentally also gives us a layer where we can later easily add key remapping.

Alright now to move the text. Except ...
Where does the state for the texts current position go?


## Stateful hotreloading {#stateful-hotreloading}

For the state to persist between reloads the host needs to hold it in some way.
We could add it to the `Context` trait, but that'd get us in trouble with the borrow checker.
Better if we pass that in as an argument to the update function.

We could just make the state a shared type in our base crate. But technically when
hotreloading, the host doesn't need to know what the state actually looks like. It just
needs to hold onto it. So we can copy what C programmers do and only expose a type erased pointer.

```rust { data-filename="base/src/lib.rs" }
/// Wrapper for state that is persisted between reloads
#[repr(C)]
pub struct PersistWrapper {
    pub ptr: *mut u8,
    pub size: usize,
    pub align: usize,
}

impl PersistWrapper {
    pub fn new<T>(val: T) -> Self {
        let size = size_of::<T>();
        let align = align_of::<T>();
        let boxed = Box::new(val);
        let ptr = Box::into_raw(boxed) as *mut u8;
        PersistWrapper { ptr, size, align }
    }

    /// SAFETY: You may only get the type out you put in.
    pub unsafe fn ref_mut<T>(&mut self) -> &mut T {
        assert_eq!(align_of::<T>(), self.align);
        assert_eq!(size_of::<T>(), self.size);
        let ptr = self.ptr as *mut T;
        unsafe { &mut *ptr }
    }
}
```

You may notice that this wrapper doesn't free the content when it is dropped. Not a big
deal because it is supposed to live until the end of the program where the OS then can
clean up.

We then create this state in a new FFI function in the worker:

```rust { data-filename="worker/src/lib.rs" }
pub struct PersistentState {
    x: f32,
    y: f32,
}

impl PersistentState {
    pub fn new() -> Self {
        Self { x: 50., y: 50. }
    }
}

#[unsafe(no_mangle)]
#[allow(improper_ctypes_definitions)]
pub extern "C" fn hot_create() -> PersistWrapper {
    let state = PersistentState::new();
    PersistWrapper::new(state)
}
```

... and put it inside the `WorkerWrapper` on the host:

```rust { data-filename="host/src/main.rs" }
#[allow(improper_ctypes_definitions)]
type CreateFuncT = extern "C" fn() -> PersistWrapper;

pub struct WorkerWrapper {
    inner: Option<Worker>,
    state: PersistWrapper,
}

impl WorkerWrapper {
    pub fn new() -> Self {
        let inner = Worker::new();
        let state = (inner.create_func)();
        Self {
            inner: Some(Worker::new()),
            state,
        }
    }
    // ..
    pub fn update(&mut self, context: &mut dyn base::Context) {
        self.refresh();
        let worker = self.inner.as_mut().unwrap();
        let state = &mut self.state;
        worker.update(context, state);
    }
}
```

Of course this symbol also needs to be loaded and the `staticlink` feature adjusted but you know the drill by now.

With that out of the way we finally have what I think of as true hotreloading:

<video width="100%" controls><source src="/ox-hugo/hotreload_hotpatch.mp4" type="video/mp4">
Your browser does not support the video tag.</video>

Hooray! We finally got we wanted. Hotreloading and preserving state. We can now build a
whole game ontop. Except ...
If you actually go do that and add more and more state and include your favorite
crates at some point you will run into mysterious segfaults after hotreloading.

As it turns out preserving the state like this is _by far_ the spiciest thing we have done here until now.
The problem is dynamic dispatch. Imagine you have a traitobject (like `Box <dyn
Trait>`) in your gamestate somewhere. At a lower level this is made up of two pointers. One
to the data and one to its vtable. The vtable resides inside the shared library. The shared
library gets unloaded and then reloaded at a different memory address. Where does the
vtable pointer point now? Still at the same place as before, but unfortunately there is not
a vtable there anymore but something random.


### Hotpatch all functions {#hotpatch-all-functions}

Maybe dynamic dispatch isn't all that necessary. You know if we are just _really really_
careful and look inside every dependency of ours to make sure they don't use any and we
don't use any ourselves ... we should be good.

So I actually did try this. I used enums everywhere. I noticed that a vtable lets you
dynamically lookup behavior while you statically hold the data, whereas an ECS lets you
dynamically lookup what Entities need to be processed with statically known behavior.
An ECS can be implemented completely without dynamic dispatch, except for running the drop
functions for component types in its internal type erased storage. Since I happened to have
a spare ECS[^fn:2] lying around I added a function to patch the drop functions for all registered components and was good to go.

If you didn't understand what I said in the previous paragraph, don't bother to decipher it
because it is not the way. It did work and I started building a game on top. About 2
months later I ran into weird segfaults after hotreloading. I must have forgotten to
patch a function somewhere. Or used dynamic dispatch in some other way.

But after a couple hours of debugging I came to the realization that this is not
sustainable. Hotreloading is supposed to make my life easier and more pleasant, not
something where I constantly have to _pay attention_ to not break it. If I can make a
mistake once I'll probably do it again.


### Hot-save and hot-load {#hot-save-and-hot-load}

Luckily there is a really simple solution to the problem of carrying invalid function pointers across reloads. Just don't do it!!

If we serialize our game state to a String before a reload and then drop it,
and then after the reload deserialize the game state again from the String,
all our pointers will be pointing at valid locations.

So let's add `nanoserde`, a trusty fast compiling serialization library.
`cargo add nanoserde -F json --no-default-features` to our worker.

Then update the worker with a `before_reload` and `after_reload` export that the host is supposed to call:

```rust { data-filename="worker/src/lib.rs" }
pub struct PersistentState {
    hot_save: Option<String>,
    game_state: Option<GameState>,
}

impl PersistentState {
    pub fn new() -> Self {
        Self {
            hot_save: None,
            game_state: Some(GameState { x: 50., y: 50. }),
        }
    }
}

#[derive(DeJson, SerJson)]
pub struct GameState {
    x: f32,
    y: f32,
}

#[unsafe(no_mangle)]
#[allow(improper_ctypes_definitions)]
pub extern "C" fn before_reload(state: &mut PersistWrapper) {
    println!("Hot-saving state");
    let state: &mut PersistentState = unsafe { state.ref_mut() };
    let s = SerJson::serialize_json(state.game_state.as_ref().unwrap());
    state.hot_save = Some(s);
    state.game_state = None;
}

#[unsafe(no_mangle)]
#[allow(improper_ctypes_definitions)]
pub extern "C" fn after_reload(state: &mut PersistWrapper) {
    println!("Hot-loading state");
    let state: &mut PersistentState = unsafe { state.ref_mut() };
    let s = state.hot_save.as_ref().unwrap();
    let game_state = DeJson::deserialize_json(s).unwrap();
    state.game_state = Some(game_state);
    state.hot_save = None;
}
// ...
pub fn update(c: &mut dyn Context, state: &mut PersistentState) {
    let state = state.game_state.as_mut().unwrap();
    // ...
```

And call them in the host when we do a reload:

```rust { data-filename="host/src/main.rs" }
pub fn refresh(&mut self) {
    let old = self.inner.as_ref().unwrap().creation_time;
    let new = Worker::creation_time();
    if new > old {
        // first drop (and thereby unload) the old library
        (self.inner.as_ref().unwrap().before_reload_func)(&mut self.state);
        self.inner = None;
        // then we can load a fresh one
        let worker = Worker::new();
        (worker.after_reload_func)(&mut self.state);
        self.inner = Some(worker);
    }
}
```

Now we finally got it. This is truly a foundation you can build a whole game on.
You can find the whole repo here: <https://github.com/kampffrosch94/rust_reloaded>

Of course now you need to explicitly mark what parts of the state should be preserved with
a derive macro, but this is a price I am willing to pay.
Complete serialization also comes with extra benefits. For example adding a
quicksave/quickload is now trivial. Or dumping the game state out as json to analyze it
with something like `nushell`.

Take note though that this is not equivalent to having full fledged save games. You
probably want to be more selective in what you save there (preserving UI state is great for
development, but might be weird for players) and think about versioning and backwards
compatibility.

The hotreloading demo I showed before still effectively looks the same with the last
changes. So instead have a video of the game project I develop using
this flavor of hotreloading:

<video width="100%" controls><source src="/ox-hugo/hotreloaded_game.mp4" type="video/mp4">
Your browser does not support the video tag.</video>


## Miscellaneous tips and observations {#miscellaneous-tips-and-observations}

For a pleasant hotreloading experience incremental compile times are very important. If a
recompile takes 30s you might as well not even bother with hotreloading, because that is
long enough to lose flow. Whereas if its below a second you can see the effects or your
changes as you go, immediately adjusting what looks wrong.

The usual tips apply (I like [matklad's post](https://matklad.github.io/2021/09/04/fast-rust-builds.html) on this topic).
Minimize dependencies. Avoid deep generic function chains. Procmacros aren't so bad unless
they generate a lot or deeply generic code. When in doubt check
`cargo rustc -- -Ztime-passes`,
`-Zmacro-stats` and `cargo llvm-lines`. Use mold as linker.

Compile times benefit a lot from the worker/host split. If you need a dependency that
compiles slowly put it on the host and just expose handles to the worker. You'll also need
handles for stuff that isn't gamestate that you want to stick around between reloads like
textures. The simples possible handle is a `&str`, but you can also be as fancy as you want
or need.

If something relies on thread local storage its probably better to put it on the host and
expose it through the `Context` trait. TLS gets leaked on reload, so if you are fine with
instantiating a new one and leaking the old you can do that in some cases.

Immediate mode APIs synergize more with hotreloading than retained mode APIs. If you
recompute a value each frame, changing how the value is computed will immediately show a
change. If the value is stored you will also need to trigger a recomputation in some way.

The example I provided is completely single threaded and sync.
I think this is preferable for game logic. Put parallel and concurrent stuff on the host.
I have tried async on the worker and it works. You'll just have to drop or run to completion all your futures in the `before_reload` function. Similarly with multithreading you'd need to join all threads.

If you are feeling slightly spicy (I know I do) you can use a panic handler in the workers
`hot_update` function. Then a panic in the gamelogic doesn't bring the process down and you
can hotreload in a fix. This won't help you if you run into an infinite loop though.
Interpreted languages win here, because they can easily use "fuel" to quit an invocation
when processing takes too many steps.

A nice thing about hotreloading is that it lets you plop in custom debug visualizations as
you go. These then also benefit from hotreloading, you can adjust quickly until they really
show what you need to know.

If you want to be fancy you can use reflection[^fn:3] to let the host interact with types it doesn't actually know. I use this here for a little object inspector UI:

<video width="100%" controls><source src="/ox-hugo/quicksilver_demo.mp4" type="video/mp4">
Your browser does not support the video tag.</video>


## Other approaches and acknowledgments {#other-approaches-and-acknowledgments}

Of course my approach to hotreloading is not the only one. I want to mention a couple other projects I find interesting.

-   [subsecond](https://lib.rs/crates/subsecond): This is a pretty high profile hotreloading framework by the dioxus people. Atm
    it is still experimental and can't do everything I'd want, but especially their approach
    to decreasing linking time sounds interesting.
-   [relib](https://docs.rs/relib/latest/relib/docs/index.html): This is a framework that also uses a host/worker split. It adds more safety and
    leak handling, at the cost of complexity. I must admit I have not looked too deep into
    it, but it seems interesting.
-   [inline tweak](https://docs.rs/inline_tweak/latest/inline_tweak/): If all you need to hotreload is a little literal here and there inline
    tweak is your friend. It has the drawback that you can only start tweaking after
    explicitly marking the location you want to hotreload and recompiling. It has the big
    advantage of not requiring you to architect your application around it in any way.


## Last words {#last-words}

Alright, I hope you got something from this post.
Hotreloading is a bit of memetic hazard, once you tried it you don't want to miss it.
But now you know how to implement it.

[^fn:1]: You can also just not transform the symbol into a function pointer via
    `*symb.into_raw()` if you'd rather deal with lifetimes than upholding this invariant. In
    this case upholding the invariant is trivial though; and dealing with the lifetime is a bit
    more annoying.
[^fn:2]: <https://github.com/kampffrosch94/froql> This ended up as an ECS by happenstance. The
    original problem I tried to solve was "How do I make dealing with graph-like state less of
    a hassle in Rust?". I am pretty happy with the result.
[^fn:3]: Like `facet` or my own <https://github.com/kampffrosch94/quicksilver>. Ofc I wrote my own, compile times were at stake!
