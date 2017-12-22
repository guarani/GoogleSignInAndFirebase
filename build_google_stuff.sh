
root=$PWD

binary=GoogleSignInDependencies
signInFrameworkDir=./google_signin_sdk_4_0_1
archs=(armv7 x86_64 arm64 i386)
duplicateClasses=(GTMLogger GTMNSDictionary+URLArguments GTMSessionFetcher GTMSessionFetcherService GTMSessionUploadFetcher)
hackDir=hack

framework=$binary.framework
originalFramework=$signInFrameworkDir/$framework
hackTmpDir=$hackDir/tmp

function extractBinaries() {
    hackTmpDir=$1
    arch=$2
    archDir=$hackTmpDir/$arch
    mkdir $archDir
    echo "Extracting classes from $archDir/$arch.a ..."
    lipo -thin $arch $hackTmpDir/$binary -output $archDir/$arch.a
    cd $archDir
    ar -x $arch.a
    cd $root
}

function removeDuplicateClasses() {
    echo "Removing duplicated classes ..."
    cd $1/$2
    wildcard="_*.o"
    for prefix in ${duplicateClasses[@]}
    do
        echo "Removing $prefix$wildcard ..."
        rm -fr $prefix$wildcard
    done
    cd $root
}

function buildNewBinary() {
    hackTmpDir=$1
    arch=$2
    echo "Building new binary for $arch ..."
    libtool -static $hackTmpDir/$arch/*.o -o $hackTmpDir/$arch.a
}

echo "Cleaning $hack ..."
rm -fr $hackDir
mkdir -p $hackTmpDir
cp $originalFramework/$binary $hackTmpDir

echo "Extracting binary data from $originalFramework ..."
binaryFiles=
for arch in ${archs[@]}
do
    extractBinaries $hackTmpDir $arch
    removeDuplicateClasses $hackTmpDir $arch
    buildNewBinary $hackTmpDir $arch
    binaryFiles+=" $hackTmpDir/$arch.a"
done

echo "Building new framework file ..."
cp -R $originalFramework $hackDir
lipo -create $binaryFiles -output $hackDir/$framework/$binary

echo "Removing tmp files ..."
rm -fr $hackTmpDir

echo "Moving old framework out of the way ..."
mkdir $signInFrameworkDir/old
mv $originalFramework $signInFrameworkDir/old

echo "Done."
