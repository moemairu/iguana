#!/bin/bash
# build-toolchain.sh — Build the GBA matching compiler from GCC 2.95.3 sources
#
# This script downloads, patches, and builds two cross-compilers from the
# upstream GCC 2.95.3 source (GNU FTP archive):
#   1. arm-elf   — ARM mode (32-bit instructions)
#   2. thumb-coff — Thumb mode (16-bit instructions, used for most GBA game code)
#
# Prerequisites:
#   - arm-none-eabi-binutils (assembler, linker, etc.)
#   - gcc (host compiler, any modern version)
#   - make, curl, tar
#
# The script is idempotent: re-running it will skip already-completed steps.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GCC_VERSION="2.95.3"
GCC_URL="https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-core-${GCC_VERSION}.tar.gz"
GCC_TARBALL="${SCRIPT_DIR}/gcc-core-${GCC_VERSION}.tar.gz"
GCC_SRC="${SCRIPT_DIR}/gcc-${GCC_VERSION}"
INSTALL_DIR="${SCRIPT_DIR}/install"

# Host compiler flags for building the old GCC on modern systems
export CC="gcc -std=gnu89"
export CFLAGS="-g -O2 -std=gnu89 -Wno-error -w"

echo "=== GBA Matching Compiler Build ==="
echo "Working directory: ${SCRIPT_DIR}"

# ─── Step 1: Download GCC source ────────────────────────────────────────────
if [ ! -f "${GCC_TARBALL}" ]; then
    echo "[1/6] Downloading GCC ${GCC_VERSION}..."
    curl -L -o "${GCC_TARBALL}" "${GCC_URL}"
else
    echo "[1/6] GCC ${GCC_VERSION} tarball already present, skipping download."
fi

# ─── Step 2: Extract ────────────────────────────────────────────────────────
if [ ! -d "${GCC_SRC}" ]; then
    echo "[2/6] Extracting..."
    cd "${SCRIPT_DIR}" && tar xzf "${GCC_TARBALL}"
else
    echo "[2/6] GCC source already extracted, skipping."
fi

# ─── Step 3: Patch ──────────────────────────────────────────────────────────
echo "[3/6] Applying patches..."

# Patch 001: Fix lvalue cast in ARM backend (modern GCC rejects cast-as-lvalue)
sed -i 's/arm_prog_mode = TARGET_APCS_32/arm_prgmode = TARGET_APCS_32/' \
    "${GCC_SRC}/gcc/config/arm/arm.c" 2>/dev/null || true

# Replace old config.guess/config.sub with modern versions (for x86_64 support)
if command -v libtool &>/dev/null || [ -f /usr/share/libtool/build-aux/config.guess ]; then
    find "${GCC_SRC}" -name config.guess \
        -exec cp /usr/share/libtool/build-aux/config.guess {} \;
    find "${GCC_SRC}" -name config.sub \
        -exec cp /usr/share/libtool/build-aux/config.sub {} \;
elif [ -d /usr/share/automake-* ]; then
    AUTOMAKE_DIR=$(ls -d /usr/share/automake-* | head -1)
    find "${GCC_SRC}" -name config.guess -exec cp "${AUTOMAKE_DIR}/config.guess" {} \;
    find "${GCC_SRC}" -name config.sub -exec cp "${AUTOMAKE_DIR}/config.sub" {} \;
fi

# Patch 002: Preserve 'thumb' as a separate CPU in modern config.sub
# (modern config.sub maps thumb→arm, breaking GCC 2.95.3's separate thumb backend)
find "${GCC_SRC}" -name config.sub -exec sed -i \
    's/strongarm-\* | thumb-\*)/strongarm-*)/' {} \;
# Add thumb/thumbel to valid CPU list (after armv*)
find "${GCC_SRC}" -name config.sub -exec sed -i \
    '/| armv\* \\/a\\t\t\t| thumb | thumbel \\' {} \;

echo "  Patches applied."

# ─── Step 4: Create binutils symlinks ───────────────────────────────────────
echo "[4/6] Setting up binutils symlinks..."
mkdir -p "${INSTALL_DIR}/bin"
mkdir -p "${INSTALL_DIR}/arm-elf/bin"
mkdir -p "${INSTALL_DIR}/thumb-coff/bin"

for tool in as ld ar ranlib nm objcopy objdump strip; do
    ln -sf "$(which arm-none-eabi-${tool})" "${INSTALL_DIR}/bin/arm-elf-${tool}"
    ln -sf "$(which arm-none-eabi-${tool})" "${INSTALL_DIR}/bin/thumb-elf-${tool}"
    ln -sf "$(which arm-none-eabi-${tool})" "${INSTALL_DIR}/bin/thumb-coff-${tool}"
    ln -sf "$(which arm-none-eabi-${tool})" "${INSTALL_DIR}/arm-elf/bin/${tool}"
    ln -sf "$(which arm-none-eabi-${tool})" "${INSTALL_DIR}/thumb-coff/bin/${tool}"
done

export PATH="${INSTALL_DIR}/bin:${PATH}"

# ─── Step 5: Build ARM compiler ────────────────────────────────────────────
BUILD_ARM="${SCRIPT_DIR}/build"
if [ ! -f "${BUILD_ARM}/gcc/xgcc" ]; then
    echo "[5/6] Building ARM compiler (arm-elf target)..."
    mkdir -p "${BUILD_ARM}"
    cd "${BUILD_ARM}" && rm -rf *
    "${GCC_SRC}/configure" \
        --target=arm-elf \
        --host=i686-pc-linux-gnu \
        --build=i686-pc-linux-gnu \
        --prefix="${INSTALL_DIR}" \
        --enable-languages=c \
        --disable-shared \
        --disable-threads \
        --disable-nls \
        --without-headers
    make || true  # docs may fail, that's OK
else
    echo "[5/6] ARM compiler already built, skipping."
fi

# Verify ARM cc1 exists
if [ ! -f "${BUILD_ARM}/gcc/cc1" ]; then
    echo "ERROR: ARM cc1 not found. Build failed." >&2
    exit 1
fi

# ─── Step 6: Build Thumb compiler ──────────────────────────────────────────
BUILD_THUMB="${SCRIPT_DIR}/build-thumb"
if [ ! -f "${BUILD_THUMB}/gcc/xgcc" ]; then
    echo "[6/6] Building Thumb compiler (thumb-coff target)..."
    mkdir -p "${BUILD_THUMB}"
    cd "${BUILD_THUMB}" && rm -rf *
    "${GCC_SRC}/configure" \
        --target=thumb-coff \
        --host=i686-pc-linux-gnu \
        --build=i686-pc-linux-gnu \
        --prefix="${INSTALL_DIR}" \
        --enable-languages=c \
        --disable-shared \
        --disable-threads \
        --disable-nls \
        --without-headers \
        --with-newlib \
        --disable-multilib
    make || true  # docs may fail, that's OK
else
    echo "[6/6] Thumb compiler already built, skipping."
fi

# Verify Thumb cc1 exists
if [ ! -f "${BUILD_THUMB}/gcc/cc1" ]; then
    echo "ERROR: Thumb cc1 not found. Build failed." >&2
    exit 1
fi

# ─── Install ────────────────────────────────────────────────────────────────
echo "Installing compilers..."
cp "${BUILD_ARM}/gcc/xgcc"    "${INSTALL_DIR}/bin/agb-arm-cc"
cp "${BUILD_ARM}/gcc/cc1"     "${INSTALL_DIR}/bin/arm-elf-cc1"
cp "${BUILD_ARM}/gcc/libgcc.a" "${INSTALL_DIR}/lib-arm-libgcc.a"

cp "${BUILD_THUMB}/gcc/xgcc"    "${INSTALL_DIR}/bin/agb-thumb-cc"
cp "${BUILD_THUMB}/gcc/cc1"     "${INSTALL_DIR}/bin/thumb-coff-cc1"
cp "${BUILD_THUMB}/gcc/libgcc.a" "${INSTALL_DIR}/lib-thumb-libgcc.a"

echo ""
echo "=== Build Complete ==="
echo "ARM compiler:   ${INSTALL_DIR}/bin/agb-arm-cc"
echo "Thumb compiler: ${INSTALL_DIR}/bin/agb-thumb-cc"
echo ""
echo "Test with:"
echo "  echo 'int add(int a, int b) { return a + b; }' > test.c"
echo "  ${INSTALL_DIR}/bin/agb-thumb-cc -B${BUILD_THUMB}/gcc/ -O2 -S test.c"
echo "  ${INSTALL_DIR}/bin/agb-arm-cc -B${BUILD_ARM}/gcc/ -O2 -mthumb-interwork -S test.c"
