### eslint-disable ###
###expected
initial->s1_1->s1_2->s1_3->s1_5->s1_7->s1_8->s1_10->s1_11->s1_13->s1_14;
s1_1->s1_4->s1_5;
s1_2->s1_14;
s1_7->s1_14;
s1_10->s1_14;
s1_4->s1_6->s1_7;
s1_6->s1_9->s1_10;
s1_9->s1_12->s1_13;
s1_14->final;
###
switch a
  when 0
    foo()
  when 1, 2
    bar()
  when 3
    hoge()
  else
    fuga()
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nSwitchStatement\nIdentifier (a)\nSwitchCase\nLiteral (0)\nIdentifier:exit (a)\nLiteral:exit (0)"];
s1_2[label="ExpressionStatement\nCallExpression\nIdentifier (foo)\nIdentifier:exit (foo)\nCallExpression:exit\nExpressionStatement:exit\nSwitchCase:exit"];
s1_3[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\n????"];
s1_5[label="SwitchCase:exit"];
s1_7[label="ExpressionStatement\nCallExpression\nIdentifier (bar)\nIdentifier:exit (bar)\nCallExpression:exit\nExpressionStatement:exit\nSwitchCase:exit"];
s1_8[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\n????"];
s1_10[label="ExpressionStatement\nCallExpression\nIdentifier (hoge)\nIdentifier:exit (hoge)\nCallExpression:exit\nExpressionStatement:exit\nSwitchCase:exit"];
s1_11[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\n????"];
s1_13[label="ExpressionStatement\nCallExpression\nIdentifier (fuga)\nIdentifier:exit (fuga)\nCallExpression:exit\nExpressionStatement:exit\nSwitchCase:exit"];
s1_14[label="SwitchStatement:exit\nProgram:exit"];
s1_4[label="SwitchCase\nLiteral (1)\nLiteral:exit (1)"];
s1_6[label="SwitchCase\nLiteral (2)\nLiteral:exit (2)"];
s1_9[label="SwitchCase\nLiteral (3)\nLiteral:exit (3)"];
s1_12[label="SwitchCase"];
initial->s1_1->s1_2->s1_3->s1_5->s1_7->s1_8->s1_10->s1_11->s1_13->s1_14;
s1_1->s1_4->s1_5;
s1_2->s1_14;
s1_7->s1_14;
s1_10->s1_14;
s1_4->s1_6->s1_7;
s1_6->s1_9->s1_10;
s1_9->s1_12->s1_13;
s1_14->final;
}
###
