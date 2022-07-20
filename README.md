# Nexromancer

Elxir application to make a distributed Load tester

## Usage
To run current version

Start Iex shell
`iex --name node1@127.0.0.1 --cookie asdf -S mix`

```
iex(node1@127.0.0.1)1> order = Nexromancer.Order.new("http://localhost:4000", :get)
%Nexromancer.Order{
  body: nil,
  expectation: nil,
  headers: nil,
  method: :get,
  type: nil,
  url: "http://localhost:4000"
}

iex(node1@127.0.0.1)2> order |> Nexromancer.create_horde
:ok

iex(node1@127.0.0.1)3> nexromancer_state = Nexromancer.get_state
%Nexromancer{hordes: [#PID<0.314.0>]}

iex(node1@127.0.0.1)9> [pid] = nexromancer_state.hordes
[#PID<0.314.0>]

iex(node1@127.0.0.1)5> Nexromancer.create_minions(pid, 5)
:ok

Nexromancer.start_horde(pid)
```

## Known bugs
Crash when start_horde

```
12:45:01.132 [error] GenServer #PID<0.320.0> terminating
** (ArgumentError) errors were found at the given arguments:

  * 1st argument: not an integer

    :erlang.send_after(HTTPoison, #PID<0.320.0>, :request)
    (nexromancer 0.1.0) lib/nexromancer/minion.ex:45: Nexromancer.Minion.handle_info/2
    (stdlib 4.0) gen_server.erl:1120: :gen_server.try_dispatch/4
    (stdlib 4.0) gen_server.erl:1197: :gen_server.handle_msg/6
    (stdlib 4.0) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
Last message: :request
State: %Nexromancer.Minion{http_client: HTTPoison, order: %Nexromancer.Order{body: nil, expectation: nil, headers: nil, method: :get, type: nil, url: "http://localhost:4000"}, state: :running, timer: HTTPoison}
```

## TODO

Distribute workers on all available nodes
Add detection for nodedown/nodeup to rebalance workers



