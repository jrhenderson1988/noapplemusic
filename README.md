# noapplemusic

A tiny application that prevents Apple Music from opening.

## Why?

There are plenty of reports online about Apple Music spontaneously opening when running on MacOS.
There can be all kinds of different causes for this, but there does not seem to be a reliable way of
preventing it happening. There don't appear to be any options inside Apple Music's configuration to
turn this "feature" off.

In my personal case, this usually happens when connecting Bluetooth headphones and quite regularly
while moving around the house. Apple Music can sometimes pop up out of nowhere and it usually steals
focus.

I personally find this to be very annoying and have long tried to find a solution to prevent it
happening.

The best solution so far that did work for some time was to use
[noTunes](https://github.com/tombonez/noTunes), however it has recently stopped working for me on
MacOS Ventura.

This prompted me to build an application to scratch my own itch.

## How does it work?

Every 2 seconds, the application looks at the command/name of every running process and compares it 
with the known path of Apple Music. If it finds the Apple Music process running, it issues a command
to kill it by its PID (process identification number).

## Getting started

### Building

Currently, there are no released artifacts for the project, so the only way to set it up is to build
it from source. The application is built using Rust and requires the
[Rust toolchain](https://www.rust-lang.org/tools/install) to be installed to build it.

- Download or clone the repository:
  ```bash
  $ git clone git@github.com:jrhenderson1988/noapplemusic.git
  # or
  $ git clone https://github.com/jrhenderson1988/noapplemusic.git
  ```
- Build a release version of the application:
  ```bash
  $ cargo build --release
  ```
- This will create an executable binary located at `target/release/noapplemusic`
- If you would like to be able to execute the application from anywhere by running `noapplemusic`, 
  move the binary to somewhere inside your PATH 

### Running

- `cd` into the directory where the binary is located, or if you've added to your PATH you can skip 
  this step.
- Run the binary by executing `$ noapplemusic`
- Try opening Apple Music. If it opens at all, it should disappear within 2 seconds.

### Running in the background on startup

The recommended way to run the noapplemusic on startup is to use `launchd`. To do this:

- Create a file under `~/Library/LaunchAgents/com.github.jrhenderson1988.noapplemusic.plist` with 
  the following content (replace `{{{PATH}}}` with the path to your binary, or you can remove it, 
  leaving just `noapplemusic` if you added it to your PATH):
  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>com.github.jrhenderson1988.noapplemusic</string>
      <key>ProgramArguments</key>
      <array>
         <string>{{{PATH}}}/noapplemusic</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
  </plist>
  ```
- Run `launchctl load -w com.github.jrhenderson1988.noapplemusic.plist` to enable and execute it 
  with the `launchd` agent. This will also configure it to run on startup.
- To stop the application started this way, and remove it from running on startup, you can run 
  `launchctl unload -w com.github.jrhenderson1988.noapplemusic.plist`