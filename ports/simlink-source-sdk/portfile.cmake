# Installs the C++ release archive. Its CMake project compiles the C++ half of the bindings with the triplet's toolchain
# against the prebuilt Rust library; building that library here would need a Rust toolchain, which vcpkg doesn't provide.
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# Written by .github/workflows/simlink-source-sdk.yml.
set(hashes
    win-x64 097ea1b8418dd92df14d7ba08ad23abaf501d4b74656df93d20ff9777b10c5281a066fd9acce962666b576cb934eac8da3963818488f6770b02763b7b38690e5
    linux-x64 2655eba46e7f5930a461658b213c8c23142216b7a770c67f8adec82e86fc2fdbb7b3d6459d6f919a6ecc4ad9d76256cf6dc668e0f5eab5f75bafaf73f7712027
    osx b52f2771ec03d96d4336c4878d6fb36fc72272bfe2ae6dbc8210c17e7b421aa3d6c347f9bee2690aaf8b2e054adf3d94ea7683b8898cd41de5b1053b603303f3
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
