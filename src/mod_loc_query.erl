-module(mod_loc_query).

-behaviour(gen_mod).

-include("logger.hrl").

% -include("xmpp_codec.hrl").
-include("xmpp.hrl").

-include("mod_last.hrl").

-include("ejabberd_sql_pt.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

-define(NS_TEST, "http://jabber.org/protocol/test").

-record(lquery,
	{lat  :: undefined | binary(),
	 lon  :: undefined | binary()}).

-type lquery() :: #lquery{}.

-export([depends/2, mod_options/1, process_iq/1,
	 start/2, stop/1]).

start(Host, _Opts) ->
    xmpp:register_codec(loc_query),
    gen_iq_handler:add_iq_handler(ejabberd_local, Host,
				  <<"http://jabber.org/protocol/test">>,
				  ?MODULE, process_iq),
    ok.

depends(_Host, _Opts) -> [].

mod_options(_Host) -> [].

stop(Host) ->
    ?INFO_MSG("mod_loc_query stopping", []),
    gen_iq_handler:remove_iq_handler(ejabberd_local, Host,
				     <<"http://jabber.org/protocol/test">>),
    ok.

process_iq(#iq{type = get, sub_els = [#lquery{lat = Lat, lon = Lon}]} = IQ) ->
    ?INFO_MSG("IQ get > ~p Lat ~p Lon ~p\n",
	      [IQ, Lat, Lon]),
    xmpp:make_iq_result(IQ);
process_iq(#iq{type = set, to = To, from = From,
	       sub_els = [#lquery{lat = Lat, lon = Lon}]} =
	       IQ) ->
    ?INFO_MSG("IQ Set ~p Lat ~p Lon ~p\n",
	      [IQ, Lat, Lon]),
    % X = binary_to_float(Lat),
    Server = To#jid.lserver,
    User = From#jid.luser,
    ?INFO_MSG("IQ Set --> Server ~p User ~p\n",
	      [Server, User]),
    Query =
	io_lib:format("INSERT INTO locations(user_id, lat, "
		      "lon) VALUES ('~s', ~f,~f) ON DUPLICATE "
		      "KEY UPDATE lat=VALUES(lat), lon=VALUES(lon)",
		      [User, Lat, Lon]),
    case ejabberd_sql:sql_query(Server, [Query]) of
      {updated, _} -> ok;
      Err -> Err
    end,
    xmpp:make_iq_result(IQ).
