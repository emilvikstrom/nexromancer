defmodule Nexromancer.Horde.Order do
  defstruct [:url, :method, :headers, :body, :type, :expectation]

  defmodule __MODULE__.Expectation do
    defstruct [:status, :body, :headers]
  end

  defmodule __MODULE__.Type do
    defstruct [:type, options: []]
  end
end
