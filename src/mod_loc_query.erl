-module(mod_loc_query).
-author("Monir Zaman").

-behaviour(gen_mod).

-include("logger.hrl").

-include("xmpp.hrl").
-include("mod_last.hrl").
-define(NS_TEST, "http://jabber.org/protocol/test").

-record(lquery,
	{lat  :: undefined | binary(),
	 lon  :: undefined | binary()}).

-type lquery() :: #lquery{}.

-record(location, {users = [] :: [binary()]}).
-type location() :: #location{}.


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

%% Process IQ for get
process_iq(#iq{type = get, to = To, sub_els = [#lquery{lat = Lat, lon = Lon}]} = IQ) ->
    ?INFO_MSG("IQ get > ~p Lat ~p Lon ~p\n",
          [IQ, Lat, Lon]),
          Server = To#jid.lserver,
        Query =
        io_lib:format(" SELECT user_id, lat, lon, ( 3959 * acos(cos(radians(~f)) * cos(radians(lat)) * cos(radians(lon) - radians(~f)) + sin(radians(~f)) *  sin(radians(lat )))) AS distance FROM locations  HAVING distance < 0.5 ORDER BY distance;",
         [Lat, Lon, Lat]),

    ?INFO_MSG("Query string > ~p\n", [Query]),      

    % TODO make separate function for getting users -> get_users/1
    case ejabberd_sql:sql_query(Server, [Query]) of
        {selected, Columns, Results} ->
            ?INFO_MSG("Debug >>> ~p, columns ~p results ~p\n", ["ok ", Columns, Results]),   
            {ok, Columns, Results},
            Users = [X || [X|_] <- Results],

            ?INFO_MSG("IQ users ---- ~p\n", [Users]),

            xmpp:make_iq_result(IQ, #location{users = Users}); 
        
        _Err ->
            {error, db_failure} 
    end;
    
%% Process IQ for set 
process_iq(#iq{type = set, to = To, from = From, sub_els = [#lquery{lat = Lat, lon = Lon}]} = IQ) ->
    ?INFO_MSG("IQ Set ~p Lat ~p Lon ~p\n", [IQ, Lat, Lon]),
    
    % X = binary_to_float(Lat),
    % binary to float enc/dec is handled by the xmpp code genrated for XML spec. 
    Server = To#jid.lserver,
    User = From#jid.luser,
    ?INFO_MSG("IQ Set --> Server ~p User ~p\n",[Server, User]),
    Query = io_lib:format("INSERT INTO locations(user_id, lat, "
		      "lon) VALUES ('~s', ~f,~f) ON DUPLICATE "
		      "KEY UPDATE lat=VALUES(lat), lon=VALUES(lon)",
              [User, Lat, Lon]),
           
    case ejabberd_sql:sql_query(Server, [Query]) of
        {updated, _} -> ok,
        xmpp:make_iq_result(IQ); 
  
        Err -> 
          Err

    end.
