### eslint-disable ###
###expected
initial->s1_1->s1_2->s1_3->s1_4->s1_2;
s1_3->s1_5->final;
###
loop
  foo()
  break
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nWhileStatement"];
s1_2[label="Literal (true)\nLiteral:exit (true)"];
s1_3[label="BlockStatement\nExpressionStatement\nCallExpression\nIdentifier (foo)\nBreakStatement\nIdentifier:exit (foo)\nCallExpression:exit\nExpressionStatement:exit\nBreakStatement:exit"];
s1_4[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\nBlockStatement:exit"];
s1_5[label="WhileStatement:exit\nProgram:exit"];
initial->s1_1->s1_2->s1_3->s1_4->s1_2;
s1_3->s1_5->final;
}
###
