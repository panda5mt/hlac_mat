clc;
clear all;
close all;

f = [
    1 2 3 0 1 2 3;
    0 1 2 3 0 1 2; 
    3 0 1 2 3 0 1;
    2 3 0 1 2 3 0;
    1 2 3 0 1 2 3;
    0 1 2 3 0 1 2; 
    3 0 1 2 3 0 1
    ];

g = [2 0 1;0 1 2;1 0 2];


tic
hf = conv2(f,g,'full');
hs = conv2(f,g,'same');
hv = conv2(f,g,'valid');
toc(tic);

tic
hff = my_conv2(f,g,'full');
hfs = my_conv2(f,g,'same');
hfv = my_conv2(f,g,'valid');
toc(tic)

disp('-full-');
disp(hf);
disp(hff);
disp('-same-');
disp(hs);
disp(hfs);
disp('-valid-');
disp(hv);
disp(hfv);
disp('---');

