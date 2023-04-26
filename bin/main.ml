(*Targil 1*)
(*Reuven chiche 328944517*)
(*Ariel Szmerla 339623324*)

(*get modules of lib project*)
open N_translator

(*handle each comamnd line by line and write it in output file *)
let handle_command (p:Parser.parser) (c:CodeWriter.codeWriter) =
  let my_command = Parser.command_type p in
    match my_command with
    | C_ARITHMETIC -> 
      CodeWriter.write_arithmetic (Parser.arg1 p) c
    | C_PUSH | C_POP ->
      CodeWriter.write_push_pop my_command (Parser.arg1 p) (Parser.arg2 p) c
    | C_LABEL ->
      CodeWriter.write_label (Parser.arg1 p) c
    | C_GOTO ->
      CodeWriter.write_goto (Parser.arg1 p) c
    | C_IF ->
      CodeWriter.write_if (Parser.arg1 p) c
    | C_FUNCTION ->
      c.function_index <- c.function_index + 1;
      let num_locals = (Parser.arg2 p) in
      CodeWriter.write_function num_locals c
    | C_RETURN ->
      CodeWriter.write_return c
    | C_CALL ->
      c.function_index <- c.function_index + 1;
      let function_name = Parser.arg1 p in
      let num_args = (Parser.arg2 p) in
      CodeWriter.write_call function_name num_args c
    | _ -> ()
  ;;

(*read from .vm file*)
let read_commands (p:Parser.parser) (c:CodeWriter.codeWriter) = 
  while Parser.has_more_lines (p) do
    handle_command p c;
    Parser.advance p;
  done;
  print_endline "File ended sucessfully";;

 (*get files that fit the .vm format*) 
let handle_vm_file (file_name:string) =
  if Filename.check_suffix file_name ".vm" then (* Check if file has .vm suffix *)
    let file_path = (Sys.argv.(1)) ^ "\\" ^ file_name in (* Construct full file path *)
    let p =  Parser.p_constructor file_path in
    let c = CodeWriter.c_constructor file_path in
    read_commands p c;
    ();
  else
    () (* Skip non-.vm files *) 
   ;;

   
let main () = 
  let dir_contents = Array.to_list (Sys.readdir (Sys.argv.(1))) in (* Get directory contents as list *)
  print_endline(Sys.argv.(1));
  print_endline (String.concat " " dir_contents);
  List.iter handle_vm_file dir_contents;; (* Iterate over files and handle .vm files *)

let () = main ();;