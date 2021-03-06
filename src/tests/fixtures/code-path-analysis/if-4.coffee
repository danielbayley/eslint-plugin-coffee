### eslint-disable ###
###expected
initial->s1_1->s1_2->s1_3->s1_6;
s1_1->s1_4->s1_5->s1_6;
s1_2->final;
s1_4->thrown;
###
if a
  return 0
else
  throw new Error 'err'
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
thrown[label="✘",shape=circle,width=0.3,height=0.3,fixedsize];
s1_1[label="Program\nIfStatement\nIdentifier (a)\nIdentifier:exit (a)"];
s1_2[label="BlockStatement\nReturnStatement\nLiteral (0)\nLiteral:exit (0)\nReturnStatement:exit"];
s1_3[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\nBlockStatement:exit"];
s1_6[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\nIfStatement:exit\nProgram:exit"];
s1_4[label="BlockStatement\nThrowStatement\nNewExpression\nIdentifier (Error)\nLiteral (err)\nIdentifier:exit (Error)\nLiteral:exit (err)\nNewExpression:exit\nThrowStatement:exit"];
s1_5[style="rounded,dashed,filled",fillcolor="#FF9800",label="<<unreachable>>\nBlockStatement:exit"];
initial->s1_1->s1_2->s1_3->s1_6;
s1_1->s1_4->s1_5->s1_6;
s1_2->final;
s1_4->thrown;
}
###
