#!/bin/bash

# 1. List of 35 energies from your Bortfeld calculation
# PLEASE CHANGE THE NUMBERS BELOW ACCORDING TO YOUR BORTFELD DATA
energy_list=(
150.000000
149.044962
148.396135
147.745115
147.091879
146.436402
145.778657
145.118620
144.456263
143.791559
143.124480
142.454999
141.783086
141.108713
140.431848
139.752463
139.070524
138.386001
137.698861
137.009070
136.316595
135.621400
134.923451
134.222710
133.519141
132.812706
132.103365
131.391080
130.675808
129.957510
129.236141
128.511658
127.784016
127.053170
126.319073
)

# Template file name
TEMPLATE="PRISTINE_TEMPLATE.txt"

echo "================================================="
echo " Starting Automation of 24 TOPAS Simulations..."
echo "================================================="

# Loop to execute each energy in the list
for E in "${energy_list[@]}"
do
    echo "[>>] Preparing simulation for Energy: $E MeV"

    # Copy the template and replace the placeholder with the current energy value
    sed "s/ENERGIPLACEHOLDER/$E/g" $TEMPLATE > pristine_temp.txt

    # Run the TOPAS engine silently (background processing)
    ~/topas/bin/topas pristine_temp.txt > /dev/null 2>&1

    # Rename the DoseAtPhantom.csv file so it is not overwritten by the next simulation
    if [ -f "DoseAtPhantom.csv" ]; then
        mv DoseAtPhantom.csv "PBP_${E}.csv"
        echo "[OK] Done. Result saved as PBP_${E}.csv"
    else
        echo "[ERROR] Failed to get CSV for energy $E MeV!"
    fi
    echo "-------------------------------------------------"
done

# Delete temporary file to keep the folder clean
rm pristine_temp.txt

echo "================================================="
echo " ALL SIMULATIONS COMPLETED! Your folder now contains 24 CSV files."
echo "================================================="
