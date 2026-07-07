`timescale 1ns/100ps
`define DATA_WIDTH 8
`define DATA_DEPTH 32
`define num_transactions 500
`define ADDRESS_WIDTH 5
/*
function integer log2;
 input integer n;
 begin
 log2 = 0;
 while(2**log2 < n)
 begin
 log2=log2+1;
 end
 end
endfunction
parameter ADDRESS_WIDTH = log2(`DATA_DEPTH);
*/
