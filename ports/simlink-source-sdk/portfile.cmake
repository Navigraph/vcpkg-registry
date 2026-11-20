# Installs the C++ release archive. Its CMake project compiles the C++ half of the bindings with the triplet's toolchain
# against the prebuilt Rust library; building that library here would need a Rust toolchain, which vcpkg doesn't provide.
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# Written by .github/workflows/simlink-source-sdk.yml.
set(hashes
    win-x64 0
    linux-x64 0
    osx 0
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
