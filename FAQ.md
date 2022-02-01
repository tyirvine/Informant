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

After authorizing, you may need to quit Informant and re-open it.

### Is Informant localized?
Yes! However, it uses Microsoft Azure for translations so they may not be 100% accurate. If you've found a translation that you think is incorrect, please [submit feedback](https://github.com/tyirvine/Informant/issues/new/choose).

### Does Informant support other file explorers like Pathfinder or ForkLift?
No, Informant only works with Finder. It can't detect files selected in any other application. This is because Informant depends on an API to communicate with Finder in order to work.

### Compatibility
Informant runs on macOS `Big Sur 11.0` or later. It is not supported for Windows or Linux.

### Privacy Policy 🔒
Informant does not collect any personal data, period. It saves your preferences locally to your machine, and makes no network requests besides key verification.
