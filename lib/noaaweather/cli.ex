defmodule Noaaweather.CLI do
  @moduledoc """
  Handle command-line parsing and the dispatch to the various functions that
  end up generating a table of the station's weather data.
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help])
    case parse do
    { [ help: true ], _, _ }
      -> :help
    { _, [ station_id ], _ }
      -> { station_id }
    _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: noaaweather <station_id>
    """
    System.halt(0)
  end

  def process({ station_id }) do
    station_id
    |> Noaaweather.WeatherService.fetch
    |> decode_response
    |> print_summary(station_id)
    # |> convert_to_list_of_hashdicts
    # |> print_table_for_columns
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from NOAA: #{message}"
    System.halt(2)
  end

  def print_summary(current_conditions, station_id) do
    IO.puts "Current Conditions at #{station_id}: #{current_conditions}"
  end

end
