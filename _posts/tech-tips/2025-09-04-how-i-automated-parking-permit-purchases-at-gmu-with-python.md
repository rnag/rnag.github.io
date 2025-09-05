---
excerpt: >
  A Python + Selenium tool to automate GMU daily parking permits. It’s open source, semi-automated with Duo Mobile 2FA, and saves me from last-minute stress.
title: "How I Automated Parking Permit Purchases at GMU with Python"
date: "2025-09-04 23:04:34 -0400"
categories:
  - tech-tips
tags:  # up to 5, compatible with https://medium.com/explore-topics
  - python
  - automation
  - selenium
  - productivity
  - student-life
dev_to:
  id: 2820956
  tags:  # up to 4, compatible with https://dev.to/tags
    - python
    - automation
    - selenium
    - productivity
---

{% include tech-tips-head-notice.html %}

As a grad student at **George Mason University (GMU)**, I commute to Fairfax once a week for evening classes. Like many commuters, I need parking — but only for a few hours, usually **4–7 PM**.

Buying a semester-long permit didn’t make sense for my schedule (or wallet). Instead, the **daily parking permits** turned out to be cheaper and more flexible.

The problem? I always procrastinated. I’d remember to buy a permit at the last minute, sometimes right before class. It was stressful, repetitive, and just annoying.

So, being a CS student, I did what came naturally:

👉 **I automated the entire process.**

## The Idea

Every week, I needed to:

1. Go to the GMU parking portal.
2. Log in with my credentials.
3. Navigate through a bunch of menus.
4. Select the right permit.
5. Enter payment details.

It was the same steps every time. Why not let Python handle it?

## The Tool

I built a small open-source tool in Python that:

* Automates login to the GMU parking portal up to the **Duo Mobile 2FA step** (which still requires approval on your phone).
* Selects the correct **daily parking permit**.
* Completes the checkout flow.
* Emails me a confirmation when done.

That’s it — no more last-minute scrambling.

📽️ **Demo Video:** [YouTube](https://youtu.be/9X5lc2zZq-k)

💻 **Source Code:** [GitHub – GMU Daily Permit Automation](https://github.com/rnag/GMU-Daily-Permit-Automation)

## Tech Breakdown

At its core, this project uses:

* **[Selenium](https://www.selenium.dev/)** – to control a browser and interact with the GMU parking site.
* **Headless mode** – so it runs quietly in the background.
* **Config + Environment variables** – to keep credentials and payment info safe.
* **Task scheduling (optional)** – you *could* use `cron` (Linux/Mac) or Task Scheduler (Windows) to kick off the script automatically. I usually just run it manually before class.
* **Duo Mobile 2FA** – you’ll still need to approve the login from your phone. The script pauses at this step until Duo is confirmed.

Here’s a simplified example of what the login step looks like in Python with Selenium:

```python
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

# Start the browser (headless mode can be enabled too)
driver = webdriver.Chrome()

# Go to GMU parking login page
driver.get("https://gmu.t2hosted.com/Account/Portal")

# Enter username
username_input = driver.find_element(By.ID, "username")
username_input.send_keys("myusername")

# Enter password
password_input = driver.find_element(By.ID, "password")
password_input.send_keys("mypassword")
password_input.send_keys(Keys.RETURN)

# (From here, the script navigates menus and purchases the permit)
```

The real project handles edge cases, payment, and confirmation, but this snippet shows the basic automation flow.

## Lessons Learned

A few interesting takeaways while building this:

* University systems often don’t have APIs, so **web automation** is sometimes the only option.
* **Security matters** – never hardcode sensitive info; use config files or environment variables.
* Even small automations can save you from recurring stress (and are great coding practice).

## Try It Yourself

If you’re at GMU (or curious about automation), you can try it out:

👉 [GitHub Project](https://github.com/rnag/GMU-Daily-Permit-Automation)

The `README` has setup instructions. Just remember: **use responsibly** — the tool isn’t affiliated with GMU Parking Services, and you should only automate your own account.

## Final Thoughts

This project started as a way to save myself from procrastination, but it turned into a fun automation experiment. It’s one of those small quality-of-life improvements that adds up.

If you’re a fellow GMU commuter, hopefully this helps you too. And if you’re a developer, maybe it’ll inspire you to automate some of your own daily annoyances.

While Duo Mobile means this isn’t 100% hands-free, it still saves me from repeating the same web clicks every week.
