### eslint-disable ###
###expected
initial->s1_1->s1_2->s1_3->s1_4;
s1_1->s1_4;
s1_2->s1_4->final;
###
switch a
  when 0
    foo()
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nSwitchStatement\nIdentifier (a)\nSwitchCase\nLiteral (0)\nIdentifier:exit (a)\nLiteral:exit (0)"];
s1_2[label="ExpressionStatement\nCallExpression\nIdentifier (foo)\nIdentifier:exit (foo)\nCallExpression:exit\nExpressionStatement:exit\nSwitchCase:exit"];
s1_3[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\n????"];
s1_4[label="SwitchStatement:exit\nProgram:exit"];
initial->s1_1->s1_2->s1_3->s1_4;
s1_1->s1_4;
s1_2->s1_4->final;
}
###
