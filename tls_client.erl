-module(tls_client).

-export([start/0, start/1]).

start() ->
    start("localhost", 636).

start([Host, Port]) when is_atom(Host) andalso is_atom(Port) ->
    start(atom_to_list(Host), binary_to_integer(atom_to_binary(Port))).

start(Host, Port) when is_integer(Port) ->
    inets:start(),
    ssl:start(),
    logger:set_application_level(ssl, debug),
    SslOpts = [
        {cacertfile, "./certs/ca_certificate.pem"},
        {verify, verify_peer},
        {versions, ['tlsv1.2']}
    ],
    io:format("[INFO] ssl:versions: ~p~n", [ssl:versions()]),
    ok = io:format("[INFO] before ssl:connect~n", []),
    case ssl:connect(Host, Port, SslOpts) of
        {ok, SslSocket} ->
            ok = io:format("[INFO] after ssl:connect~n", []),
            ok = ssl:close(SslSocket);
        Error ->
            ok = io:format(standard_error, "[ERROR] ssl:connect ~p~n", [Error])
    end,
    init:stop().
