# Workout-Pool

This script extracts data from a Google Hangouts chat. 
Given a time frame, the script determines how many workouts 
each person in the chat has done. The maximum counted workouts
is 3 per person. 

In order for a workout to be counted, the person will need to 
send a message that contains a fraction (ex. 1/3, 2/3, 3/3)


## How to run

1. Visit [Google Takeout](https://takeout.google.com/)
2. Only select Hangouts and create new export
3. Download compressed file to local machine and extract Hangouts JSON
4. Run this script against the JSON file within a time frame

``
 ruby ./WorkoutPoolSummary.rb <file_location> <start_time> <end_time>
`` 