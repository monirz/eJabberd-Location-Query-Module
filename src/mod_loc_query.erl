-module(mod_loc_query).

-behaviour(gen_mod).

-include("logger.hrl").
-include("xmpp.hrl").




-export([start/2, stop/1, depends/2, mod_options/1, process_iq/1]).


start(Host, _Opts) ->
    gen_iq_handler:add_iq_handler(ejabberd_local, Host, <<"http://jabber.org/protocol/test">>, ?MODULE, process_iq),
    ok.                               

depends(_Host, _Opts) ->
    [].

mod_options(_Host) ->
    [].


stop(Host) ->
    ?INFO_MSG("mod_loc_query stopping", []),
    gen_iq_handler:remove_iq_handler(ejabberd_local, Host, <<"http://jabber.org/protocol/test">>),
    ok.

process_iq(#iq{type = get} = IQ) ->
    ?INFO_MSG("IQ get ~p \n", [IQ]),
    xmpp:make_iq_result(IQ).




