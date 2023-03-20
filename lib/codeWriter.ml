type codeWriter = {
  mutable file : out_channel;
  mutable filename : string;
};;




let pointer_type p =
  match p with
  | "local" -> "LCL"
  | "argument" -> "ARG"
  | "constant" -> "CONST"
  | "static" -> "STATIC"
  | "temp" -> "TEMP"
  | "pointer" -> "POINTER"
  | "this" -> "THIS"
  | "that" -> "THAT"
  | _ -> failwith  "this method is not for the command type"
  ;;
  
let static_val filename arg_2 = 
 let my_str = String.split_on_char '\\' filename in
 let len = List.length my_str  - 1 in
 let myfile = List.nth my_str len in
 print_endline myfile;
 myfile ^ "." ^ string_of_int arg_2;;

let pop arg_1 arg_2 c =
  match (pointer_type arg_1) with
   "LCL" | "THIS" | "THAT" | "ARG" ->
    "@" ^ string_of_int arg_2 ^  
    "\nD=M " ^
    "\n@"  ^ pointer_type arg_1 ^
    "\nD=D+A " ^
    "\n@R13 " ^
    "\nM=D " ^
    "\n@SP " ^
    "\nAM=M-1 " ^
    "\nD=M " ^
    "\n@R13 " ^
    "\nA=M " ^
    "\nM=D\n" 
  |"TEMP" -> 
    "@R5 " ^
    "\nD=M " ^
    "\n@"  ^  string_of_int ( arg_2 + 5) ^
    "\nD=D+A " ^
    "\n@R13 " ^
    "\nM=D " ^
    "\n@SP " ^
    "\nAM=M-1 " ^
    "\nD=M " ^
    "\n@R13 " ^
    "\nA=M " ^
    "\nM=D\n" 
  | "STATIC" ->
    "\n@" ^  static_val c.filename arg_2 ^
    "\nD=D+A " ^
    "\n@R13 " ^
    "\nM=D " ^
    "\n@SP " ^
    "\nAM=M-1 " ^
    "\nD=M " ^
    "\n@R13 " ^
    "\nA=M " ^
    "\nM=D\n"
  | "POINTER" ->
    let symbol =
      match arg_2 with
      | 0 -> "THIS"
      | 1 -> "THAT"
      | _ -> failwith  "this method is not for the command type"
      in
      "@" ^ symbol ^
      "\nD=A " ^
      "\n@R13 " ^
      "\nM=D " ^
      "\n@SP " ^
      "\nAM=M-1 " ^
      "\nD=M " ^
      "\n@R13 " ^
      "\nA=M " ^
      "\nM=D\n"
  | _ -> failwith  "this method is not for the command type"
  ;;

let push arg_1 arg_2 =
  match (pointer_type arg_1) with
  | "CONST" -> 
    "@" ^ string_of_int arg_2 ^
    "\nD=A" ^
    "\n@SP" ^
    "\nA=M" ^
    "\nM=D" ^
    "\n@SP" ^
    "\nM=M+1\n"
  | "LCL" | "THIS" | "THAT" | "ARG" |"TEMP" ->
    "@" ^ string_of_int arg_2 ^
    "\nD=A" ^
    "\n@" ^ pointer_type arg_1 ^
    "\nA=M+D" ^
    "\nD=M" ^
    "\n@SP" ^
    "\nA=M" ^
    "\nM=D" ^
    "\n@SP" ^
    "\nM=M+1\n"
  | "STATIC" ->
    "@" ^ string_of_int arg_2 ^
    "\nD=M" ^
    "\n@SP" ^
    "\nA=M" ^
    "\nM=D" ^
    "\n@SP" ^
    "\nM=M+1\n"
  | "POINTER" ->
    let symbol =
      match arg_2 with
      | 0 -> "THIS"
      | 1 -> "THAT"
      | _ -> failwith  "this method is not for the command type"
      in
        "@" ^ symbol ^
        "\nD=M" ^
        "\n@SP" ^
        "\nA=M" ^
        "\nM=D" ^
        "\n@SP" ^
        "\nM=M+1\n"
  | _ -> failwith  "this method is not for the command type"
  ;;

let write_push_pop my_command arg_1 arg_2 c =
  match my_command with
    | Parser.C_PUSH -> output_string c.file (push arg_1 arg_2)
    | C_POP -> output_string c.file (pop arg_1 arg_2 c)
    | _ -> failwith  "this method is not for the command type"
  ;;

(* For `add`, `sub`, `and`, `or`
    2 pops, calculate, and save to stack *)
let binary_operation exp = 
  "@SP" ^
  "\nAM=M-1" ^
  "\nD=M" ^
  "\nA=A-1\n" ^ exp
   ;;


(* For `not`, `neg`
    1 pop, calculate, and save to stack *)
let unary_operation exp = 
  "@SP" ^
  "\nA=M-1\n" ^ exp ^
  "\n";;

let binary_operator command =
  match command with
    "add" -> "+"
  | "sub" -> "-"
  | "and" -> "&"
  | "or"  -> "|"
  | _ -> failwith  "this method is not for the command type"
;;



let write_arithmetic  arg_1 c =
  match arg_1 with
    "add" | "sub" | "and" | "or" ->
      let po = binary_operation "M=M" ^ (binary_operator arg_1) ^ "D\n" in
      output_string c.file po;
  | "eq" | "gt" | "lt" -> ()
  | "neg" | "not" ->
      let operator = match arg_1 with
          "neg" -> "-"
        | "not" -> "!"
        | _ -> failwith  "this method is not for the command type" in
        let po = unary_operation (operator) in
        output_string c.file po;
  | _ -> failwith  "this method is not for the command type"
  ;;


let c_constructor file_path = 
  let sub_vm = String.sub file_path 0 (String.length file_path - 3) in
  let asm_file = sub_vm ^ ".asm" in
  let c = {file = open_out asm_file; filename = sub_vm} in
  c;;

let close c =
  close_out c.file;;