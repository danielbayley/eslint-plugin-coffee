### eslint-disable ###
###expected
initial->s1_1->s1_3->s1_2->s1_4->s1_2;
s1_3->s1_6;
s1_4->s1_5->s1_2;
s1_4->s1_6;
s1_5->s1_6->final;
###
for x in list
  foo()
  continue
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nFor"];
s1_3[label="Identifier (list)\nIdentifier:exit (list)"];
s1_2[label="Identifier (x)\nIdentifier:exit (x)"];
s1_4[label="BlockStatement\nExpressionStatement\nCallExpression\nIdentifier (foo)\nContinueStatement\nIdentifier:exit (foo)\nCallExpression:exit\nExpressionStatement:exit\nContinueStatement:exit"];
s1_6[label="For:exit\nProgram:exit"];
s1_5[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\nBlockStatement:exit"];
initial->s1_1->s1_3->s1_2->s1_4->s1_2;
s1_3->s1_6;
s1_4->s1_5->s1_2;
s1_4->s1_6;
s1_5->s1_6->final;
}
###
