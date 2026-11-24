# Installs the C++ release archive. Its CMake project compiles the C++ half of the bindings with the triplet's toolchain
# against the prebuilt Rust library; building that library here would need a Rust toolchain, which vcpkg doesn't provide.
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# Written by .github/workflows/simlink-source-sdk.yml.
set(hashes
    win-x64 cd0cbea39140fe27842a16042bd33cb6ade700663549955edb88beabfb87262cedac0981bbe7cae7b35918ed968bdd2aa5fcb7c2699f7c75f14c7582566e7620
    linux-x64 6f3e9a9fcb8904aa658ef1d53f9887aa50f553502413845ed0de99336a1e7bfed36fa9c7a83c44352a5cf72a531d11628c31e8947a3d6406fae9215c751cb3c3
    osx d776785f3b9d935bccfe7e534320ef79bc15808cd4fa83d33ff812ed97489119f9e98e99bdcac9b9f091ff50a118b5d3ba05f6c391575a1fc6c0aaf4da54e797
)

if(VCPKG_TARGET_IS_WINDOWS)
    set(rid win-x64)
    # Debug builds compile the bindings /MDd against the Rust library's /MD objects.
    set(VCPKG_POLICY_SKIP_CRT_LINKAGE_CHECK enabled)
elseif(VCPKG_TARGET_IS_LINUX)
    set(rid linux-x64)
else()
    # One universal library serves both architectures.
    set(rid osx)
endif()
list(FIND hashes "${rid}" index)
math(EXPR index "${index} + 1")
list(GET hashes ${index} sha512)

set(name "simlink-source-sdk-cpp-${VERSION}-${rid}")
vcpkg_download_distfile(archive
    URLS "https://github.com/Navigraph/simlink-source-sdk/releases/download/v${VERSION}/${name}.zip"
    FILENAME "${name}.zip"
    SHA512 ${sha512}
)
vcpkg_extract_source_archive(source ARCHIVE "${archive}")

vcpkg_cmake_configure(SOURCE_PATH "${source}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${source}/LICENSE")
