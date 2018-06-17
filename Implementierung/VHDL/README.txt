Seriell/Parallel-Converter in VHDL Version 1.1b 15.06.2018

GENERAL USAGE NOTES
--------------------
Zu Beginn sind alle Werte in dem sdata Vektor als undefined definiert. Beim ersten fsync Zyklus werden die Werte vom Vektor von rechts gefüllt. Ab dem zweiten Zyklus verbleiben die Werte im Vektor, jedoch sieht man dass weiterhin die Werte von rechts angepasst werden.
--------------------

Compiling and Executing under Windows 1969/2000/Windows XP/Windows 7/Windows 10
When Executing the Makefile it is required to install the following files and add them as Environmental Files in the PATH
-ghdl
-gtkwave

-------------------