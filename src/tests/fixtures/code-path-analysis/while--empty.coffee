### eslint-disable ###
###expected
initial->s1_1->s1_2->s1_3->s1_2->s1_4->final;
###
while a
  ;
###DOT
digraph {
node[shape=box,style="rounded,filled",fillcolor=white];
initial[label="",shape=circle,style=filled,fillcolor=black,width=0.25,height=0.25];
final[label="",shape=doublecircle,style=filled,fillcolor=black,width=0.25,height=0.25];
s1_1[label="Program\nWhileStatement"];
s1_2[label="Identifier (a)\nIdentifier:exit (a)"];
s1_3[label="BlockStatement\nBlockStatement:exit"];
s1_4[label="WhileStatement:exit\nProgram:exit"];
initial->s1_1->s1_2->s1_3->s1_2->s1_4->final;
}
###
