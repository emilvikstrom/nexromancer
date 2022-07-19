defmodule Nexromancer.Order do
  defstruct [:url, :method, :headers, :body, :type, :expectation]

  defmodule __MODULE__.Expectation do
    defstruct [:status, :body, :headers]
  end

  defmodule __MODULE__.Type do
    defstruct [:type, options: []]
  end

  def new(url, method) do
    %__MODULE__{
      url: url,
      method: method
    }
  end

  def add_expectation(order, status_code, headers \\ [], body \\ "") do
    %__MODULE__{
      order
      | expectation: %__MODULE__.Expectation{
          status: status_code,
          headers: headers,
          body: body
        }
    }
  end
end
