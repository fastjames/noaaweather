defmodule Noaaweather.WeatherServiceTest do
  use ExUnit.Case

  # require Record
  # Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  # Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  import Noaaweather.WeatherService, only: [decode_xml: 1,
                                            weather_description: 1]


  def noaa_xml do
    """
    <?xml version="1.0" encoding="ISO-8859-1"?>
    <?xml-stylesheet href="latest_ob.xsl" type="text/xsl"?>
    <current_observation version="1.0"
         xmlns:xsd="http://www.w3.org/2001/XMLSchema"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="http://www.weather.gov/view/current_observation.xsd">
        <credit>NOAA's National Weather Service</credit>
        <credit_URL>http://weather.gov/</credit_URL>
        <image>
                <url>http://weather.gov/images/xml_logo.gif</url>
                <title>NOAA's National Weather Service</title>
                <link>http://weather.gov</link>
        </image>
        <suggested_pickup>15 minutes after the hour</suggested_pickup>
        <suggested_pickup_period>60</suggested_pickup_period>
        <location>Fayetteville/Springdale, Northwest Arkansas Regional Airport, AR</location>
        <station_id>KXNA</station_id>
        <latitude>36.28194</latitude>
        <longitude>-94.30694</longitude>
        <observation_time>Last Updated on Aug 10 2015, 9:53 am CDT</observation_time>
        <observation_time_rfc822>Mon, 10 Aug 2015 09:53:00 -0500</observation_time_rfc822>
        <weather>A Few Clouds</weather>
        <temperature_string>78.0 F (25.6 C)</temperature_string>
        <temp_f>78.0</temp_f>
        <temp_c>25.6</temp_c>
        <relative_humidity>82</relative_humidity>
        <wind_string>East at 6.9 MPH (6 KT)</wind_string>
        <wind_dir>East</wind_dir>
        <wind_degrees>70</wind_degrees>
        <wind_mph>6.9</wind_mph>
        <wind_kt>6</wind_kt>
        <pressure_string>1016.0 mb</pressure_string>
        <pressure_mb>1016.0</pressure_mb>
        <pressure_in>30.05</pressure_in>
        <dewpoint_string>72.0 F (22.2 C)</dewpoint_string>
        <dewpoint_f>72.0</dewpoint_f>
        <dewpoint_c>22.2</dewpoint_c>
        <visibility_mi>10.00</visibility_mi>
        <icon_url_base>http://forecast.weather.gov/images/wtf/small/</icon_url_base>
        <two_day_history_url>http://www.weather.gov/data/obhistory/KXNA.html</two_day_history_url>
        <icon_url_name>few.png</icon_url_name>
        <ob_url>http://www.weather.gov/data/METAR/KXNA.1.txt</ob_url>
        <disclaimer_url>http://weather.gov/disclaimer.html</disclaimer_url>
        <copyright_url>http://weather.gov/disclaimer.html</copyright_url>
        <privacy_policy_url>http://weather.gov/notice.html</privacy_policy_url>
    </current_observation>
    """
  end

  test "parsing the weather out" do
    doc = decode_xml(noaa_xml)
    title = weather_description(doc)
    assert title == 'A Few Clouds'
  end


end
