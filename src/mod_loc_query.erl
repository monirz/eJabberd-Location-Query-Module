-module(mod_loc_query).

-behaviour(gen_mod).

-include("logger.hrl").
% -include("xmpp_codec.hrl").
-include("xmpp.hrl").


-define(NS_TEST, "http://jabber.org/protocol/test").

-record(lquery, {lat :: 'undefined' | binary(),
                 lon :: 'undefined' | binary()}).
-type lquery() :: #lquery{}.

-export([start/2, stop/1, depends/2, mod_options/1, process_iq/1]).



start(Host, _Opts) ->
    xmpp:register_codec(loc_query),
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


process_iq(#iq{type = get, sub_els = [#lquery{lat = Lat, lon = Lon}]} = IQ) ->
    ?INFO_MSG("IQ get------------------------------------------- ~p Lat ~p Lon ~p\n", [IQ, Lat, Lon]),
    xmpp:make_iq_result(IQ);
process_iq(#iq{type = set, to = To, sub_els = [#lquery{lat = Lat, lon = Lon}]} = IQ) ->

    
    ?INFO_MSG("IQ Set ------------------------------------------- ~p Lat ~p Lon ~p\n", [IQ, Lat, Lon]),
     xmpp:make_iq_result(IQ).




