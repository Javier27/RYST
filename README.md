# RYST
RYST coding challenge for Overture

## Overview
Below is a demonstration of the project
![alt tag](https://raw.github.com/Javier27/RYST/master/RYSTRecording.gif)

This project took in total 6 hours to complete. 
It utilizes the RYSTAPIs which are documented here:
- [RYST APIs](https://gist.github.com/alloy-d/29cb57765ace223d6350) (APIs for storing and accessing RYST videos)

I will not go into detail with the code here, as you can see in the above gif, the app has the following structure:
Login, Intro Screens, Primary Camera Screen, Subscreens
The Primary Camera Screen contains most of the navigation for the project, from here you will navigate to the affirmation list screen as well as your previously created affirmation videos. Additionally this is the screen where you record and submit affirmations.

## Things left undone
### Code
In the code, I didn't implement NSUserDefaults in full. The basic idea of this implementation would have been to track whether the user has signed in previously; If the user has signed in previously then they would not see the intro screens, otherwise they will see the intro screens. For demonstrative purposes I left this code out, however it would take all of 5 minutes to finish the implementation if desired.

I didn't implement a sign out feature. This feature is also trivial, however due to time constraints I did not have time to redesign the user interface to allow for signing out. The code to accomplish this is also trivial and would only require that I flush the auth token and send the user back to the login screen (as a result of this basic implementation logic).

Overall I put more delegate and view code in the view controllers than I generally would. This is primarily due to time constraints and due to the limited project requirements some of the modularization and reusability concerns were not worth the effort.

### Design
I tried to design as much as I could and add fonts, colors, create icons, etc to make the app feel fun and like more than just an interview coding project but inevitably I left the affirmation and video table view controllers looking bland.

Hope you enjoyed the project, I know I had a blast making it!
