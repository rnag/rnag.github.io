---
excerpt: "How I automated turning off Wi-Fi and Bluetooth on my Apple devices at night to reduce distractions and improve sleep quality — step by step."
title: "Sleep Mode: Automating Wi-Fi & Bluetooth Off at Night on Apple Devices"
date: "2025-05-22 00:26:24 -0400"
categories:
  - tech-tips
tags:  # up to 5, compatible with https://medium.com/explore-topics
  - sleep
  - automation
  - apple
  - health
  - productivity
dev_to:
  id: 2513211
  tags:  # up to 4, compatible with https://dev.to/tags
    - apple
    - automation
    - productivity
    - health
---

{% include tech-tips-head-notice.html %}

As a runner and fitness enthusiast, sleep is essential for my recovery — and yet, it’s something I’m constantly working to improve. I aim for 8 hours a night, but my Apple Watch reports an average closer to 6.5 hours over the past few months, with some nights dipping as low as 5. Being a light sleeper doesn’t help either. I’ve experimented with wax earplugs to block out noise and blackout curtains to keep light at bay.

One thing I’ve wanted to automate for a while now is disabling Wi-Fi and Bluetooth on the devices near my bed — including both my personal and work MacBooks, my iPhone, and ideally even my Apple Watch (which I wear to track sleep). These devices all stay in my bedroom overnight, so minimizing potential sleep disruptors has become a personal experiment.

You might ask: why go through the trouble of shutting off Wi-Fi and Bluetooth automatically? It’s a fair question. [This study](https://sleepreviewmag.com/sleep-health/parameters/quality/study-raises-concerns-wi-fi-device-radiation-sleep-quality/) raises concerns that Wi-Fi radiation may impact sleep quality and increase the risk of insomnia. And this [video explanation](https://neurologicwellnessinstitute.com/can-wifi-affect-sleep-quality/) discusses the potential relationship between wireless radiation and disrupted sleep. While scientific research on the topic is still largely inconclusive, I figured that if there's even a slight chance of improving sleep quality by reducing exposure, it's worth exploring.

So for the past several months, I’ve had an automation in place that turns off Wi-Fi and Bluetooth on my Apple devices around bedtime — and in this post, I’ll share how I set that up in case you’re looking to try something similar.

## Creating the Shortcuts

The first step involves opening the Shortcuts app on a Mac laptop or device. The easiest way is to hit `Cmd + Space` and search for `Shortcuts`. 

The icon should look like this:

<img src="https://help.apple.com/assets/6712D663A5C9C17B38070C34/6712D668A5C9C17B38070C3A/en_US/d230a25cb974f8908871af04caad89a1.png" width="30%">

I’ve created two shortcuts. One called “**Start Morning**” to enable Wi-Fi/Bluetooth, and another called “**Night Time**” to disable Wi-Fi/Bluetooth and put the display to sleep, as shown below. They both use the “_Set Wi-Fi_” and “_Set Bluetooth_” actions, which you can find using the Action Library on the right. 

![Start Morning](/assets/images/1_Shortcuts-StartMorning.png)

![Night Time](/assets/images/2_Shortcuts-NightTime.png)

## Creating Automator Scripts

Next, I opened up the **Automator** app — the `Cmd + Space` works here too — and go to _File \> New_ to create a new automation. I need to do this twice, once for each action.

Search for the “**Run Shell Script**”  action. Then in the settings, select **/bin/bash** as the Shell, and enter this code in the bash code block:

	shortcuts run "Start Morning"

Here, `"Start Morning"` is the name of your first shortcut. If you named it something else, update the name here accordingly. The executable command `shortcuts` can also be run from the Mac Terminal app, and is simply a handy, automated way to interact with your shortcuts on the Shortcuts app. 

Here’s a screenshot of this — you can name this `StartMorning.app` and save it to your `/Applications` folder, but here you can see I’ve saved it to under my `iCloud Drive > Automator` , for an important reason I’ll cover later:

![](/assets/images/3_Automator-StartMorning.png){: width="200%"}

Lastly, go to *File \> New* again and search for the “**Run Shell Script**”  action. Then in the settings, select **/bin/bash** as the Shell as last time, and enter this code in the bash code block:

	shortcuts run "Night Time"

Replacing `"Night Time"` if you chose to use a different name for the shortcut. I’ve again saved this to my iCloud Drive, as shown below:

![](/assets/images/4_Automator-NightTime.png){: width="200%"}

Now, there’s a few way to schedule these two automations on a Mac. You can either set up a cron job or, in my case, I chose to use the Calendar app. I got all these steps from an article a long time ago, but now for the life of me I can’t seem to find that article — I guess that’s one reason to bookmark an interesting site that you come across.

## Scheduling with Calendar

Regardless, the next step is to open the **Calendar** app on your Mac.

Now, remember how I saved the Automator scripts to iCloud Drive, inside an “Automator” folder? There’s a reason for that. If you’re using just one Mac — say, a personal laptop — saving the scripts to `/Applications` works fine. But in my case, I use both a *MacBook Air* (personal) and a *MacBook Pro* (work). I wanted the Wi-Fi and Bluetooth toggling to sync across both devices.

After some trial and error, I found that Calendar events sync automatically across Apple devices — but local file paths like `/Applications` do not. So, if the script lives in `/Applications` on one Mac, the synced calendar event on the second Mac will break. By storing the script in iCloud Drive, both Macs can access the same path, and I only have to set up the Calendar automation once (in theory, at least).

First thing I did was hit the **+** button at the top to create a new Calendar event. I called the first one “**Start Morning**”, set it to **repeat daily** at **8:00 AM**, and the important bit here is to expand the event, click on “Add Alert, Repeat, or Travel Time”, and then to go to where you see `alert: None`, click the dropdown, and go to `Custom...`, choose `Open File` and then in the second dropdown choose `Other...` . In the Finder window, locate and select the file location for the Automator script `StartMorning.app`  that you saved in previous step. Next, though technically not needed, I clicked the dropdown to alert **15 Minutes before** and changed it to **At time of event**.

You can see the event which turns on Wi-Fi/Bluetooth here:

![Start Morning Calendar Event](/assets/images/5_Calendar-StartMorning.png){: width="50%"}

Lastly, do the same for the “**Night Time**” event! I set it to **repeat daily** at **11:00 PM** based on my sleep schedule, but feel free to adjust accordingly based on yours! I followed the same steps as above. I chose `Open File` and then in the second dropdown choose `Other...` . In the Finder window, locate and select the file location for the Automator script `NightTime.app`  that you saved in previous step. 

You can see the final event which switches off Wi-Fi/Bluetooth here:

![Night Time Calendar Event](/assets/images/6_Calendar-NightTime.png){: width="50%"}

And that’s it! All my Mac devices will effectively go into Airplane Mode at my sleep time at 11 PM, and wake up from Airplane Mode at 8 AM the next day automatically. Problem solved!

## Scheduling on iPhone 

Is it possible to schedule the same on an iPhone?

You betcha! It’s actually a bit easier, since you only have to set Airplane Mode, rather than Wi-Fi and Bluetooth individually.

I opened the “**Shortcuts**” app on my iPhone. I created my first automation, which runs on a schedule — at **11:00 PM, daily** in my case — and the action I chose is **Set Airplane Mode \> ON**. This is shown below:

![](/assets/images/7_iPhone_Shortcuts.jpeg){: width="50%"}

Lastly, rather than turn on my iPhone in the morning at a specific time, I chose to create an automation with a trigger that runs when my phone is disconnected from power — since I wirelessly charge it overnight — and the action I chose is **Set Airplane Mode \> OFF**. This is shown below:

![](/assets/images/8_iPhone_Shortcuts.jpeg){: width="50%"}

## Scheduling on Apple Watch

The final piece of the puzzle is my Apple Watch. Since I wear it every night to track sleep, I’d hoped to schedule Wi-Fi shutoff there as well. Unfortunately, even with the Shortcuts app, there doesn’t seem to be a way to automate Wi-Fi toggling on the Watch. For now, I’ve resorted to doing it manually: unlock the Watch, press the side button, and tap the blue Wi-Fi icon. Not ideal, but a small inconvenience — especially since everything else is automated.

Whether or not Wi-Fi exposure truly impacts sleep quality remains an open question. But for me, this setup offers peace of mind. And that, in itself, helps me sleep better.

Hope this was helpful — and if you end up building something similar, I’d love to hear how it goes.

Thanks for reading.

