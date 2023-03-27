(*Targil 1*)
(*Reuven chiche 328944517*)
(*Ariel Szmerla 339623324*)


(*get modules of lib project*)
open N_translator


(*handle each comamnd line by line and write it in output file *)
let handle_command p c=
  let my_command = Parser.command_type p in
    match my_command with
    | C_ARITHMETIC -> 
      let first =  Parser.arg1 p in
      CodeWriter.write_arithmetic first c
    | C_PUSH | C_POP ->
      let first =  Parser.arg1 p in
      let second =  Parser.arg2 p in
      CodeWriter.write_push_pop my_command first second c
    | _ -> ()
  ;;

(*read from .vm file*)
let read_commands p c = 
  while Parser.has_more_lines (p) do
    handle_command p c;
    Parser.advance p;
  done;
  print_endline "File ended sucessfully";;

 (*get files that fit the .vm format*) 
let handle_vm_file file_name =
  if Filename.check_suffix file_name ".vm" then (* Check if file has .vm suffix *)
    let file_path = (Sys.argv.(1)) ^ "\\" ^ file_name in (* Construct full file path *)
    let p =  Parser.p_constructor file_path in
    let c = CodeWriter.c_constructor file_path in
    read_commands p c;
    ();
  else
    () (* Skip non-.vm files *) 
   ;;

let main = 
  let dir_contents = Array.to_list (Sys.readdir (Sys.argv.(1))) in (* Get directory contents as list *)
  print_endline(Sys.argv.(1));
  print_endline (String.concat " " dir_contents);
  List.iter handle_vm_file dir_contents;; (* Iterate over files and handle .vm files *)

let () = main;;