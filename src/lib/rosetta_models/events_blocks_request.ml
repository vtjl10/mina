(*
 * This file has been generated by the OCamlClientCodegen generator for openapi-generator.
 *
 * Generated by: https://openapi-generator.tech
 *
 * Schema Events_blocks_request.t : EventsBlocksRequest is utilized to fetch a sequence of BlockEvents indicating which blocks were added and removed from storage to reach the current state.
 *)

type t =
  { network_identifier : Network_identifier.t
  ; (* offset is the offset into the event stream to sync events from. If this field is not populated, we return the limit events backwards from tip. If this is set to 0, we start from the beginning. *)
    offset : int64 option [@default None]
  ; (* limit is the maximum number of events to fetch in one call. The implementation may return <= limit events. *)
    limit : int64 option [@default None]
  }
[@@deriving yojson { strict = false }, show]

(** EventsBlocksRequest is utilized to fetch a sequence of BlockEvents indicating which blocks were added and removed from storage to reach the current state. *)
let create (network_identifier : Network_identifier.t) : t =
  { network_identifier; offset = None; limit = None }
