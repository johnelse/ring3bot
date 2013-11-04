let config_filename = ".ring3bot.rc"

let with_file ~path ~f =
  let chan = open_in path in
  try
    let result = f chan in
    close_in chan;
    result
  with e ->
    close_in chan;
    raise e

let load () =
  try
    let home = Sys.getenv "HOME" in
    let config_file = Filename.concat home config_filename in
    with_file ~path:config_file
      ~f:(fun chan ->
        let lexer_state = Yojson.init_lexer () in
        let lexbuf = Lexing.from_channel chan in
        Config_j.read_config lexer_state lexbuf)
    with e ->
      failwith ("Failed to load config file: " ^ (Printexc.to_string e))
