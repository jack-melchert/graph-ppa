FLOW_ROOT=`dirname $0`
DEFAULT_FLOW_CONFIG=$FLOW_ROOT/config.sh

# Set up defaults. 
timestamp=$(date +%Y%m%d_%H%M)
build="synth_$timestamp"
modules=""

source $DEFAULT_FLOW_CONFIG

if [ -z "$modules" ] && [ -z "$TOP_NAMES" ] ; then
    echo "[ERROR]: TOP_NAMES cannot be empty. Aborting"
    exit
elif [ -z "$modules" ] ; then
    modules=$TOP_NAMES
fi

export BUILD_NAME=$FLOW_ROOT/../outputs/synth/$build
export DB_DIR="$BUILD_NAME/db"
export CONS_DIR="$BUILD_NAME/cons"
export DEF_DIR="$BUILD_NAME/def"
export DLIB_DIR="$BUILD_NAME/design_lib"
export FV_DIR="$BUILD_NAME/fv"
export LOG_DIR="$BUILD_NAME/log"
export MW_DIR="$BUILD_NAME/mw"
export NET_DIR="$BUILD_NAME/net"
export REPORT_DIR="$BUILD_NAME/report"
export SCRIPTS_DIR="$BUILD_NAME/scripts"
export SEARCH_PATH=". $BUILD_NAME/src"


if [ -d  $BUILD_NAME ] ; then 
    echo "[INFO]: Cleaning up previous build directory $BUILD_NAME..."
    rm -rf $BUILD_NAME
fi
if [ ! -d "$BUILD_NAME" ] ; then
    echo "[INFO]: Creating sandbox $BUILD_NAME ... "
    mkdir -p $BUILD_NAME
    mkdir -p $BUILD_NAME/cons
    mkdir -p $BUILD_NAME/log
    mkdir -p $BUILD_NAME/report
    mkdir -p $BUILD_NAME/db
    mkdir -p $BUILD_NAME/scripts
    mkdir -p $BUILD_NAME/design_lib
    mkdir -p $BUILD_NAME/mw
    mkdir -p $BUILD_NAME/fv
    mkdir -p $BUILD_NAME/def
    mkdir -p $BUILD_NAME/net
    mkdir -p $BUILD_NAME/src
    for module in $modules 
    do 
        mkdir -p $BUILD_NAME/fv/${module}
    done

    echo "[INFO]: Copying flow source code into $BUILD_NAME/scripts/ ..."
    cp -Lrf ${FLOW_ROOT}/* $BUILD_NAME/scripts/

    if [ "$DEF" != "" ] && [ -d "$DEF" ] ; then
        echo "[INFO]: Copying DEF files if available, into $BUILD_NAME/def..."
        cp -Lrf $DEF/* $BUILD_NAME/def/
    fi 
    if [ "$CONS" != "" ] && [ -d "$CONS" ] ; then
        echo "[INFO]: Copying constraint files if available, into $BUILD_NAME/cons ..."
        cp -Lrf $CONS/* $BUILD_NAME/cons/
    fi 
fi

echo "[INFO]: Searching for RTL with extension: $RTL_EXTENSIONS "
for path in ${RTL_SEARCH_PATH}
do 
    for ext in ${RTL_EXTENSIONS}
    do 
        cp -Lrf $path/*$ext $BUILD_NAME/src/ >& /dev/null
    done
done

echo "[INFO]: Copying all files in flist"
for path in $RTL_VERILOG
do 
    cp -Lrf $path $BUILD_NAME/src/ >& /dev/null
done

echo "[INFO]: Searching for INCLUDE files with extension: $RTL_INCLUDE_EXTENSIONS "
for path in ${RTL_INCLUDE_SEARCH_PATH}
do 
    for ext in ${RTL_INCLUDE_EXTENSIONS}
    do 
        cp -Lrf $path/*$ext $BUILD_NAME/src/ >& /dev/null
    done 
done

EXTRA_RTL_LIST=""
for file in ${EXTRA_RTL}
do
    cp -Lrf $file $BUILD_NAME/src
    FILE_NAME=$(basename $file)
    EXTRA_RTL_LIST+=$BUILD_NAME/src/$FILE_NAME
done
echo "[INFO]: Copied all RTL and include files into $BUILD_NAME/src"


echo "[INFO]: Removing any designware components from $BUILD_NAME/src"
DW_FILES=$(ls $BUILD_NAME/src/DW_*)
if [ ! -z "$DW_FILES" ] ; then
    rm -rf $BUILD_NAME/src/DW_*
fi


for module in $modules
do
    rm -rf $BUILD_NAME/scripts/${module}.files.vc
    echo "-y $BUILD_NAME/src" > $BUILD_NAME/scripts/${module}.files.vc
    echo "+incdir+$RTL_INCLUDE_SEARCH_PATH" >> $BUILD_NAME/scripts/${module}.files.vc
    for ext in ${RTL_EXTENSIONS}
    do 
        echo "+libext+$ext" >> $BUILD_NAME/scripts/${module}.files.vc
    done

    echo "+define+DISABLE_TESTPOINTS" >> $BUILD_NAME/scripts/${module}.files.vc
    echo "+define+NV_SYNTHESIS " >> $BUILD_NAME/scripts/${module}.files.vc
    echo "+define+RAM_INTERFACE " >> $BUILD_NAME/scripts/${module}.files.vc
    # echo "$module.v" >> $BUILD_NAME/scripts/${module}.files.vc

    for file in $RTL_VERILOG
    do
        basename -sh $file >> $BUILD_NAME/scripts/${module}.files.vc
    done

    # Common "library" modules
    for file in $EXTRA_RTL_LIST
    do
        echo "-v $file" >> $BUILD_NAME/scripts/${module}.files.vc
    done
    echo "[INFO]: Generated module input dependency file $BUILD_NAME/scripts/${module}.files.vc"

done



if [ -z "$DC_PATH" ] ; then
    echo "[ERROR]: DC_PATH cannot be empty. Aborting"
    exit 1
fi


echo "[INFO]: Running DC"
export SYN_MODE="wlm"
for module in $modules
do 
    export MODULE=$module
    export RTL_DEPS="$BUILD_NAME/scripts/${module}.files.vc"
    COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX/\<MODULE\>/$module}"
    COMMAND_PREFIX_PATCHED="${COMMAND_PREFIX_PATCHED/\<LOG\>/$LOG_DIR}"
    echo $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell -no_gui -f $BUILD_NAME/scripts/dc_run.tcl 
    $COMMAND_PREFIX_PATCHED $DC_PATH/dc_shell -no_gui -f $BUILD_NAME/scripts/dc_run.tcl 
done
