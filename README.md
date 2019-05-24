Data and code for post ["In Defense of Fahrenheit"](http://lethalletham.com/posts/fahrenheit.html).

The files are:

* Gaz_zcta_national.txt: U.S. population data by zip code. This can be downloaded from the Census website.

* stations.csv: Weather station by zipcode, along with lat long.

* all_weather_data.csv: 2018 daily high and low temperatures for the weather stations in stations.csv.

* grab_data2.sh: The script for fetching the data in stations.csv and all_weather_data.csv. It requires an API token with NCDC. For every zip code in Gaz_zcta_national.txt, it first queries NCDC for any weather stations in that zip (stations.csv), and then if there is, queries the data for that station (all_weather_data.csv). Some shell acrobatics for converting json into csv.

* analysis.ipynb: An ipython notebook that uses Gaz_zcta_national.txt, stations.csv, and all_weather_data.csv to generate the figures in the post.
