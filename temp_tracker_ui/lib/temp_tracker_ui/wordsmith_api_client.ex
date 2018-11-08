defmodule Wordsmith.API.Client do

  use HTTPoison.Base

  @base_url "https://api.automatedinsights.com/v1/"
  @project "intelligent-business"
  @template "master"
  @api_token System.get_env("WORDSMITH_API_KEY")

  defp content_url do
    @base_url <> "projects/" <> @project <> "/templates/" <> @template <> "/outputs"
  end

  def get_content(data) do
    case post(content_url(), Poison.encode!(data)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: %{"data" => %{"content"=> content}}}} ->
        content
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not Found!"
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def process_request_headers(headers) do
    request_headers() ++ headers
  end

  defp request_headers do
    [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer #{@api_token}"
    ]
  end

end
