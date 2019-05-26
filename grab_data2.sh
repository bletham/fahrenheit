token="FIXME put token here"

# Start with clear data files
> stations.csv
> all_weather_data.csv

for ZIP in $(tail -n+2 Gaz_zcta_national.txt | cut -f1)
do
    echo $ZIP
    # Identify stations for this zip
    sleep 10
    curl -H "token:$token" "https://www.ncdc.noaa.gov/cdo-web/api/v2/stations?locationid=ZIP:$ZIP&datasetid=GHCND&startdate=2018-01-01&enddate=2018-12-31&sortfield=datacoverage&sortorder=desc&datatypeid=TMAX,TMIN" > stations.json

    # Store station info
    echo $ZIP > station.txt
    jq -r '.results[0].id,.results[0].latitude,.results[0].longitude' stations.json >> station.txt
    cat station.txt | tr -s '\n' ',' >> stations.csv
    echo "" >> stations.csv

    # Extract station id
    stationid=$(jq -r '.results[0].id' stations.json)
    if [ $stationid == "null" ]; then
        echo "skip"
        continue
    fi
    
    echo $stationid
    sleep 10
    # Pull data
    curl -H "token:$token" "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&stationid=$stationid&startdate=2018-01-01&enddate=2018-12-31&limit=1000&units=standard&datatypeid=TMAX,TMIN" > data.json

    if (( $(wc -m <data.json) == 2 )); then
        echo "empty"
        continue
    fi
    
    # Parse json
    jq  -r '.results[] | .station' data.json > data.csv
    jq  -r '.results[] | .date' data.json | paste -d"," data.csv - > data2.csv
    jq  -r '.results[] | .datatype' data.json | paste -d"," data2.csv - > data3.csv
    jq  -r '.results[] | .value' data.json | paste -d"," data3.csv - > data4.csv
    sed -e "s/^/${ZIP},/" data4.csv > data5.csv

    cat data5.csv >> all_weather_data.csv
done
