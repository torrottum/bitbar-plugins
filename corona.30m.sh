#!/bin/bash

# Shows Corona virus stats from VG in the menu bar

PATH="/usr/local/bin:$PATH"

counties=$(curl -s "https://redutv-api.vg.no/corona/v1/sheets/norway-table-overview/?region=county")
municipalities=$(curl -s "https://redutv-api.vg.no/corona/v1/sheets/norway-table-overview/?region=municipality")
hospitalized=$(curl -s "https://redutv-api.vg.no/corona/v1/hospitalized")

echo "🦠 $(echo "$counties" | jq -r '.totals.confirmed')"
echo "---"
echo "Confimed: $(echo "$counties" | jq -r '.totals.confirmed')"
echo "Dead: $(echo "$counties" | jq -r '.totals.dead')"
echo "Recovered: $(echo "$counties" | jq -r '.totals.recovered')"
echo "---"
echo "Hospitalized: $(echo "$hospitalized" | jq -r '.current.total.hospitalized')"
echo "Respiratory: $(echo "$hospitalized" | jq -r '.current.total.respiratory')"
echo "Infected Employees: $(echo "$hospitalized" | jq -r '.current.total.infectedEmployees')"
echo "Quarantined Employees: $(echo "$hospitalized" | jq -r '.current.total.quarantineEmployees')"
echo "---"
echo "Infected per county"
echo "$counties" | jq -r '.cases[] | [.name, .confirmed, .dead, .recovered] | @tsv' |
    while IFS=$'\t' read -r name confirmed dead recovered; do
        echo "$name: $confirmed"
        echo "----"
        echo "--Confirmed: $confirmed"
        echo "--Dead: $dead"
        echo "--Recovered: $recovered"
    done
echo "---"
echo "Hospitalized"
echo "$hospitalized" | jq -r '.current.hospitals[] | [.name, .hospitalized, .respiratory, .infectedEmployees, .quarantineEmployees] | @tsv' |
    while IFS=$'\t' read -r name hospitalized infectedEmployees quarantineEmployees; do
        echo "$name: $hospitalized"
        echo "----"
        echo "--Hospitalized: $hospitalized"
        echo "--Respiratory: $respiratory"
        echo "--Infected Employees: $infectedEmployees"
        echo "--Quarantined Employees: $quarantineEmployees"
    done
