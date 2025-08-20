INTERFACE NewUOAs;
IMPORT LRVector, LRScalarField;
IMPORT LongRealSeq AS LRSeq;

(*
Derivative-free minimization algorithm based on:

Zhang, Zaikun: On derivative-free optimization methods (in Chinese).
Ph.D. thesis, Chinese Academy of Sciences, Beijing, CN (2012)

Algorithm 5.18 of the thesis.

This code may not be copied, translated, or derived from without also 
being accompanied by a copy of this statement, in addition to any and all other 
copyright restrictions hereto pertaining.
*)

PROCEDURE Minimize(p              : LRVector.T;
                   func           : LRScalarField.T;
                   rhobeg, rhoend : LONGREAL;
                   ftarget     := FIRST(LONGREAL)) : Output;

  (* rhobeg is the starting step size in the p space.

     Note that the step size is the same in all dimensions, so if this
     is not appropriate for func, you should scale the input parameters.

     rhoend is the ending step size in the p space, that is, if this
     step size has been achieved, optimality is declared. 
  *)

TYPE
  Output = RECORD
    iterations : CARDINAL;
    funcCount  : CARDINAL;
    fhist      : LRSeq.T;
    message    : TEXT;
    f          : LONGREAL;   (* best value found *)
    x          : LRVector.T; (* coords of above *)
    stoprho    : LONGREAL;
  END;
  
END NewUOAs.
