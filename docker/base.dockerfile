FROM faasm/cpp-root:0.4.9
# Note - we don't often rebuild cpp-root so this dep may be behind

# Put code in place
COPY . /usr/local/code/faasm

# Install Eigen
WORKDIR /usr/local/code/faasm/ansible
RUN ansible-playbook eigen.yml

# Out of tree build
WORKDIR /faasm/build

# Build WAVM and WAMR to avoid repetition in other dockerfiles
RUN cmake \
    -GNinja \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++-10 \
    -DCMAKE_C_COMPILER=/usr/bin/clang-10 \
    -DCMAKE_BUILD_TYPE=Release \
    /usr/local/code/faasm

RUN cmake --build . --target libWAVM
RUN cmake --build . --target wamrlib
