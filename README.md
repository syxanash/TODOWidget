# TODOWidget
a TODO widget for GeekTool which interacts with Apple Reminder app.

## Install

First create a new list in Reminder app called **TODO**. Alternatively replace the value of the variable `$LIST_NAME` with your custom list name which already exists in your app.

Then you need to install [reminders-cli](https://github.com/keith/reminders-cli) and also download [GeekTool](https://www.tynsoe.org/v2/geektool/), I know it's an old and abandoned project but it still does its job.

Create a new **Shell** widget using GeekTool and copy the script in `bin/` directory, inside **Command** field as shown below:

![screen](media/screen1.png)

You can then set the refresh, timeout, font and all those things.

## Demo

![demo](media/demo.gif)
