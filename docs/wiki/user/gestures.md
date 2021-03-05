---
title: Gestures
---
{% include important.html content="Dev-build only" %}

{% include important.html content="Requires ACE3 Common!" %}

By default, ACRE2 plays a small animation when the player uses their radios. This is known as a gesture as it only impacts certain parts of the character and doesn't prohibit movement.

To differentiate between using two types of radios, by default some radios will play a chest touching gesture, others will play an ear touching gesture. Currently, the radio lists are as follows:

| Chest | Ear |
|--|--|
| ACRE_PRC343  | ACRE_PRC148  |
| ACRE_PRC77   | ACRE_PRC152  |
| ACRE_SEM52SL | ACRE_PRC117F |
|              | ACRE_SEM70   |

There are two settings in regards to this component. You can enable/disable the overall functionality as well as prevent aim down sights.

Goal of preventing aiming down sights is to model a slightly more realistic environment. When this is enabled, if you're talking on the radio, you cannot aim down your sights, this is because you're using one hand to activate the radio. You can still fire one handed from this position but it's less than accurate. Is you're already aiming down your sights when you key the radio, you will stop aiming down sights.
