### eslint-disable ###
###expected
initial->s1_1->s1_3->s1_2->s1_4->s1_2;
s1_3->s1_5;
s1_4->s1_5->final;
###
foo() for x in list by -1
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nFor"];
s1_3[label="Identifier (list)\nIdentifier:exit (list)"];
s1_2[label="Identifier (x)\nUnaryExpression\nLiteral (1)\nIdentifier:exit (x)\nLiteral:exit (1)\nUnaryExpression:exit"];
s1_4[label="CallExpression\nIdentifier (foo)\nIdentifier:exit (foo)\nCallExpression:exit"];
s1_5[label="For:exit\nProgram:exit"];
initial->s1_1->s1_3->s1_2->s1_4->s1_2;
s1_3->s1_5;
s1_4->s1_5->final;
}
###
