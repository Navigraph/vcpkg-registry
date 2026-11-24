# Installs the C++ release archive. Its CMake project compiles the C++ half of the bindings with the triplet's toolchain
# against the prebuilt Rust library; building that library here would need a Rust toolchain, which vcpkg doesn't provide.
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# Written by .github/workflows/simlink-source-sdk.yml.
set(hashes
    win-x64 67095c4fda955f0640c90a57c5e8a95874e03b5c2a75760977032ef2152974b3dee24ad79d0dcce99e8c914bed4a618ede3fb3bb2cf90c758d907add96d78c67
    linux-x64 0862ec404b9c9df6cda691af85274b40efc27446d80b57bfc00d02579c85f5cd7df2ed0c9ed9a2d0e4dd5d836e1bf4ab122b825b119c6a92d37c4a8600d5fff5
    osx 180e440981d0a8c621f4ce7627b2fbf803c2c268db0e115d9308ae1bdffde45db405c0c418c2369a3fd0698aa9618635c99399221e7460da9474cc63488b11c3
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
