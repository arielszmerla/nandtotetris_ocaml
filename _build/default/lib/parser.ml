type parser = {
  mutable file : in_channel;
  mutable has_more_line : bool;
  mutable current_line : string;
};;

type command = C_ARITHMETIC | C_PUSH | C_POP | C_LABEL | C_GOTO | C_IF | C_FUNCTION | C_RETURN | C_CALL | NOP;;
type command_arithmetic = ADD | SUB | NEG | EQ | GT | LT | AND | OR | NOT;;

let split_str p =
  String.split_on_char ' ' p.current_line;;
  
let has_more_lines p = p.has_more_line;;
let command_type p =
  match List.nth (split_str p) 0 with
  | "//" -> NOP
  | "add" -> C_ARITHMETIC
  | "sub" -> C_ARITHMETIC
  | "neg" -> C_ARITHMETIC
  | "eq" -> C_ARITHMETIC
  | "gt" -> C_ARITHMETIC
  | "lt" -> C_ARITHMETIC
  | "and" -> C_ARITHMETIC
  | "or" -> C_ARITHMETIC
  | "not" -> C_ARITHMETIC
  | "push" -> C_PUSH
  | "pop" -> C_POP
  | _ -> NOP
  ;;
  
let advance p = 
  try
    if has_more_lines p then
      p.current_line <- input_line p.file;
  with End_of_file ->
    close_in p.file;
    p.has_more_line <- false;;



let p_constructor file_path = 
  print_endline file_path ;
  let open_file = open_in file_path in
  let p = {file = open_file; has_more_line = true; current_line = ""} in
  advance p;
  p;;


let arg1 p =
  if command_type p == C_ARITHMETIC then
    (List.nth (split_str p) 0)
  else
    (List.nth (split_str p) 1);;

let arg2 p =
  int_of_string  (List.nth (split_str p) 2);;
