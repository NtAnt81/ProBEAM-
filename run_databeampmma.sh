#!/bin/bash

# Array Data: "Energi(MeV) Posisi_Spread(mm) Angular_Spread(mrad)"
# Data ini diintegrasikan langsung dari perhitungan Jupyter Notebook ProBeam
beam_data=(
"150.000000 3.722 4.08"
"149.044962 3.728 4.10"
"148.396135 3.733 4.12"
"147.745115 3.737 4.14"
"147.091879 3.742 4.15"
"146.436402 3.746 4.17"
"145.778657 3.751 4.19"
"145.118620 3.756 4.21"
"144.456263 3.761 4.22"
"143.791559 3.766 4.24"
"143.124480 3.770 4.26"
"142.454999 3.775 4.28"
"141.783086 3.780 4.30"
"141.108713 3.786 4.32"
"140.431848 3.791 4.34"
"139.752463 3.796 4.36"
"139.070524 3.801 4.38"
"138.386001 3.806 4.40"
"137.698861 3.812 4.42"
"137.009070 3.817 4.44"
"136.316595 3.823 4.46"
"135.621400 3.829 4.48"
"134.923451 3.834 4.50"
"134.222710 3.840 4.53"
"133.519141 3.846 4.55"
"132.812706 3.852 4.57"
"132.103365 3.858 4.59"
"131.391080 3.864 4.62"
"130.675808 3.870 4.64"
"129.957510 3.876 4.67"
"129.236141 3.883 4.69"
"128.511658 3.889 4.71"
"127.784016 3.895 4.74"
"127.053170 3.902 4.77"
"126.319073 3.909 4.79"
)

TEMPLATE="PRISTINE_TEMPLATE.txt"

echo "================================================="
echo " Starting ProBeam Automated Simulations..."
echo "================================================="

# Loop untuk mengeksekusi setiap baris data
for data in "${beam_data[@]}"
do
    # Memecah 1 baris string menjadi 3 variabel (E, POS, ANG)
    read -r E POS ANG <<< "$data"

    echo "[>>] Running Energy: $E MeV | Pos_Spread: $POS mm | Ang_Spread: $ANG mrad"

    # Menyisipkan ketiga variabel ke dalam template TOPAS
    sed -e "s/ENERGIPLACEHOLDER/$E/g" \
        -e "s/POSSPREADPLACEHOLDER/$POS/g" \
        -e "s/ANGSPREADPLACEHOLDER/$ANG/g" \
        $TEMPLATE > pristine_temp.txt

    # Menjalankan mesin TOPAS di latar belakang
    ~/topas/bin/topas pristine_temp.txt > /dev/null 2>&1

    # Mengamankan file CSV output
    if [ -f "DoseAtPhantom.csv" ]; then
        mv DoseAtPhantom.csv "PBP_${E}.csv"
        echo "[OK] Saved -> PBP_${E}.csv"
    else
        echo "[ERROR] Gagal mendapatkan CSV untuk energi $E MeV!"
    fi
    echo "-------------------------------------------------"
done

# Menghapus file temporary
rm pristine_temp.txt

echo "================================================="
echo " ALL 35 SIMULATIONS COMPLETED SUCCESSFULLY!"
echo "================================================="
