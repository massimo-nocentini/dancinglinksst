# dancinglinksst

A vanilla Smalltalk implementation of the **Dancing Links** technique introduced by Donald Knuth in its former article https://arxiv.org/abs/cs/0011047, it provides:
- the original ideas together with *at most once* constraints;
- the extension that uses *Zero-suppressed Binary Decision Diagrams (ZDD)* shown in https://aaai.org/ocs/index.php/AAAI/AAAI17/paper/view/14907;
- visualizations using the Roassal2 framework;
- test cases about N-Queens and Sudoku problems.

The code can be readily imported into Pharo images by Iceberg. 

Enjoy :)

Some figures are in order:
- the ZDD for the **8-Queens** problem, from which it is possible to recover the **92** fundamental solutions (also enumerated and known as [A002562](https://oeis.org/A002562) in the OEIS):
![8 Queens ZDD](https://github.com/massimo-nocentini/dancinglinksst/blob/master/8Queens-ZDD.svg)
