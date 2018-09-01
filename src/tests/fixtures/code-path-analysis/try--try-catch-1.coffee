###expected
initial->s1_1->s1_2->s1_3->s1_4;
s1_1->s1_3;
s1_2->s1_4->final;
###
try
  foo()
catch err
  bar()
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nTryStatement\nBlockStatement\nExpressionStatement\nCallExpression\nIdentifier (foo)\nIdentifier:exit (foo)"];
s1_2[label="CallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit"];
s1_3[label="CatchClause\nIdentifier (err)\nBlockStatement\nExpressionStatement\nCallExpression\nIdentifier (bar)\nIdentifier:exit (err)\nIdentifier:exit (bar)\nCallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit\nCatchClause:exit"];
s1_4[label="TryStatement:exit\nProgram:exit"];
initial->s1_1->s1_2->s1_3->s1_4;
s1_1->s1_3;
s1_2->s1_4->final;
}
###
