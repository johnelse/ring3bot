module C = Irc_client_lwt.Client
open Lwt

let string_opt_to_string = function
  | Some s -> s
  | None -> "None"

let string_list_to_string string_list =
  Printf.sprintf "[%s]" (String.concat "; " string_list)

let print_message {Irc_message.prefix; command; params; trail} =
  Lwt_io.printf "Got message: %s %s %s %s\n"
    (string_opt_to_string prefix)
    command
    (string_list_to_string params)
    (string_opt_to_string trail)

let callback ~connection ~result ~config =
  let open Config_t in
  let open Irc_message in
  match result with
  | Message ({command = "PRIVMSG"; trail = Some message} as contents) ->
    print_message contents
    >>= (fun () ->
      C.send_privmsg ~connection ~target:config.channel ~message)
  | Message contents ->
    print_message contents
  | Parse_error (message, error) ->
    Lwt_io.printlf "Couldn't parse \"%s\": %s" message error

let lwt_main config =
  let open Config_t in
  C.connect_by_name
    ~server:config.server
    ~port:config.port
    ~username:(match config.username with
      | Some username -> username
      | None -> config.nick)
    ~mode:0
    ~realname:(match config.realname with
      | Some realname -> realname
      | None -> config.nick)
    ~nick:config.nick
    ?password:config.password
    ()
  >>= (function
    | Some connection ->
      C.send_join ~connection ~channel:config.channel
      >>= (fun () ->
        C.listen
          ~connection
          ~callback:(fun ~connection ~result ->
            callback ~connection ~result ~config))
    | None ->
      Lwt.fail (Failure "Host not found"))

let () =
  let config = Config.load () in
  Lwt_main.run (lwt_main config)
