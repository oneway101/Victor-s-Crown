# Victor's Crown

Victor's Crown is a goal driven devotional app.
Like a runner running the race till the finish line to attain the crown of victory, 
It keeps the track of all your saved reading and prayer time data of your set goal.


## Profile
Profile tab shows how many days are left till the end date and simultaneously updates to show the reading and prayer time progress in percentage number format.
`Current goal `button displays the list of days from start to the end date with saved reading and time records in each day.
`History` button shows all previously saved reading and prayer time records. 


## Bible
Bible tab uses Bibles.org API to display King James Version of the Bible. `Books` in navigation bar shows the entire book list.
Selecting the book name displays the corresponding number of chapters.
Selecting the chapter number displays the scripture with verses in each table cell.
Clicking the title of Book and Chapter number in the navigation bar brings up the modal view of currently selected Book’s chapters to easily navigate into different chapters.
“Record on Timeline” button appears in the end of the scripture view which saves the selected book and the chapter number with today’s date in Core Data.

## Pray
Pressing the `Start` button activates the timer. `Reset` button sets the timer back to zero. `Done` button stops the timer and enables the `Record Prayer Time` button which saves the timecode with today’s date in Core Data. If today’s record already exists then it will add the time to the previously saved prayer time.

## Settings 
Download bible to read offline is currently disabled.
You can set a new goal with total number of chapters and total prayer time of Goal term (number of days).
`Save Setting` buttons saves the changed values in settings tab view. Otherwise it will not be reflected on the profile tab view.
