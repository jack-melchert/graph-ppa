#==================================================================
# Script   : lib2db.py
# Function : Given a directory, convert *.lib files into *.db files
# Usage    : python3 lib2db.py <directory>
# Note     : this script uses design compiler and library compiler
#            before using, please load these tools by
#
#            $ module load base dc_shell lc
#
# Author   : Po-Han Chen
#==================================================================
import sys
import glob, os
import subprocess
import re

dc_script="""enable_write_lib_mode
read_lib ./{}
write_lib -format db {} -output ./{}
exit
"""

def convert_lib_to_db(fname_lib):
    library_name = "NangateOpenCellLibrary"
    fname_db = fname_lib.replace(".lib", ".db")
    tmp_dc_script = dc_script.format(fname_lib, library_name, fname_db)
    tmp_dc_script_name = f"lib2db_{library_name}.tcl"
    with open(tmp_dc_script_name, "w") as fdc:
        fdc.write(tmp_dc_script)
    subprocess.run(["dc_shell", "-64bit", "-output_log_file", f"lib2db_{library_name}.log", "-f",  tmp_dc_script_name])
    subprocess.run(["rm", tmp_dc_script_name])

if __name__ == "__main__":

    if len(sys.argv) < 2:
        print("\n[Error] Missing directory argument")
        print("[Error] Usage: python lib2db.py <directory_containing_lib>\n")
        sys.exit()
        
    dir_name = sys.argv[1]
    os.chdir(dir_name)
    for fname_lib in glob.glob("*.lib"):
        convert_lib_to_db(fname_lib)