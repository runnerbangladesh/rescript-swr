module Raw = Swr_raw

type 'data bound_mutate =
  ?data:'data -> ?shouldRevalidate:bool -> unit -> 'data option Js.Promise.t

type 'data responseInterface = {
  data: 'data option;
  error: Js.Promise.error;
  revalidate: unit -> bool Js.Promise.t;
  mutate: 'data bound_mutate;
  isValidating: bool;
}

let wrap_raw_response_intf = function[@warning "-45"]
  | Raw.{ data; error; revalidate; mutate; isValidating } ->
      let wrapped_mutate ?data ?shouldRevalidate () =
        mutate data shouldRevalidate
      in
      { data; error; revalidate; isValidating; mutate = wrapped_mutate }

let useSWR ?config x f =
  match config with
  | None -> Raw.useSWR1 [| x |] f |> wrap_raw_response_intf
  | Some config -> Raw.useSWR1_config [| x |] f config |> wrap_raw_response_intf

let useSWR_string x f = Raw.useSWR1 x f |> wrap_raw_response_intf
