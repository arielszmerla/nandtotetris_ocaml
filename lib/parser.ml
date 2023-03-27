(*Reuven chiche 328944517*)
(*Ariel Szmerla 339623324*)


(* object containing main features for reading from the .vm file*)
type parser = {
  mutable file : in_channel;
  mutable has_more_line : bool;
  mutable current_line : string;
};;


(*ctor*)
let p_constructor file_path = 
  let open_file = open_in file_path in
  let p = {file = open_file; has_more_line = true; current_line = ""} in
  advance p;
  p;;
    
(*commands we have to deal with*)
type command = C_ARITHMETIC | C_PUSH | C_POP | C_LABEL | C_GOTO | C_IF | C_FUNCTION | C_RETURN | C_CALL | PASS;;
type command_arithmetic = ADD | SUB | NEG | EQ | GT | LT | AND | OR | NOT;;

let split_str p =
  String.split_on_char ' ' p.current_line;;

(*function that checks whther eof input file  *)
let has_more_lines p = p.has_more_line;;
let command_type p =
  try
  match List.nth (split_str p) 0 with
  | "add" | "sub" | "neg" | "eq" | "gt" | "lt" | "and" | "or" | "not" -> C_ARITHMETIC
  | "push" -> C_PUSH
  | "pop" -> C_POP
  | _ -> failwith "this operation is not supported"
  with 
  | Failure _ -> PASS
  ;;
  

(*get next line of input file if exists*)  
let advance p = 
  try
    if has_more_lines p then
      p.current_line <- input_line p.file;
  with End_of_file ->
    close_in p.file;
    p.has_more_line <- false;;


(*get first argument*)
let arg1 p =
  if command_type p == C_ARITHMETIC then
    (List.nth (split_str p) 0)
  else
    (List.nth (split_str p) 1);;
    
(*get second argument*)
let arg2 p =
  int_of_string  (List.nth (split_str p) 2);;
