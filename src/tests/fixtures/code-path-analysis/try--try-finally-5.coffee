### eslint-disable ###
###expected
initial->s1_1->s1_3->s1_4->s1_5->s1_6->s1_9->s1_11;
s1_1->s1_5;
s1_3->s1_7->s1_10->s1_12;
s1_5->s1_7;
s1_6->s1_12;
s1_9->s1_12;
s1_1->s1_7->s1_12->final;
s1_11->final;
s1_12->thrown;
###
try
  try
    if a
      return
    abc()
  finally
    foo()
finally
  bar()

last()
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
thrown[label="✘",shape=circle,width=0.3,height=0.3,fixedsize];
s1_1[label="Program\nTryStatement\nBlockStatement\nTryStatement\nBlockStatement\nIfStatement\nIdentifier (a)\nIdentifier:exit (a)"];
s1_3[label="BlockStatement\nReturnStatement\nReturnStatement:exit"];
s1_4[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\nBlockStatement:exit"];
s1_5[label="ExpressionStatement\nCallExpression\nIdentifier (abc)\nIfStatement:exit\nIdentifier:exit (abc)\nCallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit"];
s1_6[label="BlockStatement\nExpressionStatement\nCallExpression\nIdentifier (foo)\nIdentifier:exit (foo)"];
s1_9[label="CallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit\nTryStatement:exit\nBlockStatement:exit"];
s1_11[label="BlockStatement\nExpressionStatement\nCallExpression\nIdentifier (bar)\nExpressionStatement\nCallExpression\nIdentifier (last)\nIdentifier:exit (bar)\nCallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit\nTryStatement:exit\nIdentifier:exit (last)\nCallExpression:exit\nExpressionStatement:exit\nProgram:exit"];
s1_7[label="BlockStatement\nExpressionStatement\nCallExpression\nIdentifier (foo)\nIdentifier:exit (foo)"];
s1_10[label="CallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit"];
s1_12[label="BlockStatement\nExpressionStatement\nCallExpression\nIdentifier (bar)\nIdentifier:exit (bar)\nCallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit"];
initial->s1_1->s1_3->s1_4->s1_5->s1_6->s1_9->s1_11;
s1_1->s1_5;
s1_3->s1_7->s1_10->s1_12;
s1_5->s1_7;
s1_6->s1_12;
s1_9->s1_12;
s1_1->s1_7->s1_12->final;
s1_11->final;
s1_12->thrown;
}
###
