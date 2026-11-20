# Installs the C++ release archive. Its CMake project compiles the C++ half of the bindings with the triplet's toolchain
# against the prebuilt Rust library; building that library here would need a Rust toolchain, which vcpkg doesn't provide.
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# Written by .github/workflows/simlink-source-sdk.yml.
set(hashes
    win-x64 b7d56aa687132c472dcbf0d4dc39877304699b40359fea9d496aa54029a58c7af91028d8f0cfc7942338a2c3afd8f67b79a0ec6efe322bab8625863c203d6765
    linux-x64 28df503c7c2f64458efacfc31909f41ae8de2d182d5de0c972190227bb8f90fdd12d8a162a52f6a1ac665522d6aedb02336f9aa8bfb12f09aa4569e3edd4e0a6
    osx 7bc09829498d203168f0e4ebdb707a5114d47556680203a02d08dfe6e2f14867d282dd79a6867e491340db5b41990bb472a928f613f511910568db8016b7bb35
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
