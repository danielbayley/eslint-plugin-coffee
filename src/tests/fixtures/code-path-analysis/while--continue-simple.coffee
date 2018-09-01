###expected
initial->s1_1->s1_2->s1_3->s1_4->s1_2->s1_7;
s1_3->s1_6->s1_2;
s1_4->s1_5->s1_6;
s1_7->final;
###
while a
  if b
    continue
  foo()
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nWhileStatement"];
s1_2[label="Identifier (a)\nIdentifier:exit (a)"];
s1_3[label="BlockStatement\nIfStatement\nIdentifier (b)\nIdentifier:exit (b)"];
s1_4[label="BlockStatement\nContinueStatement\nContinueStatement:exit"];
s1_7[label="WhileStatement:exit\nProgram:exit"];
s1_6[label="ExpressionStatement\nCallExpression\nIdentifier (foo)\nIfStatement:exit\nIdentifier:exit (foo)\nCallExpression:exit\nExpressionStatement:exit\nBlockStatement:exit"];
s1_5[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\nBlockStatement:exit"];
initial->s1_1->s1_2->s1_3->s1_4->s1_2->s1_7;
s1_3->s1_6->s1_2;
s1_4->s1_5->s1_6;
s1_7->final;
}
###
