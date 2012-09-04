test-as3-workers
================

This project has been originally built with FDT 5.6.2, following Lee Brimelow's tutorials (http://www.gotoandlearn.com/play.php?id=162, http://www.gotoandlearn.com/play.php?id=163).

It didn't seem to work at first, so I asked a question on StackOverflow: http://stackoverflow.com/questions/12167182/issue-with-basic-as3-workers-classes

With the answers obtained there, I ended up asking questions to Lee Brimelow on Twitter, which lead me to find that while WorkerDomain.isSupported returned true under FB 4.7, WorkerDomain.isSupported would return false under FDT 5.6.2.

I have filed a bug report with FDT (http://bugs.powerflasher.com/jira/browse/FDT-2907), and will update this code as this situation develops.