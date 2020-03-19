#!/bin/bash

# Shows Corona virus stats from VG in the menu bar

PATH="/usr/local/bin:$PATH"

userAgent="github.com/torrottum/bitbar-plugins/blob/master/corona.30m.sh"

counties=$(curl -s -A "$userAgent" "https://redutv-api.vg.no/corona/v1/sheets/norway-table-overview/?region=county")
hospitalized=$(curl -s -A "$userAgent" "https://redutv-api.vg.no/corona/v1/hospitalized")

echo "🦠 $(echo "$counties" | jq -r '.totals.confirmed // "-"')"
echo "---"
echo "Confimed: $(echo "$counties" | jq -r '.totals.confirmed // "-"')"
echo "Dead: $(echo "$counties" | jq -r '.totals.dead // "-"')"
echo "Recovered: $(echo "$counties" | jq -r '.totals.recovered // "-"')"
echo "---"
echo "Hospitalized: $(echo "$hospitalized" | jq -r '.current.total.hospitalized // "-"')"
echo "Respiratory: $(echo "$hospitalized" | jq -r '.current.total.respiratory // "-"')"
echo "Infected Employees: $(echo "$hospitalized" | jq -r '.current.total.infectedEmployees // "-"')"
echo "Quarantined Employees: $(echo "$hospitalized" | jq -r '.current.total.quarantineEmployees // "-"')"
echo "---"
echo "Infected per county"
echo "$counties" | jq -r '.cases | sort_by(.confirmed) | reverse[] |
    [.name, .confirmed // "-", .dead // "-", .recovered // "-"] | @tsv' |
    while IFS=$'\t' read -r name confirmed dead recovered; do
        echo "$name: $confirmed"
        echo "----"
        echo "--Confirmed: $confirmed"
        echo "--Dead: $dead"
        echo "--Recovered: $recovered"
    done
echo "---"
echo "Hospitalized"
echo "$hospitalized" | jq -r '.current.hospitals | sort_by(.hospitalized) | reverse[] |
    [.name, .hospitalized // "-", .respiratory // "-", .infectedEmployees // "-", .quarantineEmployees // "-"] | @tsv' |
    while IFS=$'\t' read -r name hospitalized respiratory infectedEmployees quarantineEmployees; do
        echo "$name: $hospitalized"
        echo "----"
        echo "--Hospitalized: $hospitalized"
        echo "--Respiratory: $respiratory"
        echo "--Infected Employees: $infectedEmployees"
        echo "--Quarantined Employees: $quarantineEmployees"
    done
