%% Created automatically by XML generator (fxml_gen.erl)
%% Source: xmpp_codec.spec

-module(loc_query).

-compile(export_all).

do_decode(<<"lon">>,
	  <<"http://jabber.org/protocol/test">>, El, Opts) ->
    decode_lon(<<"http://jabber.org/protocol/test">>, Opts,
	       El);
do_decode(<<"lat">>,
	  <<"http://jabber.org/protocol/test">>, El, Opts) ->
    decode_lat(<<"http://jabber.org/protocol/test">>, Opts,
	       El);
do_decode(<<"query">>,
	  <<"http://jabber.org/protocol/test">>, El, Opts) ->
    decode_lquery(<<"http://jabber.org/protocol/test">>,
		  Opts, El);
do_decode(<<"user">>,
	  <<"http://jabber.org/protocol/test">>, El, Opts) ->
    decode_user(<<"http://jabber.org/protocol/test">>, Opts,
		El);
do_decode(<<"location">>,
	  <<"http://jabber.org/protocol/test">>, El, Opts) ->
    decode_location(<<"http://jabber.org/protocol/test">>,
		    Opts, El);
do_decode(Name, <<>>, _, _) ->
    erlang:error({xmpp_codec, {missing_tag_xmlns, Name}});
do_decode(Name, XMLNS, _, _) ->
    erlang:error({xmpp_codec, {unknown_tag, Name, XMLNS}}).

tags() ->
    [{<<"lon">>, <<"http://jabber.org/protocol/test">>},
     {<<"lat">>, <<"http://jabber.org/protocol/test">>},
     {<<"query">>, <<"http://jabber.org/protocol/test">>},
     {<<"user">>, <<"http://jabber.org/protocol/test">>},
     {<<"location">>,
      <<"http://jabber.org/protocol/test">>}].

do_encode({location, _} = Location, TopXMLNS) ->
    encode_location(Location, TopXMLNS);
do_encode({lquery, _, _} = Query, TopXMLNS) ->
    encode_lquery(Query, TopXMLNS).

do_get_name({location, _}) -> <<"location">>;
do_get_name({lquery, _, _}) -> <<"query">>.

do_get_ns({location, _}) ->
    <<"http://jabber.org/protocol/test">>;
do_get_ns({lquery, _, _}) ->
    <<"http://jabber.org/protocol/test">>.

pp(location, 1) -> [users];
pp(lquery, 2) -> [lat, lon];
pp(_, _) -> no.

records() -> [{location, 1}, {lquery, 2}].

decode_lon(__TopXMLNS, __Opts,
	   {xmlel, <<"lon">>, _attrs, _els}) ->
    Cdata = decode_lon_els(__TopXMLNS, __Opts, _els, <<>>),
    Cdata.

decode_lon_els(__TopXMLNS, __Opts, [], Cdata) ->
    decode_lon_cdata(__TopXMLNS, Cdata);
decode_lon_els(__TopXMLNS, __Opts,
	       [{xmlcdata, _data} | _els], Cdata) ->
    decode_lon_els(__TopXMLNS, __Opts, _els,
		   <<Cdata/binary, _data/binary>>);
decode_lon_els(__TopXMLNS, __Opts, [_ | _els], Cdata) ->
    decode_lon_els(__TopXMLNS, __Opts, _els, Cdata).

encode_lon(Cdata, __TopXMLNS) ->
    __NewTopXMLNS =
	xmpp_codec:choose_top_xmlns(<<"http://jabber.org/protocol/test">>,
				    [], __TopXMLNS),
    _els = encode_lon_cdata(Cdata, []),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
					__TopXMLNS),
    {xmlel, <<"lon">>, _attrs, _els}.

decode_lon_cdata(__TopXMLNS, <<>>) ->
    erlang:error({xmpp_codec,
		  {missing_cdata, <<>>, <<"lon">>, __TopXMLNS}});
decode_lon_cdata(__TopXMLNS, _val) ->
    case catch erlang:binary_to_float(_val) of
      {'EXIT', _} ->
	  erlang:error({xmpp_codec,
			{bad_cdata_value, <<>>, <<"lon">>, __TopXMLNS}});
      _res -> _res
    end.

encode_lon_cdata(_val, _acc) ->
    [{xmlcdata, erlang:float_to_binary(_val)} | _acc].

decode_lat(__TopXMLNS, __Opts,
	   {xmlel, <<"lat">>, _attrs, _els}) ->
    Cdata = decode_lat_els(__TopXMLNS, __Opts, _els, <<>>),
    Cdata.

decode_lat_els(__TopXMLNS, __Opts, [], Cdata) ->
    decode_lat_cdata(__TopXMLNS, Cdata);
decode_lat_els(__TopXMLNS, __Opts,
	       [{xmlcdata, _data} | _els], Cdata) ->
    decode_lat_els(__TopXMLNS, __Opts, _els,
		   <<Cdata/binary, _data/binary>>);
decode_lat_els(__TopXMLNS, __Opts, [_ | _els], Cdata) ->
    decode_lat_els(__TopXMLNS, __Opts, _els, Cdata).

encode_lat(Cdata, __TopXMLNS) ->
    __NewTopXMLNS =
	xmpp_codec:choose_top_xmlns(<<"http://jabber.org/protocol/test">>,
				    [], __TopXMLNS),
    _els = encode_lat_cdata(Cdata, []),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
					__TopXMLNS),
    {xmlel, <<"lat">>, _attrs, _els}.

decode_lat_cdata(__TopXMLNS, <<>>) ->
    erlang:error({xmpp_codec,
		  {missing_cdata, <<>>, <<"lat">>, __TopXMLNS}});
decode_lat_cdata(__TopXMLNS, _val) ->
    case catch erlang:binary_to_float(_val) of
      {'EXIT', _} ->
	  erlang:error({xmpp_codec,
			{bad_cdata_value, <<>>, <<"lat">>, __TopXMLNS}});
      _res -> _res
    end.

encode_lat_cdata(_val, _acc) ->
    [{xmlcdata, erlang:float_to_binary(_val)} | _acc].

decode_lquery(__TopXMLNS, __Opts,
	      {xmlel, <<"query">>, _attrs, _els}) ->
    {Lat, Lon} = decode_lquery_els(__TopXMLNS, __Opts, _els,
				   error, undefined),
    {lquery, Lat, Lon}.

decode_lquery_els(__TopXMLNS, __Opts, [], Lat, Lon) ->
    {case Lat of
       error ->
	   erlang:error({xmpp_codec,
			 {missing_tag, <<"lat">>, __TopXMLNS}});
       {value, Lat1} -> Lat1
     end,
     Lon};
decode_lquery_els(__TopXMLNS, __Opts,
		  [{xmlel, <<"lat">>, _attrs, _} = _el | _els], Lat,
		  Lon) ->
    case xmpp_codec:get_attr(<<"xmlns">>, _attrs,
			     __TopXMLNS)
	of
      <<"http://jabber.org/protocol/test">> ->
	  decode_lquery_els(__TopXMLNS, __Opts, _els,
			    {value,
			     decode_lat(<<"http://jabber.org/protocol/test">>,
					__Opts, _el)},
			    Lon);
      _ ->
	  decode_lquery_els(__TopXMLNS, __Opts, _els, Lat, Lon)
    end;
decode_lquery_els(__TopXMLNS, __Opts,
		  [{xmlel, <<"lon">>, _attrs, _} = _el | _els], Lat,
		  Lon) ->
    case xmpp_codec:get_attr(<<"xmlns">>, _attrs,
			     __TopXMLNS)
	of
      <<"http://jabber.org/protocol/test">> ->
	  decode_lquery_els(__TopXMLNS, __Opts, _els, Lat,
			    decode_lon(<<"http://jabber.org/protocol/test">>,
				       __Opts, _el));
      _ ->
	  decode_lquery_els(__TopXMLNS, __Opts, _els, Lat, Lon)
    end;
decode_lquery_els(__TopXMLNS, __Opts, [_ | _els], Lat,
		  Lon) ->
    decode_lquery_els(__TopXMLNS, __Opts, _els, Lat, Lon).

encode_lquery({lquery, Lat, Lon}, __TopXMLNS) ->
    __NewTopXMLNS =
	xmpp_codec:choose_top_xmlns(<<"http://jabber.org/protocol/test">>,
				    [], __TopXMLNS),
    _els = lists:reverse('encode_lquery_$lat'(Lat,
					      __NewTopXMLNS,
					      'encode_lquery_$lon'(Lon,
								   __NewTopXMLNS,
								   []))),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
					__TopXMLNS),
    {xmlel, <<"query">>, _attrs, _els}.

'encode_lquery_$lat'(Lat, __TopXMLNS, _acc) ->
    [encode_lat(Lat, __TopXMLNS) | _acc].

'encode_lquery_$lon'(undefined, __TopXMLNS, _acc) ->
    _acc;
'encode_lquery_$lon'(Lon, __TopXMLNS, _acc) ->
    [encode_lon(Lon, __TopXMLNS) | _acc].

decode_user(__TopXMLNS, __Opts,
	    {xmlel, <<"user">>, _attrs, _els}) ->
    Cdata = decode_user_els(__TopXMLNS, __Opts, _els, <<>>),
    Cdata.

decode_user_els(__TopXMLNS, __Opts, [], Cdata) ->
    decode_user_cdata(__TopXMLNS, Cdata);
decode_user_els(__TopXMLNS, __Opts,
		[{xmlcdata, _data} | _els], Cdata) ->
    decode_user_els(__TopXMLNS, __Opts, _els,
		    <<Cdata/binary, _data/binary>>);
decode_user_els(__TopXMLNS, __Opts, [_ | _els],
		Cdata) ->
    decode_user_els(__TopXMLNS, __Opts, _els, Cdata).

encode_user(Cdata, __TopXMLNS) ->
    __NewTopXMLNS =
	xmpp_codec:choose_top_xmlns(<<"http://jabber.org/protocol/test">>,
				    [], __TopXMLNS),
    _els = encode_user_cdata(Cdata, []),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
					__TopXMLNS),
    {xmlel, <<"user">>, _attrs, _els}.

decode_user_cdata(__TopXMLNS, <<>>) -> <<>>;
decode_user_cdata(__TopXMLNS, _val) -> _val.

encode_user_cdata(<<>>, _acc) -> _acc;
encode_user_cdata(_val, _acc) ->
    [{xmlcdata, _val} | _acc].

decode_location(__TopXMLNS, __Opts,
		{xmlel, <<"location">>, _attrs, _els}) ->
    Users = decode_location_els(__TopXMLNS, __Opts, _els,
				[]),
    {location, Users}.

decode_location_els(__TopXMLNS, __Opts, [], Users) ->
    lists:reverse(Users);
decode_location_els(__TopXMLNS, __Opts,
		    [{xmlel, <<"user">>, _attrs, _} = _el | _els], Users) ->
    case xmpp_codec:get_attr(<<"xmlns">>, _attrs,
			     __TopXMLNS)
	of
      <<"http://jabber.org/protocol/test">> ->
	  decode_location_els(__TopXMLNS, __Opts, _els,
			      [decode_user(<<"http://jabber.org/protocol/test">>,
					   __Opts, _el)
			       | Users]);
      _ ->
	  decode_location_els(__TopXMLNS, __Opts, _els, Users)
    end;
decode_location_els(__TopXMLNS, __Opts, [_ | _els],
		    Users) ->
    decode_location_els(__TopXMLNS, __Opts, _els, Users).

encode_location({location, Users}, __TopXMLNS) ->
    __NewTopXMLNS =
	xmpp_codec:choose_top_xmlns(<<"http://jabber.org/protocol/test">>,
				    [], __TopXMLNS),
    _els = lists:reverse('encode_location_$users'(Users,
						  __NewTopXMLNS, [])),
    _attrs = xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
					__TopXMLNS),
    {xmlel, <<"location">>, _attrs, _els}.

'encode_location_$users'([], __TopXMLNS, _acc) -> _acc;
'encode_location_$users'([Users | _els], __TopXMLNS,
			 _acc) ->
    'encode_location_$users'(_els, __TopXMLNS,
			     [encode_user(Users, __TopXMLNS) | _acc]).
