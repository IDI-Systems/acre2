---
title: Gestures
---

By default, ACRE2 plays a small animation when the player uses their radios. This is known as a gesture as it only impacts certain parts of the character and doesn't prohibit movement.

To differentiate between using two types radios, by default short-range radios will play a chest touching gesture, long-range radios will play an ear touching gesture. Currently, the radio lists are as follows:
| Short Range | Long Range |
|--|--|
| ACRE_PRC343  | ACRE_PRC148  |
| ACRE_PRC77   | ACRE_PRC152  |
| ACRE_SEM52SL | ACRE_PRC117F |
|              | ACRE_SEM70   |

In a future PR we'll be adding a setter API for you to reorganise these lists or add in your own custom radios. 

There are two settings in regards to this module. You can enable/disable the module as desired.

The second setting, prevent aim down sights, aims to model a slightly more realistic environment. When this is enabled, if you're talking on the radio, you cannot aim down your sights, this is because you're using one hand to activate the radio. You can still fire one handed from this position but it's less than accurate. Is you're already aiming down your sights when you key the radio, it will take you off scope.


