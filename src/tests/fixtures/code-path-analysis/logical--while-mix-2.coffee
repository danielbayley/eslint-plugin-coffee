###expected
initial->s1_1->s1_2->s1_3->s1_4->s1_5->s1_2->s1_5;
s1_3->s1_6;
s1_4->s1_6->final;
###
while a or b and c
  foo()
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nWhileStatement"];
s1_2[label="LogicalExpression\nIdentifier (a)\nIdentifier:exit (a)"];
s1_3[label="LogicalExpression\nIdentifier (b)\nIdentifier:exit (b)"];
s1_4[label="Identifier (c)\nIdentifier:exit (c)\nLogicalExpression:exit\nLogicalExpression:exit"];
s1_5[label="BlockStatement\nExpressionStatement\nCallExpression\nIdentifier (foo)\nIdentifier:exit (foo)\nCallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit"];
s1_6[label="WhileStatement:exit\nProgram:exit"];
initial->s1_1->s1_2->s1_3->s1_4->s1_5->s1_2->s1_5;
s1_3->s1_6;
s1_4->s1_6->final;
}
###