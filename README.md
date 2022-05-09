
<!-- Header -->
<img src="https://user-images.githubusercontent.com/39813066/130519018-d2faff43-45b0-4026-b313-cdbe0ce91e18.png" width="80px" align="top"/>

<div>
  <h1>Informant 🔍</h1>
  Informant is a file inspector for macOS that saves you from having to press <code>⌘ + i</code> all the time.
</div>

<br>

<!-- Shields -->

<div>
<img alt="GitHub issues" src="https://img.shields.io/github/issues/tyirvine/Informant?color=bright%20green">

<img alt="GitHub all releases" src="https://img.shields.io/github/downloads/tyirvine/Informant/total?color=bright%20green">

<img alt="GitHub" src="https://img.shields.io/github/license/tyirvine/Informant?color=bright%20green">

<img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/tyirvine/Informant?style=social">
</div>
  
# Install ☁️
#### [**Download**](https://github.com/tyirvine/Informant/releases/latest/download/Informant.zip) - **Requires macOS 11.0 or later**
Afterwards, unzip `Informant.zip` and drag `Informant` into your Applications folder.

# Contributing  🔨
1. Start by forking this project **"To contribute to the parent project"**.
2. Then, clone your fork to your computer and open it with Xcode.
3. Checkout the most up-to-date branch. Each branch corresponds to a version of Informant.
4. Run Informant, play around, make your changes, commit, push, and then open up a pull request that merges your changes into the **base repository** (this repository).

An admin will then review the changes and merge them in. At some point your changes will make it into a release if they're approved!

**⚠️ Attention** <br>
Please remove your Development Team ID and set the certificate to `Sign to Run Locally` in `Signing & Capabilities` prior to making a pull request.

# Feedback  📣

### Creating a new issue

Before submitting a new issue be sure to check if it already exists in the [issues](https://github.com/tyirvine/Informant/issues) tab.

If you've found a new problem with Informant, please [create a new issue](https://github.com/tyirvine/Informant/issues/new/choose) and try to be as descriptive as possible when explaining what's wrong. Be sure to include any screen-shots of the problem you have.

### Here's some tips for explaining your issue ⤵︎

* What were you trying to do? What happened? And what did you expect to happen?
* What are some steps we can take to try and reproduce the issue?




# Frequently Asked Questions  💬

### Why is some file information unavailable?
There are some files that Informant simply cannot read because of macOS security protocols. For example, Informant cannot read iCloud Synchronization Files - `.icloud`.

However, if it's a file with a normal extension, and it's not stored in a Network volume then you may need to authorize Informant ⤵︎

1. Open `System Preferences` and select `Security & Privacy`.
2. Select the `Privacy` tab.
3. Scroll through the list on the left and select `Accessibility`.
4. Unlock your settings by clicking on the lock in the bottom left corner and following the instructions.
5. In the list on the right check Informant.
6. Then scroll through the list on the left and select `Automation`.
7. In the list on the right, underneath Informant, check 'Finder'.

Some items require special permissions, so you may need to also grant Informant full access to the disk. This permission can be found by going to `Security & Privacy > Accessibility > Full Disk Access` and checking off Informant in the scroll menu to the right.

After authorizing, you may need to quit Informant and re-open it.

### Is Informant localized?
Informant is not localized at the moment but if you'd like to help update translations you're more than welcome.

### Does Informant support other file explorers like Pathfinder?
No, Informant only supports Finder. It can't detect files selected in any other application.

### Compatibility
Informant runs on macOS 11.0 or later. It is not supported on Windows or Linux.

### Privacy Policy  🔒
Informant does not collect any personal data, period.

# Acknowledgements 🧶
Thank you to everyone who has contributed to this project! As well as all the awesome open source packages this application uses! ⤵︎
- [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin) made by [sindresorhus](https://github.com/sindresorhus)
- [Sparkle](https://github.com/sparkle-project/Sparkle) made by [The Sparkle Project](https://github.com/sparkle-project)
