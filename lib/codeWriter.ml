(*Targil 1*)
(*Reuven chiche 328944517*)
(*Ariel Szmerla 339623324*)

(* object containing main features for writing into the .asm file*)
type codeWriter = {
  mutable file : out_channel;
  mutable filename : string;
  mutable label_index : int;
  mutable function_index : int;

};;

(* create a ptr right syntax *)
let pointer_type (p:string) =
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


(* gets address of static ptr *)
let static_val (filename:string) (arg_2:int) = 
 let my_str = String.split_on_char '\\' filename in
 let len = List.length my_str  - 1 in
 let myfile = List.nth my_str len in
 print_endline myfile;
 myfile ^ "." ^ string_of_int arg_2;;


(* pop main function *)
let pop (arg_1:string) (arg_2:int) (c:codeWriter) =
  match (pointer_type arg_1) with
  | "LCL" | "THIS" | "ARG" | "THAT" ->
    let rec times (n:int) = if n = 0 then ""
                      else "\nA=A+1" ^ times (n - 1)
    in
    "@SP" ^
    "\nA=M-1" ^
    "\nD=M" ^
    "\n@" ^ pointer_type arg_1 ^
    "\nA=M" ^
    times arg_2 ^
    "\nM=D" ^
    "\n@SP" ^
    "\nM=M-1\n"
  |"TEMP" -> 
    "@SP" ^
    "\nA=M-1" ^
    "\nD=M" ^
    "\n@"  ^  string_of_int ( arg_2 + 5) ^
    "\nM=D" ^
    "\n@SP" ^
    "\nM=M-1\n"
  | "STATIC" ->
    "@SP" ^
    "\nM=M-1" ^
    "\nA=M" ^
    "\nD=M" ^
    "\n@" ^  static_val c.filename arg_2 ^
    "\nM=D\n"
  | "POINTER" ->
    let symbol =
      match arg_2 with
      | 0 -> "THIS"
      | 1 -> "THAT"
      | _ -> failwith  "this method is not for the command type"
      in
      "@SP" ^
      "\nA=M-1" ^
      "\nD=M" ^
      "\n@"^ symbol ^
      "\nM=D" ^
      "\n@SP" ^
      "\nM=M-1\n"
  | _ -> failwith  "this method is not for the command type"
  ;;


(* push main function *)  
let push (arg_1:string) (arg_2:int) (c:codeWriter) =
  match (pointer_type arg_1) with
  | "CONST" -> 
    "@" ^ string_of_int arg_2 ^
    "\nD=A" ^
    "\n@SP" ^
    "\nA=M" ^
    "\nM=D" ^
    "\n@SP" ^
    "\nM=M+1\n"
  | "LCL" | "THIS" | "THAT" | "ARG" ->
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
  |"TEMP" -> 
    "@" ^  string_of_int ( arg_2 + 5) ^
    "\nD=M" ^
    "\n@SP" ^
    "\nA=M" ^
    "\nM=D" ^
    "\n@SP" ^
    "\nM=M+1\n"
  | "STATIC" -> 
    "@" ^ static_val c.filename arg_2 ^ 
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


(* deal with memory actions functions *)
let write_push_pop (my_command:Parser.command) (arg_1:string) (arg_2:int) (c:codeWriter) =
  match my_command with
    | Parser.C_PUSH -> output_string c.file (push arg_1 arg_2 c)
    | Parser.C_POP -> output_string c.file (pop arg_1 arg_2 c)
    | _ -> failwith  "this method is not for the command type"
  ;;

(* For `add`, `sub`, `and`, `or`
    2 pops, calculate, and save result to stack *)
let binary_operation (exp:string) = 
  "@SP" ^
  "\nA=M-1" ^
  "\nD=M" ^
  "\nA=A-1\n" ^ exp
   ;;


(* For `not`, `neg`
    1 pop, calculate, and save result to stack *)
let unary_operation (exp:string) = 
  "@SP" ^
  "\nA=M-1" ^ 
  "\nM=" ^ exp ^ "M" ^
  "\n";;


(* For `lt`, `gt`, eq
   compare pop values, and go to the right code *)
let compare_operation (exp:string) (index:int) = 
  let myexp = String.uppercase_ascii(exp) in
  let num = string_of_int index in
  "@SP\n" ^
  "A=M-1\n" ^
  "D=M\n" ^
  "A=A-1\n" ^
  "D=M-D\n" ^
  "@LABEL_TRUE" ^ num ^ "\n" ^ 
  "D;J" ^ myexp ^ "\n" ^
  "@SP\n" ^
  "A=M-1\n" ^
  "A=A-1\n" ^
  "M=0\n" ^
  "@LABEL_FALSE" ^ num ^ "\n" ^ 
  "0;JMP\n" ^
  "(LABEL_TRUE" ^ num ^ ")\n" ^ 
  "@SP\n" ^
  "A=M-1\n" ^
  "A=A-1\n" ^
  "M=-1\n" ^
  "(LABEL_FALSE"^ num ^ ")\n" ^ 
  "@SP\n" ^
  "M=M-1\n";;
  

(* translate binary mathematic operator to right syntax *)
let binary_operator (command:string) =
  match command with
    "add" -> "+"
  | "sub" -> "-"
  | "and" -> "&"
  | "or"  -> "|"
  | _ -> failwith  "this method is not for the command type"
;;


(* write to outfile the asm code for mathematic ops *)
let write_arithmetic (arg_1:string) (c:codeWriter) =
  match arg_1 with
    "add" | "sub" | "and" | "or" ->
      output_string c.file
      (binary_operation "M=M" ^ (binary_operator arg_1) ^
      "D\n" ^
      "@SP\n" ^
      "M=M-1\n");
  | "eq" | "gt" | "lt" -> 
    c.label_index <- c.label_index + 1;
    let po = compare_operation arg_1 c.label_index in
    output_string c.file po;
  | "neg" | "not" ->
      let operator = match arg_1 with
        | "neg" -> "-"
        | "not" -> "!"
        | _ -> failwith  "this method is not for the command type" in
        let po = unary_operation (operator) in
        output_string c.file po;
  | _ -> failwith  "this method is not for the command type"
  ;;


(*close output file*)
let close (c:codeWriter) =
  close_out c.file;;

(*targil two------------------------------------------------*)

let set_file_name (file_name:string) (c:codeWriter) =
  c.filename <- file_name ;;


let write_label (label:string) (c:codeWriter) =
  output_string c.file ("(" ^ String.uppercase_ascii label ^ ")\n")
  ;;


let write_goto (label:string) (c:codeWriter) = 
  output_string c.file
  ( "@" ^ label ^ "\n" ^
  "0;JMP\n");;


let write_if (label:string) (c:codeWriter) =
  output_string c.file
  ("@SP\n" ^
  "M=M-1\n" ^
  "A=M\n" ^
  "D=M\n" ^
  "@IF_GOTO_FALSE$" ^ string_of_int c.label_index ^ "\n" ^
  "D;JEQ\n" ^
  "@" ^ label ^ "\n" ^
  "0;JMP\n" ^
  "(IF_GOTO_FALSE$" ^ string_of_int c.label_index ^ ")\n");;
  

let return_address (function_name:string) (c:codeWriter) = 
    "RETURN_ADDRESS_$"^ function_name ^ "_$" ^ string_of_int c.function_index ;;


let write_function (function_name:string) (n_vars:int) (c:codeWriter) =
  output_string c.file ( "(" ^ function_name ^ ")\n" );
  for _ = 1 to n_vars do
    output_string c.file  
              ("@SP\n" ^
              "A=M\n" ^
              "M=0\n" ^
              "@SP\n" ^
              "M=M+1\n");
  done;;


let pushPointer (pointerName:string) = 
  "@" ^ pointerName ^ "\n" ^
  "D=M\n" ^
  "@SP\n" ^
  "A=M\n" ^
  "M=D\n" ^
  "@SP\n" ^
  "M=M+1\n";;
  

let write_call (function_name:string) (n_args:int) (c:codeWriter) =
  let ret_address = return_address function_name c in
  output_string c.file (
          "@" ^ ret_address ^ "\n" ^
          "D=A\n" ^
          "@SP\n" ^
          "A=M\n" ^
          "M=D\n" ^
          "@SP\n" ^
          "M=M+1\n"
          ^ pushPointer "LCL"
          ^ pushPointer "ARG"
          ^ pushPointer "THIS"
          ^ pushPointer "THAT"
           ^ "@SP\n" ^
          "D=M\n" ^
          "@5\n" ^
          "D=D-A\n" ^
          "@" ^ string_of_int n_args ^ "\n" ^
          "D=D-A\n" ^
          "@ARG\n" ^
          "M=D\n" ^
          "@SP\n" ^
          "D=M\n" ^
          "@LCL\n" ^
          "M=D\n" ^ 
          "@" ^ function_name ^ "\n" ^
          "0;JMP\n" ^
          "($" ^ ret_address ^ ")\n");;

          
let write_return (c:codeWriter) = 
  output_string c.file (
          "@LCL\n" ^
          "D=M\n" ^
          "@FRAME\n" ^
          "M=D\n"
           ^
          "@FRAME\n" ^
          "D=M\n" ^
          "@5\n" ^
          "A=D-A\n" ^
          "D=M\n" ^
          "@RET\n" ^
          "M=D\n"
          ^
          "@SP\n" ^
          "M=M-1\n" ^
          "A=M\n" ^
          "D=M\n" ^
          "@ARG\n" ^
          "A=M\n" ^
          "M=D\n"
           ^
          "@ARG\n" ^
          "D=M+1\n" ^
          "@SP\n" ^
          "M=D\n"
           ^
          "@FRAME\n" ^
          "A=M-1\n" ^
          "D=M\n" ^
          "@THAT\n" ^
          "M=D\n"
          ^
          "@FRAME\n" ^
          "D=M\n" ^
          "@2\n" ^
          "A=D-A\n" ^
          "D=M\n" ^
          "@THIS\n" ^
          "M=D\n"
           ^
          "@FRAME\n" ^
          "D=M\n" ^
          "@3\n" ^
          "A=D-A\n" ^
          "D=M\n" ^
          "@ARG\n" ^
          "M=D\n"
          ^
          "@FRAME\n" ^
          "D=M\n" ^
          "@4\n" ^
          "A=D-A\n" ^
          "D=M\n" ^
          "@LCL\n" ^
          "M=D\n"
          ^
          "@RET\n" ^
          "A=M\n" ^
          "0;JMP\n")
;;


let write_init (c:codeWriter) =
  output_string c.file ( 
  "@256\n" ^
  "D=A\n" ^
  "@SP\n" ^
  "M=D\n");
  write_call "Sys.init" 0 c;
  ;;


(* ctor *)
let c_constructor (file_path:string) = 
  let sub_vm = String.sub file_path 0 (String.length file_path - 3) in
  let asm_file = sub_vm ^ ".asm" in
  
  let c = {file = open_out asm_file; filename = sub_vm; label_index = 0; function_index = 0} in
  write_init c;
  c;;
