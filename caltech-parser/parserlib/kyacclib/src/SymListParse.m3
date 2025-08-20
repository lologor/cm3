(* Copyright (c) 2000 California Institute of Technology *)
(* All rights reserved. See the file COPYRIGHT for a full description. *)
(* $Id: SymListParse.m3,v 1.2 2001/07/29 21:58:03 kp Exp $ *)

MODULE SymListParse;
IMPORT FileRdErr;
IMPORT Rd, SymList;
IMPORT CharRange;
IMPORT CharCodes;
IMPORT Thread;
IMPORT Sym;
IMPORT Debug, Text;
FROM Fmt IMPORT Int, F;
(* IMPORT Text;
   IMPORT Term; *)
<*FATAL Rd.Failure, Thread.Alerted*>

VAR
  doDebug := Debug.DebugThis("SYMLISTPARSE");

PROCEDURE BackGetName(rd: Rd.T): TEXT =
  VAR
    name := "";
  BEGIN      
    Rd.UnGetChar(rd);
    TRY
      WHILE Rd.GetChar(rd) IN CharRange.AlphaNum DO
        Rd.UnGetChar(rd);
        name := name & Rd.GetText(rd, 1);
(* Rd.UnGetChar(rd);Term.WrLn("append char: " & Rd.GetText(rd,1)); *)
      END;
      Rd.UnGetChar(rd);
    EXCEPT
      Rd.EndOfFile =>
    END;
    RETURN name;
  END BackGetName;

PROCEDURE Parse(rd: Rd.T;
                allowedChars: CharRange.T): SymList.T =
  VAR
    sym: Sym.T;
    syms: SymList.T;
    c, cc: CHAR;
  BEGIN
    IF doDebug THEN Debug.Out("SymListParse.Parse") END;
    TRY
      WHILE TRUE DO
        IF doDebug THEN Debug.Out("SymListParse next item") END;
        WHILE Rd.GetChar(rd) IN CharRange.WhiteSpace DO
          IF doDebug THEN Debug.Out("SymListParse skip blank") END;
        END;
        Rd.UnGetChar(rd);
        IF doDebug THEN Debug.Out("SymListParse UnGetChar") END;
        cc := Rd.GetChar(rd);
        IF doDebug THEN Debug.Out(F("SymListParse GetChar %s %s",
                                    Int(ORD(cc)), Text.FromChar(cc))) END;

        CASE cc OF
        | '\047' =>
          c := CharCodes.GetChar(rd);
          IF NOT c IN allowedChars THEN
            FileRdErr.E(rd, "Not declared %char: " & CharCodes.QC(c));
          END;
          sym := Sym.FromChar(c);
          EVAL Rd.GetChar(rd);
        | '\n' =>
(*          Term.WrLn("EOL"); *)
          RAISE Rd.EndOfFile;
        ELSE
(*          Rd.UnGetChar(rd);Term.WrLn("tested char: " & Rd.GetText(rd,1)); *)
          sym := Sym.FromText(BackGetName(rd));
(*          IF Text.Equal(Sym.GetName(sym), "") THEN
            Rd.UnGetChar(rd);
            Term.WrLn("Got: " & Rd.GetText(rd,1)); 
          END; *)
        END;
        syms := SymList.Cons(sym, syms);
      END;
    EXCEPT
      Rd.EndOfFile =>
    END;
    RETURN SymList.ReverseD(syms);
  END Parse;

BEGIN
END SymListParse.
