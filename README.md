AsknTell
========

AsknTell formerly knows as Second Opinion

I am deciding to open averything up in this repo to the public under the MIT License as is now stated in the header file of the app delegate. I have removed all of the Parse specific keys but will add instructions on how to replace them with your own keys. The code is not in the best condition, there were several things that I rushed out to meet app store requirements. That being said there should still be some good code in there so have fun! 

Steps to replace parse keys
==========

1. In the app delegate replace the parse keys that say "your keys here" with your own keys.
2. If you intend to use the cloud code that will send push notifications when a question has been answered you also have to replace the keys in the global.json file of the cloud code folder.


After replacing these two keys you should be good to go. Parse will automatically setup the tables and get you going. Enjoy!
