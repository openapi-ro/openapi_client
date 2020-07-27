defmodule OpenapiClient do
  use Tesla
  plug Tesla.Middleware.BaseUrl, OA.Application.get_env(:openapi_client, :base_url, "https://api.openapi.ro/")
  plug Tesla.Middleware.Headers, [{"x-api-key", OA.Application.get_env(:openapi_client, :api_key, {:system, "OA_KEY"}) }]
  plug Tesla.Middleware.JSON
  defp data_or_error(response) do
    case response do
      {:ok, %Tesla.Env{status: status, body: %{"data" => data}}}
          when status >= 200 and status <300->
            {:ok, data}
      {:ok, %Tesla.Env{status: status, body: data}}
        when status >= 200 and status <300->
          {:ok, data}
      {:error, _}=res -> res
      {_,%Tesla.Env{}= env} -> {:error, env}
    end
  end
  defp ok_or_raise(response) do
    case response do
      {:ok, resp}  -> resp
      {:error, %Tesla.Env{body: %{"error"=> %{"description"=> description}}}} -> raise "Remote Error: #{description}"
      {:error, err}   -> raise inspect(err)
    end
  end
  def company(cui) do
    get("api/companies/#{cui}")
    |> data_or_error()
  end
  def company!(cui) do
    company(cui)
    |> ok_or_raise()
  end
  def companies([]), do: []
  def companies([first| rest]) do
    [company(first)| companies(rest)]
  end
  def search(search_string, opts\\[]) do
    data =
      %{q: search_string}
      |> search_data_from_opts(opts)
    post("api/companies/search", data)
    |> data_or_error()
  end
  def search!(search_string, opts\\[]) do
    search(search_string, opts)
    |> ok_or_raise()
  end
  defp search_data_from_opts(data, [{:judet, judet} | rest]) do
    %{data| judet: judet}
  end
  defp search_data_from_opts(data, [{:include_radiata, include_radiata} | rest]) do
    %{data| include_radiata: include_radiata}
  end
  defp search_data_from_opts(data,[_|rest]) , do: search_data_from_opts(data, rest)
  defp search_data_from_opts(data,[]) , do: data

end
