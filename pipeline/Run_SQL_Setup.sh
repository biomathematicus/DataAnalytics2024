#!/ban/bash

echo $(date +"%T")

mkdir "Data"
(cd Data && mkdir ACLF_States)
mkdir "Raw Data"
(cd "Raw Data" && mkdir ACLF_States)
mkdir "Jupyter Output"

CONTAINER_NAME="python-runner"
docker exec "$CONTAINER_NAME" sh -c '[ ! -d /app/temp ] && mkdir -p /app/temp'

echo "Creating Database"
sh "./Scripts/01.make_db1.sh"

echo "Downloading Files"
sh "./Scripts/02.download_files.sh"

echo "Downloading ACLF States"
sh "./Scripts/03.download_aclf_states.sh"

echo "Unpacking Files"
sh "./Scripts/04.unpack_and_clean.sh"

echo "Preparing ACLF States Data"
sh "./Scripts/05.aclf_states_cleaner.sh"

echo "Preparing SAIPE Data"
sh "./Scripts/06.ussd17_cleaner.sh"

echo "Preparing SLGA Data"
sh "./Scripts/07.slga_cleaner.sh"

echo "Preparing SDGR Data"
sh "./Scripts/08.sdgr_cleaner.sh"

echo $(date +"%T")
echo "Populating SQL Tables"
sh "./Scripts/09.populate.sh"

echo $(date +"%T")
echo "Optimizing SQL Tables"
sh "./Scripts/10.optimize.sh"

echo $(date +"%T")
echo "Generating Notebooks"
sh "./Scripts/11.notebook_gen.sh"

echo $(date +"%T")
echo "Completed"
read -p "Press [Enter] key to exit..."