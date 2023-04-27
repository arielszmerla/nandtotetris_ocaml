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
      CodeWriter.write_function (Parser.arg1 p) (Parser.arg2 p) c
    | C_RETURN ->
      CodeWriter.write_return c
    | C_CALL ->
     
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

let filename_list file_name =
  if Filename.check_suffix file_name ".vm" then
    let basename = Filename.basename file_name in 

    let asm_file = basename ^ ".asm" in
    ([file_name],  (asm_file), false) 
  else if Sys.is_directory file_name then
    let filterboot = Sys.readdir file_name
      |> Array.to_list
      |> List.map (fun name -> Filename.basename name ) 
      |> List.filter (fun name -> name == "Sys" ) in
    let infilenames = Sys.readdir file_name
      |> Array.to_list
      |> List.filter (fun name -> Filename.check_suffix name ".vm") in
    let basename = Filename.basename file_name in 
    (*let sub_vm = String.sub file_name 0 (String.length file_name - 3) in*)
    let asm_file = basename ^ ".vm" in
    print_endline asm_file;
    
    (infilenames, asm_file, List.length filterboot > 0)
  else
    failwith  "this method is not for the command type"
   ;;  
 (*get files that fit the .vm format*) 

let handle_vm_file (file_name:string) (boot:bool) (infilename:string) =
  (* Construct full file path *)
  if file_name != "Sys" then
    let file_path = (Sys.argv.(1)) ^ "\\" ^ file_name in 
    let c = CodeWriter.c_constructor file_path boot in

   (*let p =  Parser.p_constructor ((Sys.argv.(1)) ^ "\\" ^ infilename) *)
  
    (*read_commands p c;*)
    (c)
  else
    let file_path = (Sys.argv.(1)) ^ "\\" ^ infilename in 
    let c = CodeWriter.c_constructor file_path false  in

    (*let p =  Parser.p_constructor ((Sys.argv.(1)) ^ "\\" ^ infilename) *)
  
    (*read_commands p c;*)
    (c)

let handle_any_file c (file_name:string) =
  let file_path = (Sys.argv.(1)) ^ "\\" ^ file_name in (* Construct full file path *)
  let p =  Parser.p_constructor file_path in
  read_commands p c;
  ;;
   
let main () = 
  let (file_names, outfilename, isBoot) = filename_list (Sys.argv.(1)) in
  print_endline (List.nth file_names 0);
  let c = handle_vm_file outfilename isBoot (List.nth file_names 0) in
  let handle = handle_any_file c in
  List.iter handle file_names;;


  

let () = main ();;