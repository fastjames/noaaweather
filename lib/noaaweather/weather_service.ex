defmodule Noaaweather.WeatherService do
  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  require Logger

  @noaa_url Application.get_env(:noaaweather, :noaa_url)
  @user_agent [ { "User-agent", "Elixir <fastjames@gmail.com>" } ]
  @moduledoc """
  Request weather data from NOAA's XML API
  """

  def fetch(station_id) do
    Logger.info "Fetching weather data for #{station_id}"
    weather_url(station_id)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def weather_url(station_id) do
    "#{@noaa_url}/#{station_id}.xml"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "successful response"
    Logger.debug fn -> inspect(body) end
    { :ok, (decode_xml(body) |> weather_description) }
  end

  def handle_response({:error, %{status_code: status, body: body}}) do
    Logger.info "error #{status} returned"
    { :error, decode_xml(body) }
  end

  @doc """
  decode XML into doc object
  """
  def decode_xml(raw_body) do
    { doc, _rest } = raw_body
    |> :binary.bin_to_list
    |> :xmerl_scan.string
    doc
  end

  def weather_description(xml_doc) do
    xml_text_value(xml_doc, '//current_observation/weather')
  end

  def xml_text_value(doc, xpath) do
    [ selected_element ] = :xmerl_xpath.string(xpath, doc)
    [ selected_text ] = xmlElement(selected_element, :content)
    xmlText(selected_text, :value)
  end

end
