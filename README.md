# InAccessibility
A SwiftUI app that's not very accessible... On purpose

This app is part of the [Accessibility](https://www.swiftuiseries.com/accessibility) event during the SwiftUI Series. This project has been made inaccessible and non-inclusive on purpose. Can you fix the 20+ areas that can be improved?

-----

## Improvements made
I had a lot of fun working on this project! It provided a great chance to use some accessibility modifiers and environment variables that I had come across in the past, and to discover and try out some new ones that I hadn't used before. In general, I tried to minimize visual changes to the app or significant UI changes, instead trying to make the existing app as it was more accessible. The changes mentioned below don't cover everything I did, but hit on a lot of the big points. Out of respect for your time and you probably not wanting to read through all that text, I'll bold some key points 😉.

While I'm sure there are some additional improvements that could be made, or things I could do slightly better, I tested the app with VoiceOver, Voice Control, Switch Control, and Full Keyboard Access, along with various different accessibility settings, and was able to use and navigate things much more easily!

### Dynamic type
First, I made sure all text fields used semantic font sizes so they would support **dynamic type**. I changed all icons to use **SFSymbols** with font sizes applied so they also scale with dynamic type. I was unsure why the dots in the graph would grow and shrink when tapped, so **I instead changed the graph to use big circles when the user has either bold text or an accessibility dynamic type size enabled**. Finally, I **updated the layouts for the stock cells and the detail page to shift the graph (and price, for the stock cell) to be below the stock name instead of to the right of it for accessibility sizes of dynamic text**. This change also involved embedding the detail page in a scroll view content does not get cut off.

### Color contrast
There were lots of color contrast issues to address, some of which I could notice initially and some of which the Accessibility Inspector's audit feature helped catch. **I added a few custom colors (grays, blues, reds, and greens) that had at least a 4.5:1 contrast ratio with both white and black**, even in cases of bold text where WCAG AA guidelines would only require 3.0:1 ratios. I checked the new reds and greens I added with deuteranopia and grayscale filters and they seemed to have better contrast with one another, but **I also made sure that stock price changes were always preceded by either a "+" or "-"** to more clearly differentiate the two without relying solely on color. In a nod to the fact that these colors do carry meaning though, I **excluded them from smart invert** so they would stay the same color when that setting is on.

The yellow colors posed a bit of a problem with white text and backgrounds. Had I been doing a more in-depth redesign of the app, I would probably changed it to a "bookmark" or something like that where another color might have made more sense, but since yellow and stars seem to go together, I decided to change the text on the yellow button color to be black, and added a thin black outline to the stars in stock cells in light mode to improve contrast with the white background.

When testing with settings like increased contrast and invert colors in both light and dark modes, I found some cases in which the yellow or blue got lighter or darker and the text on those buttons no longer had sufficient contrast, so I updated logic for text color in those scenarios to ensure greater contrast.

### Buttons
There were two main problems with buttons in the sample code: tap target size and missing button traits. Fixing the missing button traits was a simple matter of adding the trait (or converting things to be SwiftUI `Button`s). I spaced out the stock cell layout a bit to ensure that the info icon would always have a **minimum size of 44x44**, and similarly ensured the minimum tap target size for the settings icon, "Tap for more" button, and new "X" icon I added on the detail page.

Since buttons that have no effect can be disorienting for VoiceOver users, I had the settings and "Tap for more" button show a simple alert in lieu of the actual functionality they would have in a full app. I also **updated the text of the "Tap for more" button to be "Show more"**, deliberately not using words like "tap" or "view", which might not be as inclusive of the ways in which some users interact with the app.

On the details page, I **added a close button**. While some users could swipe down to dismiss and others could use the escape gesture to get back to the main page, adding the button ensures that there is always a way to get out of the detail screen for Voice Control users, or even just people who have their phone in the landscape orientation.

### Grouping of elements
For faster navigation with assistive technologies on the main view in the app, I **grouped each cell into a single element** that reads the stock name, the symbol (**spelled out with `.speechSpellsOutCharacters()`**, which was a new discovery for me!), if it is a favorited stock, and the price/price change (**formatted as currency instead of just `Double`s**). I addded an **accessibility action for the "more info"** button's functionality, though I'm not totally sure if there's a way for Voice Control users to trigger accessibility actions so the VC grid might be the only way to activate that. I had to **set a custom `.accessibilityActivationPoint`** to ensure that activations from AT would go to the cell rather than the info icon. I added **custom input labels** for Voice Control users to more easily say which cell to tap, and updated the sample data so there weren't duplicate companies so VC would not require disambiguation between cells with the same name. Because there was an image that seemed to have text (the "i" in the info icon), VoiceOver would read an auto-generated image description, so I removed the image trait from that icon to avoid that.

### Stock graph
The stock graph that's shown already just shows the same data points for all stocks so it doesn't give much information to sighted users either, but in the starter code it wasn't an accessibility element at all, and a real app with real data would provide some context, so I also worked on making that accessible with VoiceOver. I acted like each data point represented one day of data, and **added audio graph support**. 

I also tried out an interesting approach to making the graph accessible for VoiceOver users aside from audio graphs by allowing navigation of individual data points. I didn't want to clutter things up too much and require too many swipes though, so I **added an `.accessibilityAdjustableAction` to the graph where a swipe up or down will change the selected data point that is read as the `.accessibilityValue` for the graph**. I'm not sure I'm in love with this solution and it doesn't work that well for Switch Control users who see increment/decrement options, but it was fun to try out a new way of navigating graphs with VoiceOver!

The animations that were going on with the graph every time it appears also seemed like a bit much, so I **made sure to not apply those animations when the reduced motion preference was enabled**.
